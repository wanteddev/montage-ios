import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { loadConfig } from "./core/config.js";
import { createServer } from "./core/server.js";

async function main(): Promise<void> {
  const config = loadConfig();
  const server = createServer({ config, transport: "stdio" });
  const transport = new StdioServerTransport();
  await server.connect(transport);
  if (config.debug) {
    process.stderr.write("[montage-ios-mcp] stdio transport ready\n");
  }
}

main().catch((err) => {
  process.stderr.write(`[montage-ios-mcp] fatal: ${String(err)}\n`);
  process.exit(1);
});
