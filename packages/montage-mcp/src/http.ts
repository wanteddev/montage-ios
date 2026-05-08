import express, { type Request, type Response } from "express";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { loadConfig, PACKAGE_NAME, PACKAGE_VERSION } from "./core/config.js";
import { createServer } from "./core/server.js";

const config = loadConfig();
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
  res.on("close", () => transports.delete(transport.sessionId));

  try {
    const server = createServer({ config, transport: "http" });
    await server.connect(transport);
  } catch (err) {
    transports.delete(transport.sessionId);
    if (!res.headersSent) {
      res.status(500).json({ error: "failed to initialize sse session" });
    }
    if (config.debug) {
      process.stderr.write(
        `[${PACKAGE_NAME}] sse init failed: ${String(err)}\n`,
      );
    }
  }
});

app.post("/messages", async (req: Request, res: Response) => {
  const sessionId = req.query.sessionId;
  if (typeof sessionId !== "string") {
    res.status(400).json({ error: "sessionId query parameter required" });
    return;
  }
  const transport = transports.get(sessionId);
  if (!transport) {
    res.status(404).json({ error: "session not found" });
    return;
  }
  await transport.handlePostMessage(req, res);
});

// JSON middleware for any other routes added later (must come AFTER /messages).
app.use(express.json());

app.listen(config.port, () => {
  if (config.debug) {
    // eslint-disable-next-line no-console
    console.error(`[${PACKAGE_NAME}] HTTP listening on :${config.port}`);
  }
});
