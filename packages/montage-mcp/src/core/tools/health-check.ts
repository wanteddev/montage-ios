import { PACKAGE_NAME, PACKAGE_VERSION } from "../config.js";
import { getRemoteDataStatus } from "../data/remote.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function healthCheckTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "health_check",
    description:
      "Liveness check for the Montage iOS MCP server. Returns name, version, current timestamp, and where the served data comes from (bundled or remote).",
    inputSchema: { type: "object" },
    handler: async () => {
      const payload = {
        status: "ok",
        name: PACKAGE_NAME,
        version: PACKAGE_VERSION,
        timestamp: new Date().toISOString(),
        data: getRemoteDataStatus(),
      };
      return {
        content: [{ type: "text", text: JSON.stringify(payload, null, 2) }],
      };
    },
  };
}
