import { describe, it, expect, beforeAll, afterAll, vi } from "vitest";
import { createHash } from "node:crypto";
import type { AddressInfo } from "node:net";
import type { Server } from "node:http";

// --- firebase-admin mocks (no Firebase / Google calls leave the process) ----

const firestoreDocs = vi.hoisted(() => new Map<string, Record<string, unknown>>());

const verifyIdToken = vi.hoisted(() =>
  vi.fn(async (token: string) => {
    const exp = Math.floor(Date.now() / 1000) + 3600;
    const google = { email_verified: true, firebase: { sign_in_provider: "google.com" }, exp };
    switch (token) {
      case "valid-token":
        return { ...google, sub: "uid-1", email: "Dev@wantedlab.com" };
      case "other-token":
        return { ...google, sub: "uid-3", email: "other@wantedlab.com" };
      case "outsider-token":
        return { ...google, sub: "uid-2", email: "someone@gmail.com" };
      case "unverified-token":
        return { ...google, sub: "uid-4", email: "dev@wantedlab.com", email_verified: false };
      case "password-token":
        return { ...google, sub: "uid-5", email: "dev@wantedlab.com", firebase: { sign_in_provider: "password" } };
      default:
        throw new Error("invalid token");
    }
  }),
);

vi.mock("firebase-admin/app", () => ({
  cert: (c: unknown) => c,
  getApps: () => [],
  initializeApp: (_opts: unknown, name: string) => ({ name }),
}));

vi.mock("firebase-admin/auth", () => ({
  getAuth: () => ({ verifyIdToken }),
}));

vi.mock("firebase-admin/firestore", () => ({
  getFirestore: () => ({
    collection: (collection: string) => ({
      doc: (id: string) => {
        const key = `${collection}/${id}`;
        return {
          set: async (data: Record<string, unknown>) => void firestoreDocs.set(key, data),
          get: async () => ({ exists: firestoreDocs.has(key), data: () => firestoreDocs.get(key) }),
          delete: async () => void firestoreDocs.delete(key),
        };
      },
    }),
  }),
}));

import { createApp } from "../src/http-app.js";
import { createGoogleAuth, loadAuthConfig, TtlMap } from "../src/http-auth.js";
import { loadConfig, PACKAGE_NAME } from "../src/core/config.js";

const AUTH_ENV = {
  MONTAGE_MCP_AUTH: "google",
  GOOGLE_CLIENT_ID: "google-client-id",
  GOOGLE_CLIENT_SECRET: "google-client-secret",
  FIREBASE_API_KEY: "firebase-api-key",
  FIREBASE_PROJECT_ID: "firebase-project",
  FIREBASE_CLIENT_EMAIL: "svc@firebase-project.iam.gserviceaccount.com",
  FIREBASE_PRIVATE_KEY: "-----BEGIN PRIVATE KEY-----\\nabc\\n-----END PRIVATE KEY-----",
  MONTAGE_MCP_PUBLIC_URL: "http://localhost/",
} as NodeJS.ProcessEnv;

const JSON_AND_SSE = "application/json, text/event-stream";
const INITIALIZE = {
  jsonrpc: "2.0",
  id: 1,
  method: "initialize",
  params: {
    protocolVersion: "2025-06-18",
    capabilities: {},
    clientInfo: { name: "vitest", version: "0.0.0" },
  },
};

let server: Server;
let baseUrl: string;

function postMcp(token?: string, body: unknown = INITIALIZE, sessionId?: string): Promise<Response> {
  return fetch(`${baseUrl}/mcp`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      accept: JSON_AND_SSE,
      ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(sessionId ? { "mcp-session-id": sessionId } : {}),
    },
    body: JSON.stringify(body),
  });
}

/** Fake Google ID token — only the payload matters (the server reads `hd`). */
function googleIdToken(hd: string | undefined): string {
  const payload = Buffer.from(JSON.stringify(hd ? { hd } : {})).toString("base64url");
  return `header.${payload}.signature`;
}

/** Hosted domain the mocked Google token endpoint puts in its ID token. */
let googleHd: string | undefined = "wantedlab.com";
const upstream: string[] = [];
const realFetch = globalThis.fetch;

