/**
 * Figma → Montage convention-based matcher with manifest override.
 *
 * Matching priority:
 *   1. Manifest exact match (data/figma-mapping.json)
 *   2. Convention matcher (parse Figma path + cross-reference doccarchive)
 *   3. Failure → return fuzzy candidates (top 3 by Levenshtein) + empty snippet
 */
import {
  loadComponents,
  loadFigmaMapping,
  loadTokens,
  type ComponentRecord,
  type NestedTypeRecord,
} from "../data/index.js";

export type ResolveSource = "manifest" | "convention" | "none";
export type TokenKind = "color" | "typography" | "spacing" | "shadow" | "opacity";

export interface ComponentResolution {
  ok: boolean;
  source: ResolveSource;
  confidence: number;
  montageType?: string;
  swiftSnippet?: string;
  matchedVariants?: Record<string, string>;
  unmatchedSegments?: string[];
  candidates?: Array<{ name: string; score: number }>;
  categoryCandidates?: Array<{ name: string; category: string }>;
  notes?: string;
}

export interface TokenResolution {
  ok: boolean;
  source: ResolveSource;
  confidence: number;
  kind: TokenKind;
  swiftExpression?: string;
  /** For typography tokens — the inferred Typography.Variant case. */
  variant?: string;
  /** For typography tokens — the inferred Typography.Weight case. */
  weight?: string;
  candidates?: Array<{ name: string; score: number }>;
  notes?: string;
}

// ---------- helpers ----------

const ENUM_PROPERTY_HINTS: Record<string, string> = {
  variant: "variant",
  size: "size",
  color: "color",
  state: "state",
  style: "style",
  type: "type",
};

function normalize(s: string): string {
  return s.trim().toLowerCase();
}

function pascal(s: string): string {
  if (!s) return s;
  return s
    .split(/[\s_-]+/)
    .filter(Boolean)
    .map((p) => p.charAt(0).toUpperCase() + p.slice(1))
    .join("");
}

function camel(s: string): string {
  const p = pascal(s);
  if (!p) return p;
  return p.charAt(0).toLowerCase() + p.slice(1);
}

function levenshtein(a: string, b: string): number {
  if (a === b) return 0;
  const m = a.length;
  const n = b.length;
  if (m === 0) return n;
  if (n === 0) return m;
  const dp: number[] = new Array(n + 1);
  for (let j = 0; j <= n; j++) dp[j] = j;
  for (let i = 1; i <= m; i++) {
    let prev = dp[0]!;
    dp[0] = i;
    for (let j = 1; j <= n; j++) {
      const tmp = dp[j]!;
      const cost = a.charCodeAt(i - 1) === b.charCodeAt(j - 1) ? 0 : 1;
      dp[j] = Math.min(dp[j]! + 1, dp[j - 1]! + 1, prev + cost);
      prev = tmp;
    }
  }
  return dp[n]!;
}

function topCandidates(
  needle: string,
  haystack: string[],
  k = 3,
): Array<{ name: string; score: number }> {
  const n = normalize(needle);
  return haystack
    .map((h) => ({ name: h, score: levenshtein(n, normalize(h)) }))
    .sort((a, b) => a.score - b.score)
    .slice(0, k);
}

// ---------- component resolution ----------

/** Find which enum nested type contains a case matching `value` (case-insensitive). */
function findEnumByCase(
  component: ComponentRecord,
  value: string,
): { type: NestedTypeRecord; matchedCase: string } | null {
  const v = normalize(value);
  for (const t of component.nestedTypes) {
    if (t.kind !== "enum" || !t.cases) continue;
    const c = t.cases.find((x) => normalize(x) === v);
    if (c) return { type: t, matchedCase: c };
  }
  return null;
}

/** Convert nested type name (e.g., "Button.Variant") → init parameter name (e.g., "variant"). */
function paramNameForEnum(typeName: string): string {
  const last = typeName.split(".").pop() ?? typeName;
  const lower = last.toLowerCase();
  return ENUM_PROPERTY_HINTS[lower] ?? camel(last);
}

function placeholderForParam(componentName: string, paramName: string): string {
  // crude type guess by name
  const map: Record<string, string> = {
    text: "String",
    title: "String",
    leadingIcon: "Image",
    trailingIcon: "Image",
    icon: "Image",
    handler: "() -> Void",
    onTap: "() -> Void",
    action: "() -> Void",
  };
  const t = map[paramName];
  if (t === "() -> Void") return `{ <#code#> }`;
  if (t) return `<#${t}#>`;
  return `<#${componentName}.${pascal(paramName)}#>`;
}

