import express, { type Request, type Response } from "express";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { loadConfig, PACKAGE_NAME, PACKAGE_VERSION } from "./core/config.js";
import { createServer } from "./core/server.js";
import { configureLogger, logDebug, logError } from "./core/logger.js";

const config = loadConfig();
configureLogger({ debug: config.debug });
logDebug("config resolved", {
  trackUrl: config.trackUrl,
  trackTokenSet: config.trackToken !== null,
  trackDisabled: config.trackDisabled,
  clientIdSet: config.clientId !== null,
  queuePath: config.queuePath,
  port: config.port,
});
const app = express();

// Note: SSE transport requires raw POST body delivery via handlePostMessage.
// We register express.json() AFTER the SSE message endpoint so the SDK reads the stream itself.

const transports = new Map<string, SSEServerTransport>();

app.get("/healthz", (_req: Request, res: Response) => {
  res.json({
    status: "ok",
    name: PACKAGE_NAME,
    version: PACKAGE_VERSION,
    timestamp: new Date().toISOString(),
  });
});

app.get("/sse", async (_req: Request, res: Response) => {
  const transport = new SSEServerTransport("/messages", res);
  transports.set(transport.sessionId, transport);
  logDebug("sse session opened", { sessionId: transport.sessionId });
  res.on("close", () => {
    transports.delete(transport.sessionId);
    logDebug("sse session closed", { sessionId: transport.sessionId });
  });

  try {
    const server = createServer({ config, transport: "http" });
    await server.connect(transport);
  } catch (err) {
    transports.delete(transport.sessionId);
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
  const transport = transports.get(sessionId);
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

app.listen(config.port, () => {
  logDebug(`HTTP listening on :${config.port}`, {
    name: PACKAGE_NAME,
    version: PACKAGE_VERSION,
  });
});