function stubGoogle(): void {
  vi.spyOn(globalThis, "fetch").mockImplementation(async (input, init) => {
    const url = String(input);
    if (url.startsWith("https://oauth2.googleapis.com/token")) {
      upstream.push("google");
      return Response.json({
        access_token: "g-access",
        id_token: googleIdToken(googleHd),
        expires_in: 3600,
        refresh_token: "g-refresh",
      });
    }
    if (url.startsWith("https://identitytoolkit.googleapis.com/")) {
      upstream.push("firebase");
      return Response.json({ idToken: "valid-token", expiresIn: "3600", email: "dev@wantedlab.com" });
    }
    return realFetch(input, init);
  });
}

const REDIRECT_URI = "http://localhost:9999/callback";

async function registerClient(clientName?: string): Promise<string> {
  const res = await fetch(`${baseUrl}/register`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      redirect_uris: [REDIRECT_URI],
      token_endpoint_auth_method: "none",
      ...(clientName ? { client_name: clientName } : {}),
    }),
  });
  expect(res.status).toBe(201);
  return ((await res.json()) as { client_id: string }).client_id;
}

const VERIFIER = "v".repeat(64);
/** Origin of MONTAGE_MCP_PUBLIC_URL in AUTH_ENV — what a browser on the consent page sends. */
const PUBLIC_ORIGIN = "http://localhost";

interface ConsentPage {
  res: Response;
  html: string;
  consent: string;
  /** `name=value` of the browser-binding cookie set by the consent page. */
  cookie: string;
}

function authorizeUrl(clientId: string, redirectUri = REDIRECT_URI): URL {
  const url = new URL(`${baseUrl}/authorize`);
  url.search = new URLSearchParams({
    client_id: clientId,
    redirect_uri: redirectUri,
    response_type: "code",
    code_challenge: createHash("sha256").update(VERIFIER).digest("base64url"),
    code_challenge_method: "S256",
    state: "client-state",
  }).toString();
  return url;
}

/** GET /authorize → consent page. Returns the HTML, its consent token, and the cookie. */
async function openConsent(clientId: string): Promise<ConsentPage> {
  const res = await fetch(authorizeUrl(clientId), { redirect: "manual" });
  const html = await res.text();
  const consent = /name="consent" value="([^"]+)"/.exec(html)?.[1] ?? "";
  const cookie = (res.headers.get("set-cookie") ?? "").split(";")[0] ?? "";
  return { res, html, consent, cookie };
}

/** What a browser on the consent page sends; `headers` overrides individual values. */
function submitConsent(
  page: Pick<ConsentPage, "consent" | "cookie">,
  decision: "approve" | "deny",
  headers: Record<string, string | undefined> = {},
): Promise<Response> {
  const merged: Record<string, string | undefined> = {
    "content-type": "application/x-www-form-urlencoded",
    origin: PUBLIC_ORIGIN,
    "sec-fetch-site": "same-origin",
    cookie: page.cookie,
    ...headers,
  };
  const sent: Record<string, string> = {};
  for (const [k, v] of Object.entries(merged)) if (v) sent[k] = v;
  return fetch(`${baseUrl}/oauth/consent`, {
    method: "POST",
    headers: sent,
    body: new URLSearchParams({ consent: page.consent, decision }),
    redirect: "manual",
  });
}

/** Consent → Google → callback; returns our authorization code. */
async function authorizationCode(clientId: string): Promise<string> {
  const approve = await submitConsent(await openConsent(clientId), "approve");
  const google = new URL(approve.headers.get("location")!);
  const callback = await fetch(
    `${baseUrl}/oauth/google/callback?code=google-code&state=${google.searchParams.get("state")}`,
    { redirect: "manual" },
  );
  return new URL(callback.headers.get("location")!).searchParams.get("code")!;
}

function exchangeCode(clientId: string, code: string, verifier = VERIFIER): Promise<Response> {
  return fetch(`${baseUrl}/token`, {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "authorization_code",
      code,
      code_verifier: verifier,
      client_id: clientId,
      redirect_uri: REDIRECT_URI,
    }),
  });
}

