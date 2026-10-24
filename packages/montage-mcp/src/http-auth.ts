/**
 * Google OAuth for the HTTP transport (opt-in via `MONTAGE_MCP_AUTH=google`).
 *
 * Ported from montage-web's `internal/montage-mcp/src/auth.ts`:
 * - This server acts as the MCP OAuth authorization server and delegates the
 *   user login to Google (restricted to the `wantedlab.com` workspace).
 * - The Google ID token is exchanged for a Firebase ID token, which becomes the
 *   MCP access token and is verified with Firebase Admin on every request.
 * - Dynamic client registrations and refresh tokens live in Firestore
 *   (`clients`, `refreshTokens` collections); short-lived pending
 *   authorizations and auth codes stay in memory.
 * - Unlike montage-web, `/authorize` first shows a consent page naming the
 *   client and its redirect host. Dynamic registration is open, so without it
 *   a malicious client could silently obtain a token for a signed-in user.
 *
 * `firebase-admin` is loaded with a dynamic import inside `createGoogleAuth`
 * so Firebase is never initialized while auth is off.
 */
import { randomBytes, randomUUID, timingSafeEqual } from "node:crypto";
import type { Request, RequestHandler, Response } from "express";
import {
  AccessDeniedError,
  InvalidGrantError,
  InvalidTokenError,
  ServerError,
} from "@modelcontextprotocol/sdk/server/auth/errors.js";
import type {
  AuthorizationParams,
  OAuthServerProvider,
} from "@modelcontextprotocol/sdk/server/auth/provider.js";
import type { AuthInfo } from "@modelcontextprotocol/sdk/server/auth/types.js";
import type {
  OAuthClientInformationFull,
  OAuthTokens,
} from "@modelcontextprotocol/sdk/shared/auth.js";
import type { Auth } from "firebase-admin/auth";
import type { Firestore } from "firebase-admin/firestore";
import { escapeHtml } from "./index-page.js";
import { logDebug } from "./core/logger.js";

export const ALLOWED_DOMAIN = "wantedlab.com";
const SCOPES = ["openid", "email", "profile"];
const FETCH_TIMEOUT_MS = 10_000;
const DEFAULT_FIRESTORE_DATABASE = "montage-storage";
const DEFAULT_TRUST_PROXY_HOPS = 1;
const FIREBASE_APP_NAME = "montage-ios-mcp";

const TTL = {
  PENDING_AUTH: 10 * 60 * 1000, // 10min
  AUTH_CODE: 5 * 60 * 1000, // 5min
} as const;
/** Upper bound per in-memory map, so unauthenticated /authorize spam can't grow memory unbounded. */
const TTL_MAP_MAX_ENTRIES = 10_000;

export interface GoogleAuthConfig {
  googleClientId: string;
  googleClientSecret: string;
  firebaseApiKey: string;
  firebaseProjectId: string;
  firebaseClientEmail: string;
  firebasePrivateKey: string;
  firestoreDatabaseId: string;
  /** Public origin of this server (no trailing slash) — OAuth issuer and Google redirect base. */
  publicUrl: string;
  /** Express `trust proxy` hop count, so rate limiting keys on the real client IP. */
  trustProxyHops: number;
}

const REQUIRED_ENV = [
  "GOOGLE_CLIENT_ID",
  "GOOGLE_CLIENT_SECRET",
  "FIREBASE_API_KEY",
  "FIREBASE_PROJECT_ID",
  "FIREBASE_CLIENT_EMAIL",
  "FIREBASE_PRIVATE_KEY",
  "MONTAGE_MCP_PUBLIC_URL",
] as const;

/**
 * Resolve auth settings. Returns `null` when `MONTAGE_MCP_AUTH` is unset.
 * Throws on an unknown mode or missing variables so a misconfigured public
 * server fails at boot instead of silently running unauthenticated.
 */
