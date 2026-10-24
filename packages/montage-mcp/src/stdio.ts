import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { loadConfig } from "./core/config.js";
import { createServer } from "./core/server.js";
import { startRemoteDataRefresher } from "./core/data/remote.js";
import { configureLogger, logDebug, logError, logInfo } from "./core/logger.js";
import { sanitizeUrl } from "./core/redact.js";

async function main(): Promise<void> {
  const config = loadConfig();
  configureLogger({ debug: config.debug });
  logDebug("config resolved", {
    trackUrl: sanitizeUrl(config.trackUrl),
    trackTokenSet: config.trackToken !== null,
    trackDisabled: config.trackDisabled,
    clientIdSet: config.clientId !== null,
    queuePath: config.queuePath,
    dataUrl: sanitizeUrl(config.dataUrl),
    dataRefreshSec: config.dataRefreshSec,
  });
  // stderr only — stdout carries the MCP stdio stream.
  logInfo("startup", {
    transport: "stdio",
    auth: "n/a",
    remoteData: config.dataRefreshSec > 0 ? "on" : "off",
    ...(config.dataRefreshSec > 0
      ? { dataUrl: sanitizeUrl(config.dataUrl), dataRefreshSec: config.dataRefreshSec }
      : {}),
  });
  startRemoteDataRefresher(config);
  const server = createServer({ config, transport: "stdio" });
  const transport = new StdioServerTransport();
  await server.connect(transport);
  logDebug("stdio transport ready");
}

main().catch((err) => {
  logError("fatal", err);
  process.exit(1);
});
