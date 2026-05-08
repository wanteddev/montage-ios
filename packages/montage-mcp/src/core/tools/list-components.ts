import { listCategories } from "../data/index.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

const CATEGORY_LABELS: Record<string, string> = {
  actions: "Actions",
  contents: "Contents",
  feedback: "Feedback",
  loading: "Loading",
  navigations: "Navigations",
  presentation: "Presentation",
  "selection-input": "Selection & Input",
  utilities: "Utilities",
  uncategorized: "Uncategorized",
};

const CATEGORY_ORDER = [
  "actions",
  "contents",
  "feedback",
  "loading",
  "navigations",
  "presentation",
  "selection-input",
  "utilities",
  "uncategorized",
];

export function listComponentsTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "list_components",
    description:
      "Lists all Montage components grouped by category (Actions/Contents/Feedback/Loading/Navigations/Presentation/Selection & Input/Utilities). Each entry shows the component name, kind (struct/class/enum), and one-line summary.",
    inputSchema: { type: "object" },
    handler: async () => {
      const cats = listCategories();
      const lines: string[] = ["# Montage Components", ""];
      const knownKeys = new Set(CATEGORY_ORDER);
      const extraKeys = Object.keys(cats).filter((k) => !knownKeys.has(k));
      for (const key of [...CATEGORY_ORDER, ...extraKeys]) {
        const items = cats[key];
        if (!items || items.length === 0) continue;
        lines.push(`## ${CATEGORY_LABELS[key] ?? key}`, "");
        for (const c of items) {
          const summary = c.summary ? ` — ${c.summary}` : "";
          lines.push(`- **${c.name}** (${c.kind})${summary}`);
        }
        lines.push("");
      }
      return {
        content: [{ type: "text", text: lines.join("\n").trimEnd() }],
      };
    },
  };
}
