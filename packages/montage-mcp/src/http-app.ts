import { randomUUID } from "node:crypto";
import express, {
  type Express,
  type NextFunction,
  type Request,
  type RequestHandler,
  type Response,
} from "express";
import { mcpAuthRouter, getOAuthProtectedResourceMetadataUrl } from "@modelcontextprotocol/sdk/server/auth/router.js";
import { requireBearerAuth } from "@modelcontextprotocol/sdk/server/auth/middleware/bearerAuth.js";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { isInitializeRequest } from "@modelcontextprotocol/sdk/types.js";
import type { Transport } from "@modelcontextprotocol/sdk/shared/transport.js";
import { PACKAGE_NAME, PACKAGE_VERSION, type RuntimeConfig } from "./core/config.js";
import { createServer, type ServerContext } from "./core/server.js";
import { logDebug, logError } from "./core/logger.js";
import { authenticatedEmail, type HttpAuth } from "./http-auth.js";
import { renderIndexPage } from "./index-page.js";

/**
 * SSE heartbeat — sends an SSE comment line periodically so L7 idle timeouts
 * (e.g. ingress 30s) don't sever quiet streams. The colon-prefixed line is a
 * no-op for SSE clients per spec, but counts as bytes for proxies.
 *
 * Only the legacy `/sse` transport needs this; `StreamableHTTPServerTransport`
 * ships its own keep-alive.
 */
const SSE_HEARTBEAT_MS = 25_000;

/** JSON-RPC error body for transport-level failures (no request id available). */
function jsonRpcError(code: number, message: string): Record<string, unknown> {
  return { jsonrpc: "2.0", error: { code, message }, id: null };
}

/**
 * A live transport plus the email of the user who opened it. With auth off the
 * owner is always `undefined`, so ownership checks pass exactly as before.
 */
interface Session<T> {
  transport: T;
  owner: string | undefined;
}

/** Resolve a session only for its owner; another user's id behaves like an unknown one. */
function ownedTransport<T>(
  sessions: Map<string, Session<T>>,
  sessionId: string,
  req: Request,
): T | undefined {
  const session = sessions.get(sessionId);
  if (!session) return undefined;
  if (session.owner !== authenticatedEmail(req)) {
    logDebug("session rejected — owned by another user", { sessionId });
    return undefined;
  }
  return session.transport;
}

function sessionIdOf(req: Request): string | undefined {
  const raw = req.headers["mcp-session-id"];
  return typeof raw === "string" && raw.length > 0 ? raw : undefined;
}

export interface CreateAppOptions {
  /** When set, MCP endpoints require a Bearer token (see `./http-auth.ts`). */
  auth?: HttpAuth;
}

