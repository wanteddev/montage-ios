import { findComponent, type ComponentRecord } from "../data/index.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

function renderComponent(c: ComponentRecord): string {
  const lines: string[] = [];
  lines.push(`# ${c.name}`, "");
  lines.push(`- **Kind**: \`${c.kind}\``);
  lines.push(`- **Category**: \`${c.category}\``);
  if (c.declaration) lines.push(`- **Declaration**: \`${c.declaration}\``);
  if (c.summary) lines.push("", c.summary);

  if (c.initializers.length > 0) {
    lines.push("", "## Initializers", "");
    for (const init of c.initializers) {
      lines.push(`- \`${c.name}.${init.signature}\``);
    }
  }

  if (c.modifiers && c.modifiers.length > 0) {
    lines.push(
      "",
      "## Instance Methods (fluent modifiers)",
      "",
      "These are chainable methods that return `Self`. Use them after the initializer to configure the view.",
      "",
    );
    for (const m of c.modifiers) {
      const summary = m.summary ? ` — ${m.summary}` : "";
      lines.push(`- \`${m.signature}\`${summary}`);
    }
  }

  if (c.staticMembers && c.staticMembers.length > 0) {
    lines.push("", "## Static Members", "");
    for (const m of c.staticMembers) {
      const summary = m.summary ? ` — ${m.summary}` : "";
      lines.push(`- \`${m.signature}\`${summary}`);
    }
  }

  const enums = c.nestedTypes.filter((n) => n.kind === "enum");
  const others = c.nestedTypes.filter((n) => n.kind !== "enum");

  if (enums.length > 0) {
    lines.push("", "## Enums (variants / sizes / colors)", "");
    for (const e of enums) {
      // associated value가 있는 enum은 이름만으로 호출을 쓸 수 없으므로
      // 파라미터 라벨이 남은 시그니처를 우선 출력한다 (예: `.bottom(offset:)`).
      const cases = (e.caseSignatures ?? e.cases ?? []).map((s) => `\`.${s}\``).join(", ");
      const summary = e.summary ? ` — ${e.summary}` : "";
      lines.push(`- **${e.name}**${summary}`);
      if (cases) lines.push(`  - cases: ${cases}`);
      // enum도 직접 만들어야 하는 이니셜라이저가 있으면 노출한다. 합성된
      // `init(rawValue:)`는 생성기(`scripts/build_mcp_data.js`)에서 이미 걸러지므로
      // 여기 남는 것은 실제로 알아야 하는 API뿐이다.
      if (e.initializers && e.initializers.length > 0) {
        for (const init of e.initializers) {
          lines.push(`  - init \`${e.name}.${init.signature}\``);
        }
      }
    }
  }

  if (others.length > 0) {
    lines.push("", "## Nested Types", "");
    for (const t of others) {
      const summary = t.summary ? ` — ${t.summary}` : "";
      lines.push(`- **${t.name}** (\`${t.kind}\`)${summary}`);
      // 중첩 타입을 만드는 유일한 계약이므로 이니셜라이저를 함께 노출한다
      // (예: `ActionArea.ButtonInfo.init(text:action:)`).
      if (t.initializers && t.initializers.length > 0) {
        for (const init of t.initializers) {
          lines.push(`  - init \`${t.name}.${init.signature}\``);
        }
      }
      if (t.staticMethods && t.staticMethods.length > 0) {
        for (const sm of t.staticMethods) {
          lines.push(`  - static \`${sm.signature}\``);
        }
      }
      if (t.staticProperties && t.staticProperties.length > 0) {
        for (const sp of t.staticProperties) {
          lines.push(`  - static \`${sp.signature}\``);
        }
      }
      if (t.modifiers && t.modifiers.length > 0) {
        for (const mm of t.modifiers) {
          lines.push(`  - modifier \`${mm.signature}\``);
        }
      }
    }
  }

  return lines.join("\n").trimEnd();
}

export function getComponentTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "get_component",
    description:
      "Returns the full Montage API spec for a single component: declaration, summary, initializer signatures, and nested types (variant/size/color enums with their cases). Use this before writing SwiftUI code that uses the component.",
    inputSchema: {
      type: "object",
      properties: {
        componentName: {
          type: "string",
          description: "Component name. Case-insensitive. Examples: Button, BottomSheet, ActionArea.",
        },
      },
      required: ["componentName"],
    },
    handler: async (args) => {
      const name = String(args.componentName ?? "").trim();
      if (!name) {
        return {
          isError: true,
          content: [{ type: "text", text: "componentName is required" }],
        };
      }
      const c = findComponent(name);
      if (!c) {
        return {
          isError: true,
          content: [
            { type: "text", text: `Component not found: ${name}. Use list_components to discover available names.` },
          ],
        };
      }
      return { content: [{ type: "text", text: renderComponent(c) }] };
    },
  };
}