export function loadAuthConfig(env: NodeJS.ProcessEnv = process.env): GoogleAuthConfig | null {
  const mode = env.MONTAGE_MCP_AUTH?.trim() ?? "";
  if (mode === "") return null;
  if (mode !== "google") {
    throw new Error(`MONTAGE_MCP_AUTH="${mode}" is not supported. Use "google" or leave it unset.`);
  }

  const values: Partial<Record<(typeof REQUIRED_ENV)[number], string>> = {};
  const missing: string[] = [];
  for (const key of REQUIRED_ENV) {
    const v = env[key]?.trim();
    if (v) values[key] = v;
    else missing.push(key);
  }
  if (missing.length > 0) {
    throw new Error(`MONTAGE_MCP_AUTH=google requires: ${missing.join(", ")}`);
  }

  const publicUrlRaw = values.MONTAGE_MCP_PUBLIC_URL!.replace(/\/+$/, "");
  try {
    new URL(publicUrlRaw);
  } catch {
    throw new Error(`MONTAGE_MCP_PUBLIC_URL is not a valid URL: ${publicUrlRaw}`);
  }

  const hopsRaw = env.MONTAGE_MCP_TRUST_PROXY?.trim();
  const hops = hopsRaw ? Number(hopsRaw) : DEFAULT_TRUST_PROXY_HOPS;

  return {
    googleClientId: values.GOOGLE_CLIENT_ID!,
    googleClientSecret: values.GOOGLE_CLIENT_SECRET!,
    firebaseApiKey: values.FIREBASE_API_KEY!,
    firebaseProjectId: values.FIREBASE_PROJECT_ID!,
    firebaseClientEmail: values.FIREBASE_CLIENT_EMAIL!,
    // Env files usually carry the PEM with literal "\n" sequences.
    firebasePrivateKey: values.FIREBASE_PRIVATE_KEY!.replace(/\\n/g, "\n"),
    firestoreDatabaseId: env.FIREBASE_DATABASE_ID?.trim() || DEFAULT_FIRESTORE_DATABASE,
    publicUrl: publicUrlRaw,
    trustProxyHops: Number.isInteger(hops) && hops >= 0 ? hops : DEFAULT_TRUST_PROXY_HOPS,
  };
}

/** What `createApp` needs to mount auth. */
export interface HttpAuth {
  provider: OAuthServerProvider;
  issuerUrl: URL;
  trustProxyHops: number;
  handleGoogleCallback: RequestHandler;
  /** POST target of the consent page (`application/x-www-form-urlencoded`). */
  handleConsent: RequestHandler;
}

/**
 * Map with per-entry expiry. Expired entries are swept on every `set`, and the
 * oldest entry is evicted once `maxEntries` is reached.
 */
export class TtlMap<K, V> {
  private map = new Map<K, { value: V; expiresAt: number }>();

  constructor(private readonly maxEntries: number = TTL_MAP_MAX_ENTRIES) {}

  get size(): number {
    return this.map.size;
  }

  set(key: K, value: V, ttl: number): void {
    const now = Date.now();
    for (const [k, entry] of this.map) {
      if (now > entry.expiresAt) this.map.delete(k);
    }
    this.map.delete(key);
    while (this.map.size >= this.maxEntries) {
      // Map iterates in insertion order — the first key is the oldest.
      const oldest = this.map.keys().next();
      if (oldest.done) break;
      this.map.delete(oldest.value);
    }
    this.map.set(key, { value, expiresAt: now + ttl });
  }

  get(key: K): V | undefined {
    const entry = this.map.get(key);
    if (!entry) return undefined;
    if (Date.now() > entry.expiresAt) {
      this.map.delete(key);
      return undefined;
    }
    return entry.value;
  }

  delete(key: K): void {
    this.map.delete(key);
  }
}

interface PendingAuth {
  clientId: string;
  redirectUri: string;
  originalState?: string;
  codeChallenge: string;
}

interface PendingConsent extends PendingAuth {
  clientName: string;
  /** Value of the consent cookie set on the browser that loaded the consent page. */
  browserBinding: string;
}