function paramsFromInitializer(signature: string): string[] {
  // signature shape: init(variant:color:size:icon:handler:)
  const m = signature.match(/init\(([^)]*)\)/);
  if (!m) return [];
  return m[1]!
    .split(":")
    .map((s) => s.trim())
    .filter(Boolean);
}

function pickInitializer(
  component: ComponentRecord,
  matchedParams: Set<string>,
): { signature: string; params: string[] } | null {
  if (component.initializers.length === 0) return null;
  // Prefer the initializer whose param set contains the most matched params.
  let best: { signature: string; params: string[]; score: number } | null = null;
  for (const init of component.initializers) {
    const params = paramsFromInitializer(init.signature);
    let score = 0;
    for (const p of params) if (matchedParams.has(p)) score++;
    if (!best || score > best.score) {
      best = { signature: init.signature, params, score };
    }
  }
  return best ? { signature: best.signature, params: best.params } : null;
}

function buildSwiftSnippet(
  component: ComponentRecord,
  init: { signature: string; params: string[] },
  matched: Map<string, string>,
): string {
  const lines: string[] = [];
  lines.push(`Montage.${component.name}(`);
  const last = init.params.length - 1;
  init.params.forEach((p, idx) => {
    const value = matched.get(p) ?? placeholderForParam(component.name, p);
    const tail = idx === last ? "" : ",";
    lines.push(`  ${p}: ${value}${tail}`);
  });
  lines.push(")");
  return lines.join("\n");
}

export function resolveFigmaComponent(input: {
  figmaName: string;
  variants?: Record<string, string>;
}): ComponentResolution {
  const segments = input.figmaName
    .split("/")
    .map((s) => s.trim())
    .filter(Boolean);
  if (segments.length === 0) {
    return { ok: false, source: "none", confidence: 0, notes: "empty figmaName" };
  }
  const typeSegment = segments[0]!;
  const variantSegments = segments.slice(1);
  const incoming = input.variants ?? {};

  // 1. Manifest exact match
  const mapping = loadFigmaMapping();
  const manifestKey = input.figmaName;
  const manifestHit = mapping.components[manifestKey];
  if (manifestHit) {
    return {
      ok: true,
      source: "manifest",
      confidence: 1.0,
      montageType: manifestHit.montageType,
      swiftSnippet: manifestHit.swiftSnippet,
      notes: manifestHit.notes ?? "manifest hit",
    };
  }

  // 2. Convention matcher
  const idx = loadComponents();
  const componentNames = idx.components.map((c) => c.name);
  const target = idx.components.find(
    (c) => normalize(c.name) === normalize(typeSegment) || c.slug === normalize(typeSegment),
  );
  if (!target) {
    return {
      ok: false,
      source: "none",
      confidence: 0,
      candidates: topCandidates(typeSegment, componentNames),
      notes: `no component matches "${typeSegment}"`,
    };
  }

  const matchedParams = new Map<string, string>();
  const matchedVariants: Record<string, string> = {};
  const unmatched: string[] = [];

  // (a) named variants from explicit input
  for (const [propRaw, value] of Object.entries(incoming)) {
    const found = findEnumByCase(target, value);
    if (found) {
      const paramName = paramNameForEnum(found.type.name);
      matchedParams.set(paramName, `.${found.matchedCase}`);
      matchedVariants[paramName] = found.matchedCase;
    } else {
      unmatched.push(`${propRaw}=${value}`);
    }
  }

  // (b) positional segments from path
  for (const seg of variantSegments) {
    const found = findEnumByCase(target, seg);
    if (found) {
      const paramName = paramNameForEnum(found.type.name);
      if (!matchedParams.has(paramName)) {
        matchedParams.set(paramName, `.${found.matchedCase}`);
        matchedVariants[paramName] = found.matchedCase;
      }
    } else {
      unmatched.push(seg);
    }
  }

  const init = pickInitializer(target, new Set(matchedParams.keys()));
  if (!init) {
    return {
      ok: false,
      source: "none",
      confidence: 0,
      montageType: target.name,
      notes: `${target.name} has no initializers in slim index`,
    };
  }

  const swiftSnippet = buildSwiftSnippet(target, init, matchedParams);
  const matchRate = matchedParams.size / Math.max(1, matchedParams.size + unmatched.length);
  const confidence = 0.6 + 0.35 * matchRate; // 0.6 ~ 0.95

  const result: ComponentResolution = {
    ok: true,
    source: "convention",
    confidence,
    montageType: target.name,
    swiftSnippet,
    matchedVariants,
    notes: `matched via convention; init ${init.signature}`,
  };
  if (unmatched.length > 0) result.unmatchedSegments = unmatched;
  // When the match is weak (unmatched segments OR low confidence), also surface
  // siblings in the same category — the Figma name might actually point at
  // a separate component (e.g. "Card/List" → ListCard, not a Card variant).
  if (unmatched.length > 0 || confidence < 0.85) {
    const siblings = idx.components
      .filter((c) => c.category === target.category && c.slug !== target.slug)
      .map((c) => ({ name: c.name, category: c.category }));
    if (siblings.length > 0) result.categoryCandidates = siblings;
  }
  return result;
}

