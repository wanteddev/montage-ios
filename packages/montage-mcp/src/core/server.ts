import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { PACKAGE_NAME, PACKAGE_VERSION, type RuntimeConfig } from "./config.js";
import { allTools, type ToolDefinition } from "./tools/index.js";

export interface ServerContext {
  config: RuntimeConfig;
}

export function createServer(ctx: ServerContext): Server {
  const server = new Server(
    {
      name: PACKAGE_NAME,
      version: PACKAGE_VERSION,
    },
    {
      capabilities: {
        tools: {},
      },
    },
  );

  const tools = allTools(ctx);
  const byName = new Map<string, ToolDefinition>(tools.map((t) => [t.name, t]));

  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: tools.map((t) => ({
      name: t.name,
      description: t.description,
      inputSchema: t.inputSchema,
    })),
  }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const tool = byName.get(request.params.name);
    if (!tool) {
      throw new Error(`Unknown tool: ${request.params.name}`);
    }
    const args = request.params.arguments ?? {};
    return await tool.handler(args);
  });

  return server;
}
