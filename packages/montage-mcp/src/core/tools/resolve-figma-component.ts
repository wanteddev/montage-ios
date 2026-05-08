import { resolveFigmaComponent } from "../mapping/index.js";
import type { ServerContext } from "../server.js";
import type { ToolDefinition } from "./index.js";

export function resolveFigmaComponentTool(_ctx: ServerContext): ToolDefinition {
  return {
    name: "resolve_figma_component",
    description:
      "Resolves a Figma component name (e.g. \"Button/Solid/Large\") plus optional variants to a Montage SwiftUI initializer call. Tries an explicit manifest first, then a convention-based matcher that cross-references doccarchive enums. On miss, returns fuzzy candidates so the caller can disambiguate.",
    inputSchema: {
      type: "object",
      properties: {
        figmaName: {
          type: "string",
          description:
            "Figma component path. First segment is the component type, subsequent segments are positional variants. Example: \"Button/Solid/Large\".",
        },
        variants: {
          type: "object",
          description:
            "Optional named variants from Figma component properties. Example: { variant: \"solid\", size: \"large\", color: \"primary\" }.",
        },
      },
      required: ["figmaName"],
    },
    handler: async (args) => {
      const figmaName = String(args.figmaName ?? "").trim();
      if (!figmaName) {
        return {
          isError: true,
          content: [{ type: "text", text: "figmaName is required" }],
        };
      }
      const isPlainObject =
        args.variants !== null &&
        typeof args.variants === "object" &&
        !Array.isArray(args.variants);
      if (args.variants != null && !isPlainObject) {
        return {
          isError: true,
          content: [
            { type: "text", text: "variants must be a plain object of primitive values" },
          ],
        };
      }
      const variants = isPlainObject
        ? Object.fromEntries(
            Object.entries(args.variants as Record<string, unknown>)
              .filter(([, v]) =>
                ["string", "number", "boolean"].includes(typeof v),
              )
              .map(([k, v]) => [k, String(v)]),
          )
        : null;
      const result = variants
        ? resolveFigmaComponent({ figmaName, variants })
        : resolveFigmaComponent({ figmaName });
      return {
        isError: !result.ok,
        content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
      };
    },
  };
}