// ---------- token resolution ----------

const KIND_TO_SWIFT_TYPE: Record<TokenKind, string> = {
  color: "Color",
  typography: "Typography",
  spacing: "Spacing",
  shadow: "Shadow",
  opacity: "Opacity",
};

function isNumericLike(s: string): boolean {
  return /^[0-9]+(\.[0-9]+)?$/.test(s);
}

function tokenSegmentToSwift(seg: string, isLeaf: boolean): string {
  // Numeric leaf (e.g. "500", "100") → keep as-is.
  if (isNumericLike(seg)) return seg;
  return isLeaf ? camel(seg) : pascal(seg);
}

/**
 * Typography-specific matcher.
 *
 * Figma typography names typically look like:
 *   "Body 1/Reading - Regular"
 *   "Heading 1 - Bold"
 *   "Title 2/Reading - Medium"
 *
 * Strategy:
 *   - Split by " - " — last segment is the weight if it matches a known weight name.
 *   - The remainder splits by "/" and whitespace; concatenate as camelCase to match
 *     Typography.Variant cases (body1Reading, heading1, title2, etc).
 *   - Validate against tokens.json typography variant/weight enums for confidence.
 */
function resolveTypographyToken(figmaName: string): TokenResolution {
  const KNOWN_WEIGHTS = ["regular", "medium", "bold", "semibold", "light", "thin", "heavy"];
  const dashSplit = figmaName.split(/\s*-\s*/).map((s) => s.trim()).filter(Boolean);
  let weight: string | undefined;
  let remainder = figmaName;
  if (dashSplit.length > 1) {
    const last = dashSplit[dashSplit.length - 1]!.toLowerCase();
    if (KNOWN_WEIGHTS.includes(last)) {
      weight = last;
      remainder = dashSplit.slice(0, -1).join(" - ");
    }
  }
  const segments = remainder.split(/[\s/]+/).filter(Boolean);
  if (segments.length === 0) {
    return {
      ok: false,
      source: "none",
      confidence: 0,
      kind: "typography",
      notes: "could not parse typography name",
    };
  }
  // First segment lowercased, rest TitleCase, then concatenated.
  const variant = segments
    .map((s, i) => {
      if (i === 0) return s.charAt(0).toLowerCase() + s.slice(1);
      return s.charAt(0).toUpperCase() + s.slice(1);
    })
    .join("");

  // Validate against tokens.json typography enums.
  const tokens = loadTokens();
  const ty = tokens.tokens.typography;
  let variantOk = false;
  let weightOk = !weight; // if weight not parsed, no validation needed
  let candidates: Array<{ name: string; score: number }> | undefined;
  if (ty) {
    const variantEnum = ty.nestedTypes.find((n) => n.name.endsWith(".Variant"));
    const weightEnum = ty.nestedTypes.find((n) => n.name.endsWith(".Weight"));
    if (variantEnum?.cases?.includes(variant)) variantOk = true;
    else if (variantEnum?.cases) {
      candidates = topCandidates(variant, variantEnum.cases);
    }
    if (weight && weightEnum?.cases?.includes(weight)) weightOk = true;
  }
  const confidence = variantOk && weightOk ? 0.95 : variantOk ? 0.8 : 0.5;
  const exprParts = [`variant: .${variant}`];
  if (weight) exprParts.push(`weight: .${weight}`);
  const swiftExpression = `(${exprParts.join(", ")})`;

  const result: TokenResolution = {
    ok: variantOk,
    source: "convention",
    confidence,
    kind: "typography",
    swiftExpression,
    variant,
    notes:
      "Typography is normally consumed via host helpers like `Text(\"...\").paragraph(variant: ..., weight: ..., color: ...)` defined in the host app. The exact modifier name is host-defined; this resolver only reports the Montage Typography enum cases. **Modifier order matters**: the host helper (e.g. `.paragraph(...)`) consumes a `Text` and returns `some View`, so it MUST be chained directly on the `Text` BEFORE any SwiftUI standard modifier (`.multilineTextAlignment`, `.frame`, `.padding`, etc). Putting `.multilineTextAlignment(.center)` before `.paragraph(...)` narrows the type and the typography helper either fails to apply or silently drops styling.",
  };
  if (weight) result.weight = weight;
  if (candidates) result.candidates = candidates;
  return result;
}

