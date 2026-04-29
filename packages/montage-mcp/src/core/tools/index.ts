import type { ServerContext } from "../server.js";
import { healthCheckTool } from "./health-check.js";

export interface ToolDefinition {
  name: string;
  description: string;
  inputSchema: {
    type: "object";
    properties?: Record<string, unknown>;
    required?: string[];
  };
  handler: (args: Record<string, unknown>) => Promise<{
    content: Array<{ type: "text"; text: string }>;
    isError?: boolean;
  }>;
}

export function allTools(ctx: ServerContext): ToolDefinition[] {
  return [
    healthCheckTool(ctx),
    // Phase 3+ will append the remaining tools here.
  ];
}