beforeAll(async () => {
  const authConfig = loadAuthConfig(AUTH_ENV);
  expect(authConfig).not.toBeNull();
  const auth = await createGoogleAuth(authConfig!);
  const app = createApp(loadConfig({ MONTAGE_MCP_TRACK_DISABLE: "1" } as NodeJS.ProcessEnv), { auth });
  server = await new Promise<Server>((resolve) => {
    const s = app.listen(0, () => resolve(s));
  });
  baseUrl = `http://127.0.0.1:${(server.address() as AddressInfo).port}`;
});

afterAll(async () => {
  vi.restoreAllMocks();
  await new Promise<void>((resolve) => server.close(() => resolve()));
});

describe("loadAuthConfig", () => {
  it("returns null when MONTAGE_MCP_AUTH is unset", () => {
    expect(loadAuthConfig({} as NodeJS.ProcessEnv)).toBeNull();
  });

  it("fails fast listing every missing variable", () => {
    expect(() => loadAuthConfig({ MONTAGE_MCP_AUTH: "google" } as NodeJS.ProcessEnv)).toThrow(
      /GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, FIREBASE_API_KEY, FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY, MONTAGE_MCP_PUBLIC_URL/,
    );
  });

  it("rejects an unknown auth mode", () => {
    expect(() => loadAuthConfig({ ...AUTH_ENV, MONTAGE_MCP_AUTH: "gogle" })).toThrow(/not supported/);
  });

  it("rejects a non-integer or negative MONTAGE_MCP_TRUST_PROXY", () => {
    for (const v of ["abc", "-1", "1.5"]) {
      expect(() => loadAuthConfig({ ...AUTH_ENV, MONTAGE_MCP_TRUST_PROXY: v })).toThrow(/MONTAGE_MCP_TRUST_PROXY/);
    }
    expect(loadAuthConfig({ ...AUTH_ENV, MONTAGE_MCP_TRUST_PROXY: "2" })!.trustProxyHops).toBe(2);
  });

  it("normalizes the public URL and the private key", () => {
    const cfg = loadAuthConfig(AUTH_ENV)!;
    expect(cfg.publicUrl).toBe("http://localhost");
    expect(cfg.firebasePrivateKey).toContain("\nabc\n");
    expect(cfg.firestoreDatabaseId).toBe("montage-ios-storage");
  });
});

