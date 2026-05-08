import { readMarkdown } from "../data/markdown.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function figmaToSwiftuiWorkflowTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "figma_to_swiftui_workflow",
    description:
      "Returns the step-by-step procedure for converting a Figma design into Montage SwiftUI code. Call this when the user provides a Figma URL and asks for SwiftUI/Montage code, or requests a Figma→SwiftUI conversion. The response orchestrates the other montage-ios MCP tools (montage_coding_guidelines, list_components, resolve_figma_component, get_component, resolve_figma_token, list_tokens, get_color_usage, list_icons) and the Figma MCP tools.",
    inputSchema: { type: "object" },
    handler: async () => ({
      content: [{ type: "text", text: readMarkdown("figma-to-swiftui-workflow.md") }],
    }),
  };
}
