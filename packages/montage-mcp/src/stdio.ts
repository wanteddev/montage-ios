import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { loadConfig } from "./core/config.js";
import { createServer } from "./core/server.js";
import { configureLogger, logDebug, logError } from "./core/logger.js";
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
  });
  const server = createServer({ config, transport: "stdio" });
  const transport = new StdioServerTransport();
  await server.connect(transport);
  logDebug("stdio transport ready");
}

main().catch((err) => {
  logError("fatal", err);
  process.exit(1);
});
