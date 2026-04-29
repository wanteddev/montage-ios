import { resolveFigmaToken, type TokenKind } from "../mapping/index.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

const VALID_KINDS: TokenKind[] = ["color", "typography", "spacing", "shadow", "opacity"];

export function resolveFigmaTokenTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "resolve_figma_token",
    description:
      "Resolves a Figma design-token name (e.g. \"semantic/text/primary\") to a Montage Swift expression like \"Color.Semantic.Text.primary\". Manifest entries override the convention path. Numeric leaves (e.g. \"500\") are preserved.",
    inputSchema: {
      type: "object",
      properties: {
        figmaTokenName: {
          type: "string",
          description: "Figma token path with `/` separators. Example: \"semantic/text/primary\".",
        },
        kind: {
          type: "string",
          enum: VALID_KINDS,
          description: "Token kind: color | typography | spacing | shadow | opacity.",
        },
      },
      required: ["figmaTokenName", "kind"],
    },
    handler: async (args) => {
      const figmaTokenName = String(args.figmaTokenName ?? "").trim();
      const kind = String(args.kind ?? "").trim() as TokenKind;
      if (!figmaTokenName) {
        return {
          isError: true,
          content: [{ type: "text", text: "figmaTokenName is required" }],
        };
      }
      if (!VALID_KINDS.includes(kind)) {
        return {
          isError: true,
          content: [
            {
              type: "text",
              text: `kind must be one of: ${VALID_KINDS.join(", ")}`,
            },
          ],
        };
      }
      const result = resolveFigmaToken({ figmaTokenName, kind });
      return {
        isError: !result.ok,
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
      };
    },
  };
}