export function resolveFigmaToken(input: {
  figmaTokenName: string;
  kind: TokenKind;
}): TokenResolution {
  const path = input.figmaTokenName
    .split("/")
    .map((s) => s.trim())
    .filter(Boolean);
  if (path.length === 0) {
    return {
      ok: false,
      source: "none",
      confidence: 0,
      kind: input.kind,
      notes: "empty figmaTokenName",
    };
  }

  const mapping = loadFigmaMapping();
  const manifestHit = mapping.tokens[input.kind]?.[input.figmaTokenName];
  if (manifestHit) {
    const result: TokenResolution = {
      ok: true,
      source: "manifest",
      confidence: 1.0,
      kind: input.kind,
      swiftExpression: manifestHit,
    };
    if (input.kind === "color") {
      result.notes =
        "**Color namespace conflict**: Montage defines `public enum Color` AND extends `SwiftUI.Color` with `static func semantic(_:) / atomic(_:)`. In TYPE-ANNOTATION position (stored property, return type, function parameter) bare `Color` resolves to `Montage.Color` (the enum) and produces a 'Cannot convert value' compile error. **Always annotate as `SwiftUI.Color`** when storing or returning a color value: `private var bg: SwiftUI.Color { Color.semantic(.primaryNormal) }`. Inside an expression `Color.semantic(...)` is fine — the conflict is only at type positions.";
    }
    return result;
  }

  // Typography has its own matcher (variant + weight, not a chained property).
  if (input.kind === "typography") {
    return resolveTypographyToken(input.figmaTokenName);
  }

  // Convention: build chained property path under Color.X.Y.z, etc.
  const swiftSegments = path.map((seg, i) =>
    tokenSegmentToSwift(seg, i === path.length - 1),
  );
  const swiftExpression = [KIND_TO_SWIFT_TYPE[input.kind], ...swiftSegments].join(".");

  // Soft validation: see if an identifier matching the path appears in tokens.json.
  const tokens = loadTokens();
  const t = tokens.tokens[input.kind];
  let confidence = 0.7;
  let candidates: Array<{ name: string; score: number }> | undefined;
  if (t) {
    const allIdentifiers = t.sections.flatMap((s) => s.identifiers);
    const leaf = path[path.length - 1] ?? "";
    const exact = allIdentifiers.find((id) => normalize(id) === normalize(leaf));
    if (exact) confidence = 0.9;
    else candidates = topCandidates(leaf, allIdentifiers);
  }

  const baseNote =
    "convention path; verify against documentation if confidence < 0.9. Numeric segments preserved verbatim.";
  const colorTypeAnnotationNote =
    " **Color namespace conflict**: Montage defines `public enum Color` AND extends `SwiftUI.Color` with `static func semantic(_:) / atomic(_:)`. The expression `Color.semantic(.foo)` resolves to a `SwiftUI.Color` value, but in TYPE-ANNOTATION position (stored property, return type, function parameter) bare `Color` resolves to `Montage.Color` (the enum) and produces a 'Cannot convert value' compile error. **Always annotate as `SwiftUI.Color`** when storing or returning a color value: `private var bg: SwiftUI.Color { Color.semantic(.primaryNormal) }`. Inside an expression `Color.semantic(...)` is fine — the conflict is only at type positions.";
  const result: TokenResolution = {
    ok: true,
    source: "convention",
    confidence,
    kind: input.kind,
    swiftExpression,
    notes: input.kind === "color" ? baseNote + colorTypeAnnotationNote : baseNote,
  };
  if (candidates) result.candidates = candidates;
  return result;
}
