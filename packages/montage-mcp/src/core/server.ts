import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { PACKAGE_NAME, PACKAGE_VERSION, type RuntimeConfig } from "./config.js";
import { allTools, type ToolDefinition } from "./tools/index.js";
import { getTracker } from "./tracker/index.js";
import { logDebug } from "./logger.js";

export interface ServerContext {
  config: RuntimeConfig;
  transport: "stdio" | "http";
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

  server.setRequestHandler(ListToolsRequestSchema, async () => {
    logDebug("tools/list", { count: tools.length, transport: ctx.transport });
    return {
      tools: tools.map((t) => ({
        name: t.name,
        description: t.description,
        inputSchema: t.inputSchema,
      })),
    };
  });

  const tracker = getTracker(ctx.config);
  tracker.start();

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const args = request.params.arguments ?? {};
    const startedAt = Date.now();
    let ok = true;
    let errorClass: string | undefined;
    logDebug("tools/call start", {
      toolName: request.params.name,
      transport: ctx.transport,
      params: args,
    });
    try {
      const tool = byName.get(request.params.name);
      if (!tool) {
        ok = false;
        errorClass = "UnknownTool";
        throw new Error(`Unknown tool: ${request.params.name}`);
      }
      const result = await tool.handler(args);
      if (result.isError) {
        ok = false;
        errorClass = "ToolReturnedError";
      }
      return result;
    } catch (err) {
      ok = false;
      if (!errorClass) {
        errorClass = err instanceof Error ? err.constructor.name : "UnknownError";
      }
      throw err;
    } finally {
      const durationMs = Date.now() - startedAt;
      logDebug("tools/call end", {
        toolName: request.params.name,
        transport: ctx.transport,
        status: ok ? "success" : "error",
        duration_ms: durationMs,
        ...(errorClass ? { error_class: errorClass } : {}),
      });
      tracker.track({
        tool: request.params.name,
        transport: ctx.transport,
        args,
        durationMs,
        ok,
        ...(errorClass ? { errorClass } : {}),
      });
    }
  });

  return server;
}
