import { readMarkdown } from "../data/markdown.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function getColorUsageTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "get_color_usage",
    description:
      "Returns Montage Color usage guidelines and the full reference of semantic and atomic color tokens (sourced from documentation/utilities/ios-utility-components/color.md).",
    inputSchema: { type: "object" },
    handler: async () => ({
      content: [{ type: "text", text: readMarkdown("color-usage.md") }],
    }),
  };
}
