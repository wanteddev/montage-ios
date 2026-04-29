import { readMarkdown } from "../data/markdown.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function montageCodingGuidelinesTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "montage_coding_guidelines",
    description:
      "Returns guidelines for writing SwiftUI code that uses the Montage design system — import statements, when to prefer Montage over standard SwiftUI views, design-token usage, Figma→SwiftUI workflow, and accessibility rules.",
    inputSchema: { type: "object" },
    handler: async () => ({
      content: [{ type: "text", text: readMarkdown("coding-guidelines.md") }],
    }),
  };
}
