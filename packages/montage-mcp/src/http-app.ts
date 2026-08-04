import { randomUUID } from "node:crypto";
import express, { type Express, type Request, type Response } from "express";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { isInitializeRequest } from "@modelcontextprotocol/sdk/types.js";
import type { Transport } from "@modelcontextprotocol/sdk/shared/transport.js";
import { PACKAGE_NAME, PACKAGE_VERSION, type RuntimeConfig } from "./core/config.js";
import { createServer } from "./core/server.js";
import { logDebug, logError } from "./core/logger.js";
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

function sessionIdOf(req: Request): string | undefined {
  const raw = req.headers["mcp-session-id"];
  return typeof raw === "string" && raw.length > 0 ? raw : undefined;
}

export function createApp(config: RuntimeConfig): Express {
  const app = express();

  // Note: the legacy SSE transport requires raw POST body delivery via
  // handlePostMessage. express.json() is therefore registered AFTER /messages,
  // and /mcp opts into JSON parsing per-route.
  const sseTransports = new Map<string, SSEServerTransport>();
  const streamableTransports = new Map<string, StreamableHTTPServerTransport>();

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

  // --- Streamable HTTP (current MCP spec) -----------------------------------

  app.post("/mcp", express.json(), async (req: Request, res: Response) => {
    const sessionId = sessionIdOf(req);
    try {
      let transport = sessionId ? streamableTransports.get(sessionId) : undefined;

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

        const created = new StreamableHTTPServerTransport({
          sessionIdGenerator: () => randomUUID(),
          onsessioninitialized: (sid) => {
            streamableTransports.set(sid, created);
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

        const server = createServer({ config, transport: "http" });
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
    const transport = streamableTransports.get(sessionId);
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

  app.get("/mcp", handleStreamableSessionRequest);
  app.delete("/mcp", handleStreamableSessionRequest);

  // --- Legacy HTTP+SSE (deprecated, kept for backward compatibility) --------

  app.get("/sse", async (_req: Request, res: Response) => {
    const transport = new SSEServerTransport("/messages", res);
    sseTransports.set(transport.sessionId, transport);
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
      const server = createServer({ config, transport: "http" });
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

  app.post("/messages", async (req: Request, res: Response) => {
    const sessionId = req.query.sessionId;
    if (typeof sessionId !== "string") {
      logDebug("/messages rejected — missing sessionId");
      res.status(400).json({ error: "sessionId query parameter required" });
      return;
    }
    const transport = sseTransports.get(sessionId);
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
