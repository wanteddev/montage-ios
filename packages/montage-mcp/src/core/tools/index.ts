import type { ServerContext } from "../server.js";
import { healthCheckTool } from "./health-check.js";
import { gettingStartedTool } from "./getting-started.js";
import { montageCodingGuidelinesTool } from "./montage-coding-guidelines.js";
import { listComponentsTool } from "./list-components.js";
import { getComponentTool } from "./get-component.js";
import { listTokensTool } from "./list-tokens.js";
import { getColorUsageTool } from "./get-color-usage.js";
import { listIconsTool } from "./list-icons.js";
import { resolveFigmaComponentTool } from "./resolve-figma-component.js";
import { resolveFigmaTokenTool } from "./resolve-figma-token.js";
import { figmaToSwiftuiWorkflowTool } from "./figma-to-swiftui-workflow.js";

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
    gettingStartedTool(ctx),
    montageCodingGuidelinesTool(ctx),
    listComponentsTool(ctx),
    getComponentTool(ctx),
    listTokensTool(ctx),
    getColorUsageTool(ctx),
    listIconsTool(ctx),
    resolveFigmaComponentTool(ctx),
    resolveFigmaTokenTool(ctx),
    figmaToSwiftuiWorkflowTool(ctx),
  ];
}