/** Value of a cookie from the raw `Cookie` header (no cookie-parser middleware here). */
function readCookie(req: Request, name: string): string | undefined {
  const header = req.headers.cookie;
  if (!header) return undefined;
  for (const part of header.split(";")) {
    const eq = part.indexOf("=");
    if (eq !== -1 && part.slice(0, eq).trim() === name) return part.slice(eq + 1).trim();
  }
  return undefined;
}

function safeEqual(a: string, b: string): boolean {
  const ab = Buffer.from(a);
  const bb = Buffer.from(b);
  return ab.length === bb.length && timingSafeEqual(ab, bb);
}

/** Origin of the request per `Origin`, falling back to `Referer`; `undefined` when neither parses. */
function requestOrigin(req: Request): string | undefined {
  const raw = req.headers.origin ?? req.headers.referer;
  if (typeof raw !== "string") return undefined;
  try {
    return new URL(raw).origin;
  } catch {
    return undefined;
  }
}

interface StoredAuthCode {
  googleCode: string;
  clientId: string;
  codeChallenge: string;
}

interface StoredRefreshToken {
  clientId: string;
  googleRefreshToken: string;
}

interface GoogleTokens {
  access_token: string;
  id_token: string;
  expires_in: number;
  refresh_token?: string;
}

/**
 * Read the `hd` (hosted domain) claim from a Google ID token. The token comes
 * straight from Google's token endpoint over TLS, so the payload is read
 * without re-verifying the signature.
 */
function googleHostedDomain(idToken: string): string | undefined {
  try {
    const payload = JSON.parse(Buffer.from(idToken.split(".")[1] ?? "", "base64url").toString("utf-8"));
    return typeof payload?.hd === "string" ? payload.hd : undefined;
  } catch {
    return undefined;
  }
}

async function loadFirebaseAdmin() {
  try {
    return await Promise.all([
      import("firebase-admin/app"),
      import("firebase-admin/auth"),
      import("firebase-admin/firestore"),
    ]);
  } catch (err) {
    const reason = err instanceof Error ? err.message : String(err);
    throw new Error(
      `MONTAGE_MCP_AUTH=google requires the optional dependency "firebase-admin", which failed to load (${reason}). ` +
        "Install it with `npm install firebase-admin` (or don't omit optional dependencies).",
    );
  }
}

/** Initialize Firebase Admin (dynamic import) and build the auth wiring. */
export async function createGoogleAuth(cfg: GoogleAuthConfig): Promise<HttpAuth> {
  const [{ cert, getApps, initializeApp }, { getAuth }, { getFirestore }] = await loadFirebaseAdmin();
  const firebaseApp =
    getApps().find((a) => a.name === FIREBASE_APP_NAME) ??
    initializeApp(
      {
        credential: cert({
          projectId: cfg.firebaseProjectId,
          clientEmail: cfg.firebaseClientEmail,
          privateKey: cfg.firebasePrivateKey,
        }),
      },
      FIREBASE_APP_NAME,
    );
  return buildGoogleAuth(cfg, getAuth(firebaseApp), getFirestore(firebaseApp, cfg.firestoreDatabaseId));
}