describe("HTTP with MONTAGE_MCP_AUTH=google", () => {
  it("keeps /healthz and / public", async () => {
    const health = await fetch(`${baseUrl}/healthz`);
    expect(health.status).toBe(200);
    expect(((await health.json()) as Record<string, unknown>).name).toBe(PACKAGE_NAME);

    const index = await fetch(`${baseUrl}/`);
    expect(index.status).toBe(200);
    await index.text();
  });

  it("rejects /mcp without a token and points at the resource metadata", async () => {
    const res = await postMcp();
    expect(res.status).toBe(401);
    expect(res.headers.get("www-authenticate")).toContain(
      'resource_metadata="http://localhost/.well-known/oauth-protected-resource"',
    );
    await res.text();
  });

  it("rejects GET/DELETE /mcp, /sse and /messages without a token", async () => {
    const requests: Array<[string, RequestInit]> = [
      ["/mcp", { method: "GET" }],
      ["/mcp", { method: "DELETE" }],
      ["/sse", { method: "GET" }],
      ["/messages?sessionId=x", { method: "POST", body: "{}" }],
    ];
    for (const [path, init] of requests) {
      const res = await fetch(`${baseUrl}${path}`, init);
      expect(res.status, `${init.method} ${path}`).toBe(401);
      await res.text();
    }
  });

  it("rejects invalid, outside-domain, unverified, and non-Google tokens", async () => {
    for (const token of ["garbage", "outsider-token", "unverified-token", "password-token"]) {
      const res = await postMcp(token);
      expect(res.status, token).toBe(401);
      await res.text();
    }
  });

  it("accepts a valid workspace token", async () => {
    const res = await postMcp("valid-token");
    expect(res.status).toBe(200);
    expect(res.headers.get("mcp-session-id")).toBeTruthy();
    await res.text();
  });

  it("serves the OAuth authorization server metadata", async () => {
    const res = await fetch(`${baseUrl}/.well-known/oauth-authorization-server`);
    expect(res.status).toBe(200);
    const body = (await res.json()) as Record<string, unknown>;
    expect(body.issuer).toBe("http://localhost/");
    expect(body.registration_endpoint).toBe("http://localhost/register");
  });

  it("shows an escaped consent page instead of redirecting straight to Google", async () => {
    const clientId = await registerClient('<script>alert("x")</script>');
    const { res, html, consent, cookie } = await openConsent(clientId);
    expect(res.status).toBe(200);
    // Plain-http localhost public URL → unprefixed, non-Secure cookie (see http-auth.ts).
    expect(cookie).toMatch(/^mcp_consent=[A-Za-z0-9_-]{43}$/);
    const setCookie = res.headers.get("set-cookie")!;
    expect(setCookie).toContain("HttpOnly");
    expect(setCookie).toContain("SameSite=Strict");
    expect(setCookie).toContain("Path=/");
    expect(res.headers.get("referrer-policy")).toBe("same-origin");
    expect(res.headers.get("content-type")).toContain("text/html");
    expect(res.headers.get("x-frame-options")).toBe("DENY");
    expect(res.headers.get("content-security-policy")).toContain("frame-ancestors 'none'");
    expect(html).not.toContain("<script>");
    expect(html).toContain("&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt;");
    expect(html).toContain('<p class="host">localhost:9999</p>');
    expect(consent).toMatch(/^[0-9a-f-]{36}$/);
  });

  it("redirects with error=access_denied when the user denies", async () => {
    const res = await submitConsent(await openConsent(await registerClient("Denied Client")), "deny");
    expect(res.status).toBe(303);
    const back = new URL(res.headers.get("location")!);
    expect(`${back.origin}${back.pathname}`).toBe(REDIRECT_URI);
    expect(back.searchParams.get("error")).toBe("access_denied");
    expect(back.searchParams.get("state")).toBe("client-state");
  });

  it("rejects unknown or reused consent tokens", async () => {
    const unknown = await submitConsent({ consent: "not-a-token", cookie: "" }, "approve");
    expect(unknown.status).toBe(400);
    await unknown.text();

    const page = await openConsent(await registerClient());
    expect((await submitConsent(page, "approve")).status).toBe(303);
    const reused = await submitConsent(page, "approve");
    expect(reused.status).toBe(400);
    await reused.text();
  });

  it("rejects consent POSTs from another origin", async () => {
    const page = await openConsent(await registerClient());
    const attempts: Array<Record<string, string | undefined>> = [
      { origin: "https://evil.example" },
      { origin: "null" },
      { origin: undefined, referer: "https://evil.example/page" },
      { origin: undefined }, // neither Origin nor Referer
      { "sec-fetch-site": "cross-site" },
      { "sec-fetch-site": "same-site" },
    ];
    for (const headers of attempts) {
      const res = await submitConsent(page, "approve", headers);
      expect(res.status, JSON.stringify(headers)).toBe(403);
      await res.text();
    }
    // A same-origin Referer is accepted when Origin is absent; the token was never consumed.
    const viaReferer = await submitConsent(page, "approve", {
      origin: undefined,
      referer: `${PUBLIC_ORIGIN}/authorize?x=1`,
    });
    expect(viaReferer.status).toBe(303);
  });

  it("rejects consent POSTs without the browser-binding cookie", async () => {
    const page = await openConsent(await registerClient());
    const other = await openConsent(await registerClient());
    for (const cookie of [undefined, "mcp_consent=forged", other.cookie]) {
      const res = await submitConsent(page, "approve", { cookie });
      expect(res.status, String(cookie)).toBe(403);
      await res.text();
    }
    // The real browser still completes the flow and the cookie is cleared.
    const ok = await submitConsent(page, "approve");
    expect(ok.status).toBe(303);
    expect(new URL(ok.headers.get("location")!).origin).toBe("https://accounts.google.com");
    expect(ok.headers.get("set-cookie")).toMatch(/^mcp_consent=; Max-Age=0/);
  });

  it("rejects an authorization request with an unregistered redirect_uri", async () => {
    const clientId = await registerClient();
    const res = await fetch(authorizeUrl(clientId, "https://evil.example/callback"), { redirect: "manual" });
    expect(res.status).toBe(400);
    expect(await res.text()).not.toContain('name="consent"');
  });

  it("runs register → consent → Google callback → token exchange", async () => {
    googleHd = "wantedlab.com";
    upstream.length = 0;
    stubGoogle();
    try {
      const clientId = await registerClient("Claude Code");
      const approve = await submitConsent(await openConsent(clientId), "approve");
      expect(approve.status).toBe(303);
      const google = new URL(approve.headers.get("location")!);
      expect(google.origin).toBe("https://accounts.google.com");
      expect(google.searchParams.get("hd")).toBe("wantedlab.com");
      expect(google.searchParams.get("redirect_uri")).toBe("http://localhost/oauth/google/callback");

      const callback = await fetch(
        `${baseUrl}/oauth/google/callback?code=google-code&state=${google.searchParams.get("state")}`,
        { redirect: "manual" },
      );
      expect(callback.status).toBe(302);
      const back = new URL(callback.headers.get("location")!);
      expect(`${back.origin}${back.pathname}`).toBe(REDIRECT_URI);
      expect(back.searchParams.get("state")).toBe("client-state");

      const token = await exchangeCode(clientId, back.searchParams.get("code")!);
      expect(token.status).toBe(200);
      const tokens = (await token.json()) as Record<string, unknown>;
      expect(tokens.access_token).toBe("valid-token");
      expect(typeof tokens.refresh_token).toBe("string");
      expect(upstream).toEqual(["google", "firebase"]);
      expect(firestoreDocs.get(`refreshTokens/${tokens.refresh_token as string}`)).toEqual({
        clientId,
        googleRefreshToken: "g-refresh",
      });
    } finally {
      vi.mocked(globalThis.fetch).mockRestore();
    }
  });

  it("rejects a code exchange with the wrong PKCE verifier", async () => {
    upstream.length = 0;
    stubGoogle();
    try {
      const clientId = await registerClient();
      const res = await exchangeCode(clientId, await authorizationCode(clientId), "w".repeat(64));
      expect(res.status).toBe(400);
      expect(((await res.json()) as Record<string, unknown>).error).toBe("invalid_grant");
      expect(upstream).toEqual([]); // rejected before calling Google
    } finally {
      vi.mocked(globalThis.fetch).mockRestore();
    }
  });

  it("rejects code and refresh exchanges whose Google ID token lacks hd=wantedlab.com", async () => {
    stubGoogle();
    try {
      // Code exchange with a consumer account (no hd claim).
      googleHd = undefined;
      upstream.length = 0;
      const outsiderClient = await registerClient();
      const denied = await exchangeCode(outsiderClient, await authorizationCode(outsiderClient));
      expect(denied.status).toBe(400);
      expect(((await denied.json()) as Record<string, unknown>).error).toBe("access_denied");
      expect(upstream).toEqual(["google"]); // never reached Firebase

      // Refresh: issue tokens normally, then Google returns another domain.
      googleHd = "wantedlab.com";
      const clientId = await registerClient();
      const issued = await exchangeCode(clientId, await authorizationCode(clientId));
      const refreshToken = ((await issued.json()) as Record<string, string>).refresh_token!;

      googleHd = "example.com";
      upstream.length = 0;
      const refreshed = await fetch(`${baseUrl}/token`, {
        method: "POST",
        headers: { "content-type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          grant_type: "refresh_token",
          refresh_token: refreshToken,
          client_id: clientId,
        }),
      });
      expect(refreshed.status).toBe(400);
      expect(((await refreshed.json()) as Record<string, unknown>).error).toBe("access_denied");
      expect(upstream).toEqual(["google"]);
    } finally {
      googleHd = "wantedlab.com";
      vi.mocked(globalThis.fetch).mockRestore();
    }
  });

  it("binds Streamable HTTP sessions to the user who opened them", async () => {
    const init = await postMcp("valid-token");
    const sessionId = init.headers.get("mcp-session-id")!;
    await init.text();
    const initialized = await postMcp("valid-token", { jsonrpc: "2.0", method: "notifications/initialized" }, sessionId);
    await initialized.text();

    const list = { jsonrpc: "2.0", id: 2, method: "tools/list" };
    const intruder = await postMcp("other-token", list, sessionId);
    expect(intruder.status).toBe(404);
    await intruder.text();

    const intruderDelete = await fetch(`${baseUrl}/mcp`, {
      method: "DELETE",
      headers: { authorization: "Bearer other-token", "mcp-session-id": sessionId },
    });
    expect(intruderDelete.status).toBe(404);
    await intruderDelete.text();

    const owner = await postMcp("valid-token", list, sessionId);
    expect(owner.status).toBe(200);
    await owner.text();
  });

  it("binds legacy SSE sessions to the user who opened them", async () => {
    const controller = new AbortController();
    const sse = await fetch(`${baseUrl}/sse`, {
      headers: { accept: "text/event-stream", authorization: "Bearer valid-token" },
      signal: controller.signal,
    });
    expect(sse.status).toBe(200);
    const reader = sse.body!.getReader();
    const chunk = new TextDecoder().decode((await reader.read()).value);
    const sessionId = /sessionId=([0-9a-f-]+)/.exec(chunk)![1]!;

    const post = (token: string) =>
      fetch(`${baseUrl}/messages?sessionId=${sessionId}`, {
        method: "POST",
        headers: { "content-type": "application/json", authorization: `Bearer ${token}` },
        body: JSON.stringify({ jsonrpc: "2.0", id: 1, method: "ping" }),
      });
    const intruder = await post("other-token");
    expect(intruder.status).toBe(404);
    await intruder.text();
    const owner = await post("valid-token");
    expect(owner.status).toBeLessThan(300);
    await owner.text();

    await reader.cancel();
    controller.abort();
  });
});

