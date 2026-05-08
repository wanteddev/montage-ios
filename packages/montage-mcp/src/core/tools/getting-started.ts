import { readMarkdown } from "../data/markdown.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function gettingStartedTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "getting_started",
    description:
      "Returns the Montage iOS getting-started guide (installation, initial setup, minimal usage example).",
    inputSchema: { type: "object" },
    handler: async () => ({
      content: [{ type: "text", text: readMarkdown("getting-started.md") }],
    }),
  };
}