function buildGoogleAuth(cfg: GoogleAuthConfig, firebaseAuth: Auth, firestore: Firestore): HttpAuth {
  const refreshTokensCollection = firestore.collection("refreshTokens");
  const clientsCollection = firestore.collection("clients");
  const consents = new TtlMap<string, PendingConsent>();
  const pendingAuths = new TtlMap<string, PendingAuth>();
  const authCodes = new TtlMap<string, StoredAuthCode>();
  const googleRedirectUri = `${cfg.publicUrl}/oauth/google/callback`;
  const consentAction = `${cfg.publicUrl}/oauth/consent`;
  const publicOrigin = new URL(cfg.publicUrl).origin;
  // `__Host-` cookies require Secure, which browsers only honor over https. The
  // SDK issuer check already limits plain http to localhost/127.0.0.1, so that
  // case (local development) falls back to an unprefixed, non-Secure cookie.
  const secureCookie = new URL(cfg.publicUrl).protocol === "https:";
  const consentCookie = secureCookie ? "__Host-mcp_consent" : "mcp_consent";
  const consentCookieAttrs = `HttpOnly; SameSite=Strict; Path=/${secureCookie ? "; Secure" : ""}`;

  const clientRegistrationStore = {
    async set(clientId: string, client: OAuthClientInformationFull): Promise<void> {
      try {
        // Firestore rejects `undefined` fields — round-trip through JSON to drop them.
        await clientsCollection.doc(clientId).set(JSON.parse(JSON.stringify(client)));
      } catch {
        throw new ServerError("Failed to persist client registration");
      }
    },
    async get(clientId: string): Promise<OAuthClientInformationFull | undefined> {
      try {
        const doc = await clientsCollection.doc(clientId).get();
        if (!doc.exists) return undefined;
        return doc.data() as OAuthClientInformationFull;
      } catch {
        throw new ServerError("Failed to load client registration");
      }
    },
  };

  const refreshTokenStore = {
    async set(mcpToken: string, value: StoredRefreshToken): Promise<void> {
      await refreshTokensCollection.doc(mcpToken).set({
        clientId: value.clientId,
        googleRefreshToken: value.googleRefreshToken,
      });
    },
    async get(mcpToken: string, clientId: string): Promise<string | undefined> {
      const doc = await refreshTokensCollection.doc(mcpToken).get();
      if (!doc.exists) return undefined;
      const data = doc.data() as StoredRefreshToken;
      if (data.clientId !== clientId) return undefined;
      return data.googleRefreshToken;
    },
    async delete(mcpToken: string): Promise<void> {
      await refreshTokensCollection.doc(mcpToken).delete();
    },
  };

  async function fetchOrServerError(
    url: string,
    init: RequestInit,
    label: string,
  ): Promise<globalThis.Response> {
    return fetch(url, { ...init, signal: AbortSignal.timeout(FETCH_TIMEOUT_MS) }).catch(
      (error: unknown) => {
        if (error instanceof DOMException && error.name === "TimeoutError") {
          throw new ServerError(`${label} timed out`);
        }
        throw new ServerError(`${label} failed`);
      },
    );
  }

  /** Exchange a Google ID token for a Firebase ID token, enforcing the workspace domain. */
  async function signInToFirebase(googleIdToken: string): Promise<{ idToken: string; expiresIn: string }> {
    // `hd` is set only for Google Workspace accounts of that domain — an email
    // suffix alone can be satisfied by a consumer account on an alias.
    if (googleHostedDomain(googleIdToken) !== ALLOWED_DOMAIN) {
      throw new AccessDeniedError(`Access restricted to the ${ALLOWED_DOMAIN} Google Workspace`);
    }
    const res = await fetchOrServerError(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=${cfg.firebaseApiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          postBody: `id_token=${googleIdToken}&providerId=google.com`,
          requestUri: cfg.publicUrl,
          returnIdToken: true,
          returnSecureToken: true,
        }),
      },
      "Firebase sign-in",
    );
    if (!res.ok) throw new ServerError("Firebase sign-in failed");
    const tokens = (await res.json()) as { idToken: string; expiresIn: string; email?: string };
    if (!tokens.email?.endsWith(`@${ALLOWED_DOMAIN}`)) {
      throw new AccessDeniedError(`Access restricted to @${ALLOWED_DOMAIN} accounts`);
    }
    return tokens;
  }

  const provider: OAuthServerProvider = {
    clientsStore: {
      getClient: async (clientId: string) => clientRegistrationStore.get(clientId),
      registerClient: async (client: OAuthClientInformationFull) => {
        await clientRegistrationStore.set(client.client_id, client);
        return client;
      },
    },

    // The SDK authorize handler has already matched `redirectUri` against the
    // client's registered URIs. Render the consent page instead of redirecting.
    async authorize(client: OAuthClientInformationFull, params: AuthorizationParams, res: Response) {
      const consentToken = randomUUID();
      const browserBinding = randomBytes(32).toString("base64url");
      const clientName = client.client_name?.trim() || client.client_id;
      consents.set(
        consentToken,
        {
          clientId: client.client_id,
          clientName,
          browserBinding,
          redirectUri: params.redirectUri,
          codeChallenge: params.codeChallenge,
          ...(params.state !== undefined ? { originalState: params.state } : {}),
        },
        TTL.PENDING_AUTH,
      );
      res
        .status(200)
        .set({
          "Cache-Control": "no-store",
          "Content-Security-Policy": consentPageCsp(params.redirectUri),
          "X-Frame-Options": "DENY",
          // Not `no-referrer`: that makes browsers send `Origin: null` on the
          // form POST, which the consent handler's origin check would reject.
          "Referrer-Policy": "same-origin",
          "Set-Cookie": `${consentCookie}=${browserBinding}; Max-Age=${TTL.PENDING_AUTH / 1000}; ${consentCookieAttrs}`,
        })
        .type("html")
        .send(renderConsentPage(clientName, params.redirectUri, consentToken, consentAction));
    },

    async challengeForAuthorizationCode(_client: OAuthClientInformationFull, authorizationCode: string) {
      return authCodes.get(authorizationCode)?.codeChallenge ?? "";
    },

    async exchangeAuthorizationCode(client: OAuthClientInformationFull, authorizationCode: string) {
      const codeInfo = authCodes.get(authorizationCode);
      if (!codeInfo || codeInfo.clientId !== client.client_id) {
        throw new InvalidGrantError("Invalid authorization code");
      }

      const tokenResponse = await fetchOrServerError(
        "https://oauth2.googleapis.com/token",
        {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: new URLSearchParams({
            code: codeInfo.googleCode,
            client_id: cfg.googleClientId,
            client_secret: cfg.googleClientSecret,
            redirect_uri: googleRedirectUri,
            grant_type: "authorization_code",
          }),
        },
        "Google token exchange",
      );
      if (!tokenResponse.ok) {
        throw new InvalidGrantError("Failed to exchange code with Google");
      }
      const googleTokens = (await tokenResponse.json()) as GoogleTokens;
      const firebaseTokens = await signInToFirebase(googleTokens.id_token);

      authCodes.delete(authorizationCode);

      const tokens: OAuthTokens = {
        access_token: firebaseTokens.idToken,
        token_type: "bearer",
        expires_in: Number(firebaseTokens.expiresIn),
        scope: SCOPES.join(" "),
      };
      // Keep the Google refresh token server-side; the client only sees an opaque id.
      if (googleTokens.refresh_token) {
        const mcpRefreshToken = randomUUID();
        await refreshTokenStore.set(mcpRefreshToken, {
          clientId: client.client_id,
          googleRefreshToken: googleTokens.refresh_token,
        });
        tokens.refresh_token = mcpRefreshToken;
      }
      return tokens;
    },

    async exchangeRefreshToken(client: OAuthClientInformationFull, refreshToken: string) {
      const googleRefreshToken = await refreshTokenStore.get(refreshToken, client.client_id);
      if (!googleRefreshToken) {
        throw new InvalidGrantError("Invalid or expired refresh token");
      }

      const tokenResponse = await fetchOrServerError(
        "https://oauth2.googleapis.com/token",
        {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: new URLSearchParams({
            refresh_token: googleRefreshToken,
            client_id: cfg.googleClientId,
            client_secret: cfg.googleClientSecret,
            grant_type: "refresh_token",
          }),
        },
        "Google token refresh",
      );
      if (!tokenResponse.ok) {
        // Only delete on permanent failures (token revoked/invalid).
        if (tokenResponse.status === 400 || tokenResponse.status === 401) {
          await refreshTokenStore.delete(refreshToken);
        }
        throw new InvalidGrantError("Failed to refresh Google token");
      }
      const googleTokens = (await tokenResponse.json()) as GoogleTokens;

      // Google may rotate refresh tokens.
      if (googleTokens.refresh_token) {
        await refreshTokenStore.set(refreshToken, {
          clientId: client.client_id,
          googleRefreshToken: googleTokens.refresh_token,
        });
      }

      const firebaseTokens = await signInToFirebase(googleTokens.id_token);
      return {
        access_token: firebaseTokens.idToken,
        token_type: "bearer",
        expires_in: Number(firebaseTokens.expiresIn),
        scope: SCOPES.join(" "),
        refresh_token: refreshToken,
      };
    },

    async verifyAccessToken(token: string): Promise<AuthInfo> {
      const decoded = await firebaseAuth.verifyIdToken(token).catch(() => {
        throw new InvalidTokenError("Invalid or expired token");
      });
      if (!decoded.email?.endsWith(`@${ALLOWED_DOMAIN}`)) {
        throw new InvalidTokenError(`Access restricted to @${ALLOWED_DOMAIN} accounts`);
      }
      if (decoded.email_verified !== true) {
        throw new InvalidTokenError("Email address is not verified");
      }
      if (decoded.firebase?.sign_in_provider !== "google.com") {
        throw new InvalidTokenError("Token was not issued through Google sign-in");
      }
      return {
        token,
        clientId: decoded.sub,
        scopes: SCOPES,
        expiresAt: decoded.exp,
        extra: { email: decoded.email },
      };
    },
  };

  const handleGoogleCallback: RequestHandler = (req: Request, res: Response) => {
    const { code, state, error } = req.query;
    if (typeof state !== "string") {
      res.status(400).json({ error: "Missing state parameter" });
      return;
    }
    const pending = pendingAuths.get(state);
    if (!pending) {
      res.status(400).json({ error: "Invalid or expired state parameter" });
      return;
    }
    pendingAuths.delete(state);

    const redirectUrl = new URL(pending.redirectUri);
    if (pending.originalState) redirectUrl.searchParams.set("state", pending.originalState);

    if (error || typeof code !== "string") {
      redirectUrl.searchParams.set("error", typeof error === "string" ? error : "missing_code");
      res.redirect(redirectUrl.toString());
      return;
    }

    const ourCode = randomUUID();
    authCodes.set(
      ourCode,
      { googleCode: code, clientId: pending.clientId, codeChallenge: pending.codeChallenge },
      TTL.AUTH_CODE,
    );
    redirectUrl.searchParams.set("code", ourCode);
    res.redirect(redirectUrl.toString());
  };

  // CSRF defense in two layers. Anyone can fetch /authorize server-side and
  // obtain a consent token, so the token alone proves nothing:
  // 1. the POST must come from our own origin (Origin/Referer, Sec-Fetch-Site);
  // 2. it must carry the SameSite=Strict cookie issued to the browser that
  //    loaded this consent page.
  const handleConsent: RequestHandler = (req: Request, res: Response) => {
    const fetchSite = req.headers["sec-fetch-site"];
    if (requestOrigin(req) !== publicOrigin || (fetchSite !== undefined && fetchSite !== "same-origin")) {
      logDebug("consent rejected — cross-origin request", {
        origin: requestOrigin(req) ?? null,
        secFetchSite: fetchSite ?? null,
      });
      res.status(403).json({ error: "Cross-origin consent request rejected" });
      return;
    }

    const body = (req.body ?? {}) as Record<string, unknown>;
    const token = body.consent;
    const pending = typeof token === "string" ? consents.get(token) : undefined;
    if (typeof token !== "string" || !pending) {
      res.status(400).json({ error: "Invalid or expired consent request" });
      return;
    }
    const cookie = readCookie(req, consentCookie);
    if (!cookie || !safeEqual(cookie, pending.browserBinding)) {
      // Keep the pending consent: a forged POST must not cancel the real user's flow.
      logDebug("consent rejected — browser binding cookie missing or mismatched");
      res.status(403).json({ error: "Consent request is not bound to this browser" });
      return;
    }
    consents.delete(token);
    res.append("Set-Cookie", `${consentCookie}=; Max-Age=0; ${consentCookieAttrs}`);

    if (body.decision !== "approve") {
      const redirectUrl = new URL(pending.redirectUri);
      redirectUrl.searchParams.set("error", "access_denied");
      if (pending.originalState) redirectUrl.searchParams.set("state", pending.originalState);
      res.redirect(303, redirectUrl.toString());
      return;
    }

    const state = randomUUID();
    const { clientName: _clientName, browserBinding: _browserBinding, ...pendingAuth } = pending;
    pendingAuths.set(state, pendingAuth, TTL.PENDING_AUTH);

    const googleAuthUrl = new URL("https://accounts.google.com/o/oauth2/v2/auth");
    googleAuthUrl.searchParams.set("client_id", cfg.googleClientId);
    googleAuthUrl.searchParams.set("redirect_uri", googleRedirectUri);
    googleAuthUrl.searchParams.set("response_type", "code");
    googleAuthUrl.searchParams.set("scope", SCOPES.join(" "));
    googleAuthUrl.searchParams.set("hd", ALLOWED_DOMAIN);
    googleAuthUrl.searchParams.set("state", state);
    googleAuthUrl.searchParams.set("access_type", "offline");
    googleAuthUrl.searchParams.set("prompt", "consent");
    res.redirect(303, googleAuthUrl.toString());
  };

  return {
    provider,
    issuerUrl: new URL(cfg.publicUrl),
    trustProxyHops: cfg.trustProxyHops,
    handleGoogleCallback,
    handleConsent,
  };
}

