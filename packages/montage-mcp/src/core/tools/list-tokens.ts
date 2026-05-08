import { loadTokens } from "../data/index.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function listTokensTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "list_tokens",
    description:
      "Lists all Montage design tokens (Color, Typography, Spacing, Shadow, Opacity) with their semantic groupings. Returns Swift expression hints that can be used in SwiftUI code.",
    inputSchema: { type: "object" },
    handler: async () => {
      const idx = loadTokens();
      const lines: string[] = ["# Montage Design Tokens", ""];
      for (const [kind, rec] of Object.entries(idx.tokens)) {
        if (!rec) continue;
        lines.push(`## ${rec.name}`);
        if (rec.summary) lines.push("", rec.summary);
        lines.push("", `**Kind**: \`${rec.kind}\``);
        if (rec.sections.length > 0) {
          lines.push("", "**Sections**:");
          for (const s of rec.sections) {
            const items = s.identifiers
              .map((i) => `\`${i}\``)
              .slice(0, 12)
              .join(", ");
            const more = s.identifiers.length > 12 ? `, … (+${s.identifiers.length - 12} more)` : "";
            lines.push(`- *${s.title || s.anchor || kind}*: ${items}${more}`);
          }
        }
        if (rec.nestedTypes.length > 0) {
          lines.push("", "**Nested types**:");
          for (const n of rec.nestedTypes) {
            const cases = n.cases ? ` (cases: ${n.cases.map((c) => `\`.${c}\``).join(", ")})` : "";
            lines.push(`- ${n.name} \`${n.kind}\`${cases}`);
          }
        }
        lines.push("");
      }
      return {
        content: [{ type: "text", text: lines.join("\n").trimEnd() }],
      };
    },
  };
}
