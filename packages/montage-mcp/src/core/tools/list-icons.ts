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
      const input: Record<string, unknown> =
        args && typeof args === "object" ? args : {};
      const idx = loadIcons();
      const q =
        typeof input.query === "string"
          ? input.query.trim().toLowerCase()
          : "";
      const rawLimit = Number(input.limit ?? 200);
      const limit = Number.isFinite(rawLimit)
        ? Math.max(1, Math.min(500, rawLimit))
        : 200;
      const filtered = q
        ? idx.icons.filter((n) => n.toLowerCase().includes(q))
        : idx.icons;
      const truncated = filtered.length > limit ? filtered.slice(0, limit) : filtered;
      const isMulticolor = (name: string) => /Color$/.test(name);
      const lines: string[] = [];
      lines.push(`# Montage Icons`);
      lines.push("");
      lines.push(`- **Total in catalog**: ${idx.count}`);
      if (q) lines.push(`- **Filter**: \`${q}\``);
      lines.push(`- **Returned**: ${truncated.length}${filtered.length > truncated.length ? ` (truncated from ${filtered.length}; pass \`limit\` to widen)` : ""}`);
      lines.push("");
      const hasMulticolorInResult = truncated.some(isMulticolor);
      lines.push(`## Rendering (CRITICAL — read before generating code)`);
      lines.push("");
      lines.push("- Single-color icons: tint with `.foregroundColor(...)` as usual.");
      lines.push("- **Multicolor icons** — any icon whose name ends in `Color` (e.g. `agentColor`, `aiReviewColor`, `*Color`) — are multi-channel raster/vector assets. SwiftUI's default `.template` rendering mode collapses them to a single tint, destroying the design. **You MUST chain `.renderingMode(.original)` directly after `Image.icon(...)` BEFORE `.resizable()` and any frame/tint modifiers.** This is non-negotiable; omitting it is a common LLM-generated bug.");
      lines.push("");
      lines.push("```swift");
      lines.push("// ✅ Correct");
      lines.push("Image.icon(.agentColor)");
      lines.push("    .renderingMode(.original)  // REQUIRED for *Color icons — do not omit");
      lines.push("    .resizable()");
      lines.push("    .scaledToFit()");
      lines.push("    .frame(width: 48, height: 48)");
      lines.push("");
      lines.push("// ❌ Wrong — multicolor icon will render as a single tinted glyph");
      lines.push("Image.icon(.agentColor)");
      lines.push("    .resizable()");
      lines.push("    .frame(width: 48, height: 48)");
      lines.push("```");
      lines.push("");
      if (hasMulticolorInResult) {
        lines.push("> The result list below contains at least one multicolor (`*Color`) icon. Apply the rule above when emitting code for those entries.");
        lines.push("");
      }
      lines.push(`## Icons`);
      lines.push("");
      for (const name of truncated) {
        if (isMulticolor(name)) {
          lines.push(`- ${name} _(multicolor — requires \`.renderingMode(.original)\`)_`);
        } else {
          lines.push(`- ${name}`);
        }
      }
      return {
        content: [{ type: "text", text: lines.join("\n").trimEnd() }],
      };
    },
  };
}