export function createApp(config: RuntimeConfig, options: CreateAppOptions = {}): Express {
  const app = express();
  const { auth } = options;

  // Per-session server context. The authenticated email doubles as the
  // tracker's deviceId so usage can be attributed per user.
  const serverContext = (req: Request): ServerContext => {
    const email = authenticatedEmail(req);
    return { config, transport: "http", ...(email ? { deviceId: email } : {}) };
  };

  // Note: the legacy SSE transport requires raw POST body delivery via
  // handlePostMessage. express.json() is therefore registered AFTER /messages,
  // and /mcp opts into JSON parsing per-route.
  const sseTransports = new Map<string, Session<SSEServerTransport>>();
  const streamableTransports = new Map<string, Session<StreamableHTTPServerTransport>>();

  app.get("/", (req: Request, res: Response) => {
    const forwardedProto = req.headers["x-forwarded-proto"];
    const proto =
      typeof forwardedProto === "string" && forwardedProto.length > 0
        ? (forwardedProto.split(",")[0] ?? "").trim() || req.protocol
        : req.protocol;
    const host = req.get("host") ?? `localhost:${config.port}`;
    const origin = `${proto}://${host}`;
    res.type("html").send(renderIndexPage(origin));
  });

  app.get("/healthz", (_req: Request, res: Response) => {
    res.json({
      status: "ok",
      name: PACKAGE_NAME,
      version: PACKAGE_VERSION,
      timestamp: new Date().toISOString(),
    });
  });

  // --- OAuth (opt-in) ---------------------------------------------------------
  // `/` and `/healthz` above stay public; every MCP transport route below is
  // guarded. With auth off, `requireAuth` is empty and routing is unchanged.
  const requireAuth: RequestHandler[] = [];
  if (auth) {
    // The auth router rate-limits per client IP; trust the ingress hops so the
    // limit keys on X-Forwarded-For instead of the proxy address.
    app.set("trust proxy", auth.trustProxyHops);
    // Metadata (/.well-known/*), /authorize, /token, /register.
    app.use(
      mcpAuthRouter({
        provider: auth.provider,
        issuerUrl: auth.issuerUrl,
        scopesSupported: ["openid", "email", "profile"],
      }),
    );
    app.get("/oauth/google/callback", auth.handleGoogleCallback);
    app.post("/oauth/consent", express.urlencoded({ extended: false }), auth.handleConsent);
    requireAuth.push(
      requireBearerAuth({
        verifier: auth.provider,
        resourceMetadataUrl: getOAuthProtectedResourceMetadataUrl(auth.issuerUrl),
      }),
    );
  }

  // --- Streamable HTTP (current MCP spec) -----------------------------------

  app.post("/mcp", ...requireAuth, express.json(), async (req: Request, res: Response) => {
    const sessionId = sessionIdOf(req);
    try {
      let transport = sessionId ? ownedTransport(streamableTransports, sessionId, req) : undefined;

      if (!transport) {
        if (sessionId) {
          logDebug("/mcp POST rejected — session not found", { sessionId });
          res.status(404).json(jsonRpcError(-32001, "session not found"));
          return;
        }
        if (!isInitializeRequest(req.body)) {
          logDebug("/mcp POST rejected — no session id and not an initialize request");
          res
            .status(400)
            .json(jsonRpcError(-32000, "mcp-session-id header required for non-initialize requests"));
          return;
        }

        const owner = authenticatedEmail(req);
        const created = new StreamableHTTPServerTransport({
          sessionIdGenerator: () => randomUUID(),
          onsessioninitialized: (sid) => {
            streamableTransports.set(sid, { transport: created, owner });
            logDebug("mcp session opened", { sessionId: sid });
          },
          onsessionclosed: (sid) => {
            streamableTransports.delete(sid);
            logDebug("mcp session closed by client", { sessionId: sid });
          },
        });
        created.onclose = () => {
          const sid = created.sessionId;
          if (sid) {
            streamableTransports.delete(sid);
            logDebug("mcp session closed", { sessionId: sid });
          }
        };

        const server = createServer(serverContext(req));
        // SDK typing quirk: StreamableHTTPServerTransport exposes `onclose`/`onerror`
        // as accessors returning `T | undefined`, which `exactOptionalPropertyTypes`
        // rejects against Transport's optional members. Runtime shape is compatible.
        await server.connect(created as Transport);
        transport = created;
      }

      logDebug("/mcp POST received", { sessionId: sessionId ?? "(initialize)" });
      await transport.handleRequest(req, res, req.body);
    } catch (err) {
      logError("/mcp POST failed", err, { sessionId: sessionId ?? null });
      if (!res.headersSent) {
        res.status(500).json(jsonRpcError(-32603, "internal server error"));
      }
    }
  });

  // GET opens the server→client notification stream, DELETE terminates the session.
  const handleStreamableSessionRequest = async (req: Request, res: Response): Promise<void> => {
    const sessionId = sessionIdOf(req);
    if (!sessionId) {
      logDebug(`/mcp ${req.method} rejected — missing session id`);
      res.status(400).json(jsonRpcError(-32000, "mcp-session-id header required"));
      return;
    }
    const transport = ownedTransport(streamableTransports, sessionId, req);
    if (!transport) {
      logDebug(`/mcp ${req.method} rejected — session not found`, { sessionId });
      res.status(404).json(jsonRpcError(-32001, "session not found"));
      return;
    }
    try {
      logDebug(`/mcp ${req.method} received`, { sessionId });
      await transport.handleRequest(req, res);
    } catch (err) {
      logError(`/mcp ${req.method} failed`, err, { sessionId });
      if (!res.headersSent) {
        res.status(500).json(jsonRpcError(-32603, "internal server error"));
      }
    }
  };

  app.get("/mcp", ...requireAuth, handleStreamableSessionRequest);
  app.delete("/mcp", ...requireAuth, handleStreamableSessionRequest);

  // express.json() rejects a malformed body before the route handlers run, so their
  // try/catch never sees it and Express would answer with its default HTML error page.
  // Translate it into a JSON-RPC parse error instead.
  app.use("/mcp", (err: unknown, _req: Request, res: Response, next: NextFunction) => {
    if (err instanceof SyntaxError && "body" in err) {
      logDebug("/mcp rejected — malformed JSON body");
      res.status(400).json(jsonRpcError(-32700, "parse error: request body is not valid JSON"));
      return;
    }
    next(err);
  });

  // --- Legacy HTTP+SSE (deprecated, kept for backward compatibility) --------

  app.get("/sse", ...requireAuth, async (req: Request, res: Response) => {
    const transport = new SSEServerTransport("/messages", res);
    sseTransports.set(transport.sessionId, { transport, owner: authenticatedEmail(req) });
    const heartbeat = setInterval(() => {
      try {
        res.write(": ping\n\n");
      } catch {
        // socket already gone — close handler will clean up
      }
    }, SSE_HEARTBEAT_MS);
    if (typeof heartbeat.unref === "function") heartbeat.unref();
    logDebug("sse session opened", {
      sessionId: transport.sessionId,
      heartbeatMs: SSE_HEARTBEAT_MS,
    });
    res.on("close", () => {
      clearInterval(heartbeat);
      sseTransports.delete(transport.sessionId);
      logDebug("sse session closed", { sessionId: transport.sessionId });
    });

    try {
      const server = createServer(serverContext(req));
      await server.connect(transport);
    } catch (err) {
      clearInterval(heartbeat);
      sseTransports.delete(transport.sessionId);
      if (!res.headersSent) {
        res.status(500).json({ error: "failed to initialize sse session" });
      }
      logError("sse init failed", err, { sessionId: transport.sessionId });
    }
  });

  app.post("/messages", ...requireAuth, async (req: Request, res: Response) => {
    const sessionId = req.query.sessionId;
    if (typeof sessionId !== "string") {
      logDebug("/messages rejected — missing sessionId");
      res.status(400).json({ error: "sessionId query parameter required" });
      return;
    }
    const transport = ownedTransport(sseTransports, sessionId, req);
    if (!transport) {
      logDebug("/messages rejected — session not found", { sessionId });
      res.status(404).json({ error: "session not found" });
      return;
    }
    logDebug("/messages received", { sessionId });
    await transport.handlePostMessage(req, res);
  });

  // JSON middleware for any other routes added later (must come AFTER /messages).
  app.use(express.json());

  return app;
}
