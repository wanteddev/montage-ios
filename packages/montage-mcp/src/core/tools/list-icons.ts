import { loadIcons } from "../data/index.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function listIconsTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "list_icons",
    description:
      "Lists Montage icon asset names from Icon.xcassets. Optional `query` filter performs a case-insensitive substring match. Returns matching icon names suitable for `Image.MontageIcon(name:)` usage.",
    inputSchema: {
      type: "object",
      properties: {
        query: {
          type: "string",
          description: "Optional substring to filter icon names (case-insensitive).",
        },
        limit: {
          type: "number",
          description: "Maximum number of icons to return (default 200).",
        },
      },
    },
    handler: async (args) => {
      const idx = loadIcons();
      const q = typeof args.query === "string" ? args.query.trim().toLowerCase() : "";
      const limit = Math.max(1, Math.min(500, Number(args.limit ?? 200)));
      const filtered = q
        ? idx.icons.filter((n) => n.toLowerCase().includes(q))
        : idx.icons;
      const truncated = filtered.length > limit ? filtered.slice(0, limit) : filtered;
      const lines: string[] = [];
      lines.push(`# Montage Icons`);
      lines.push("");
      lines.push(`- **Total in catalog**: ${idx.count}`);
      if (q) lines.push(`- **Filter**: \`${q}\``);
      lines.push(`- **Returned**: ${truncated.length}${filtered.length > truncated.length ? ` (truncated from ${filtered.length}; pass \`limit\` to widen)` : ""}`);
      lines.push("");
      for (const name of truncated) {
        lines.push(`- ${name}`);
      }
      return {
        content: [{ type: "text", text: lines.join("\n").trimEnd() }],
      };
    },
  };
}