/**
 * `form-action` also governs the redirect that follows the form POST (Google on
 * approve, the client's redirect URI on deny), so both must be allowed.
 */
function consentPageCsp(redirectUri: string): string {
  const redirect = new URL(redirectUri);
  // Custom-scheme redirect URIs (e.g. `cursor://`) have an opaque "null" origin.
  const redirectSource = redirect.origin !== "null" ? redirect.origin : redirect.protocol;
  return [
    "default-src 'none'",
    "style-src 'unsafe-inline'",
    `form-action 'self' https://accounts.google.com ${redirectSource}`,
    "frame-ancestors 'none'",
  ].join("; ");
}

function renderConsentPage(
  clientName: string,
  redirectUri: string,
  consentToken: string,
  action: string,
): string {
  const redirect = new URL(redirectUri);
  const host = escapeHtml(redirect.host || redirect.protocol);
  return `<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Montage iOS MCP 접근 승인</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; max-width: 32rem; margin: 3rem auto; padding: 0 1rem; color: #171719; }
  .box { border: 1px solid #e1e2e4; border-radius: 12px; padding: 1.25rem; }
  .host { font-size: 1.25rem; font-weight: 700; color: #d32f2f; word-break: break-all; }
  code { word-break: break-all; }
  .actions { display: flex; gap: .5rem; margin-top: 1.5rem; }
  button { flex: 1; padding: .75rem; border-radius: 8px; border: 1px solid #c2c4c8; background: #fff; font-size: 1rem; cursor: pointer; }
  button[value="approve"] { background: #0066ff; border-color: #0066ff; color: #fff; }
</style>
</head>
<body>
<h1>MCP 클라이언트 접근 승인</h1>
<div class="box">
  <p><strong>${escapeHtml(clientName)}</strong> 클라이언트가 Montage iOS MCP 서버에 접근하려고 합니다.</p>
  <p>승인하면 Google 로그인 후 다음 주소로 접근 권한이 전달됩니다.</p>
  <p class="host">${host}</p>
  <p><code>${escapeHtml(redirectUri)}</code></p>
  <p>직접 시작한 요청이 아니거나 이 주소를 모르면 거부하세요.</p>
  <form method="post" action="${escapeHtml(action)}">
    <input type="hidden" name="consent" value="${escapeHtml(consentToken)}">
    <div class="actions">
      <button type="submit" name="decision" value="deny">거부</button>
      <button type="submit" name="decision" value="approve">승인</button>
    </div>
  </form>
</div>
</body>
</html>`;
}

/** Lowercased email of the authenticated caller, or `undefined` when auth is off. */
export function authenticatedEmail(req: Request): string | undefined {
  const email = req.auth?.extra?.email;
  return typeof email === "string" && email.length > 0 ? email.toLowerCase() : undefined;
}
