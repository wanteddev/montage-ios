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
  notes?: string;
}

export interface TokenResolution {
  ok: boolean;
  source: ResolveSource;
  confidence: number;
  kind: TokenKind;
  swiftExpression?: string;
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
    return {
      ok: true,
      source: "manifest",
      confidence: 1.0,
      kind: input.kind,
      swiftExpression: manifestHit,
    };
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

  const result: TokenResolution = {
    ok: true,
    source: "convention",
    confidence,
    kind: input.kind,
    swiftExpression,
    notes:
      "convention path; verify against documentation if confidence < 0.9. Numeric segments preserved verbatim.",
  };
  if (candidates) result.candidates = candidates;
  return result;
}