describe("consent cookie on an https public URL", () => {
  it("uses a __Host- prefixed Secure cookie", async () => {
    const auth = await createGoogleAuth(
      loadAuthConfig({ ...AUTH_ENV, MONTAGE_MCP_PUBLIC_URL: "https://mcp.example.com" })!,
    );
    const app = createApp(loadConfig({ MONTAGE_MCP_TRACK_DISABLE: "1" } as NodeJS.ProcessEnv), { auth });
    const httpsServer = await new Promise<Server>((resolve) => {
      const s = app.listen(0, () => resolve(s));
    });
    const origin = `http://127.0.0.1:${(httpsServer.address() as AddressInfo).port}`;
    try {
      const register = await fetch(`${origin}/register`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ redirect_uris: [REDIRECT_URI], token_endpoint_auth_method: "none" }),
      });
      const clientId = ((await register.json()) as { client_id: string }).client_id;
      const url = authorizeUrl(clientId);
      const res = await fetch(`${origin}${url.pathname}${url.search}`, { redirect: "manual" });
      expect(res.status).toBe(200);
      await res.text();
      const setCookie = res.headers.get("set-cookie")!;
      expect(setCookie).toMatch(/^__Host-mcp_consent=[A-Za-z0-9_-]{43};/);
      expect(setCookie).toContain("Secure");
      expect(setCookie).toContain("Path=/");
      expect(setCookie).not.toContain("Domain=");
    } finally {
      await new Promise<void>((resolve) => httpsServer.close(() => resolve()));
    }
  });
});

describe("TtlMap", () => {
  it("evicts the oldest entry at the size cap", () => {
    const map = new TtlMap<string, number>(2);
    map.set("a", 1, 60_000);
    map.set("b", 2, 60_000);
    map.set("c", 3, 60_000);
    expect(map.size).toBe(2);
    expect(map.get("a")).toBeUndefined();
    expect(map.get("c")).toBe(3);
  });

  it("sweeps expired entries on set", () => {
    vi.useFakeTimers();
    try {
      const map = new TtlMap<string, number>();
      map.set("short", 1, 10);
      map.set("long", 2, 60_000);
      vi.advanceTimersByTime(20);
      map.set("new", 3, 60_000);
      expect(map.size).toBe(2);
      expect(map.get("short")).toBeUndefined();
    } finally {
      vi.useRealTimers();
    }
  });
});
