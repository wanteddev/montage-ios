import { describe, it, expect } from "vitest";
import { resolveFigmaComponent, resolveFigmaToken } from "../src/core/mapping/index.js";

describe("resolveFigmaComponent (convention)", () => {
  it("matches Button/Solid/Large to a Button initializer with variant + size filled", () => {
    const r = resolveFigmaComponent({ figmaName: "Button/Solid/Large" });
    expect(r.ok).toBe(true);
    expect(r.source).toBe("convention");
    expect(r.montageType).toBe("Button");
    expect(r.matchedVariants).toMatchObject({ variant: "solid", size: "large" });
    expect(r.swiftSnippet).toMatch(/Montage\.Button\(/);
    expect(r.swiftSnippet).toMatch(/variant: \.solid/);
    expect(r.swiftSnippet).toMatch(/size: \.large/);
    expect(r.confidence).toBeGreaterThanOrEqual(0.6);
  });

  it("uses explicit named variants over positional segments", () => {
    const r = resolveFigmaComponent({
      figmaName: "Button",
      variants: { variant: "outlined", color: "primary", size: "small" },
    });
    expect(r.ok).toBe(true);
    expect(r.matchedVariants).toMatchObject({
      variant: "outlined",
      color: "primary",
      size: "small",
    });
    expect(r.swiftSnippet).toMatch(/variant: \.outlined/);
    expect(r.swiftSnippet).toMatch(/color: \.primary/);
    expect(r.swiftSnippet).toMatch(/size: \.small/);
  });

  it("returns Xcode placeholder for params not derivable from variants", () => {
    const r = resolveFigmaComponent({ figmaName: "Button/Solid/Large" });
    expect(r.swiftSnippet).toMatch(/<#.*#>|\{ <#code#> \}/);
  });

  it("flags unknown segments without failing the whole resolve", () => {
    const r = resolveFigmaComponent({ figmaName: "Button/Solid/Large/Foo" });
    expect(r.ok).toBe(true);
    expect(r.unmatchedSegments).toContain("Foo");
  });

  it("returns candidates when component name is unknown", () => {
    const r = resolveFigmaComponent({ figmaName: "Buttone" });
    expect(r.ok).toBe(false);
    expect(r.candidates && r.candidates.length).toBeGreaterThan(0);
    expect(r.candidates![0]!.name).toBe("Button");
  });
});

describe("resolveFigmaToken (convention)", () => {
  // Convention-only paths: the resolver builds chained property syntax from the
  // Figma path even when the produced expression doesn't exist in Montage's
  // catalog (which uses flat case names like `primaryNormal` / `blue50`). The
  // caller is expected to consult `confidence` and `candidates` before emitting
  // these into generated code.
  it("emits convention path for unknown leaf and signals low confidence", () => {
    const r = resolveFigmaToken({ figmaTokenName: "semantic/text/primary", kind: "color" });
    expect(r.ok).toBe(true);
    expect(r.swiftExpression).toBe("Color.Semantic.Text.primary");
    // Catalog has no `primary` case under Semantic — resolver must flag low confidence.
    expect(r.confidence).toBeLessThan(0.9);
  });

  it("preserves numeric leaves verbatim in convention path", () => {
    const r = resolveFigmaToken({ figmaTokenName: "atomic/blue/500", kind: "color" });
    expect(r.swiftExpression).toBe("Color.Atomic.Blue.500");
    expect(r.confidence).toBeLessThan(0.9);
  });

  it("returns convention paths for color/spacing/shadow/opacity (chained property)", () => {
    const kinds = ["color", "spacing", "shadow", "opacity"] as const;
    for (const k of kinds) {
      const r = resolveFigmaToken({ figmaTokenName: "a/b", kind: k });
      expect(r.ok).toBe(true);
      expect(r.swiftExpression).toMatch(/^[A-Z]/);
    }
  });

  it("typography: parses 'Body 1/Reading - Regular' to variant body1Reading + weight regular", () => {
    const r = resolveFigmaToken({
      figmaTokenName: "Body 1/Reading - Regular",
      kind: "typography",
    });
    expect(r.ok).toBe(true);
    expect(r.variant).toBe("body1Reading");
    expect(r.weight).toBe("regular");
    expect(r.swiftExpression).toBe("(variant: .body1Reading, weight: .regular)");
    expect(r.confidence).toBeGreaterThanOrEqual(0.9);
  });

  it("typography: parses 'Heading 1 - Bold' to variant heading1 + weight bold", () => {
    const r = resolveFigmaToken({ figmaTokenName: "Heading 1 - Bold", kind: "typography" });
    expect(r.ok).toBe(true);
    expect(r.variant).toBe("heading1");
    expect(r.weight).toBe("bold");
  });

  it("typography: returns fuzzy candidates when variant case is unknown", () => {
    const r = resolveFigmaToken({ figmaTokenName: "Bogus 9", kind: "typography" });
    expect(r.ok).toBe(false);
    expect(r.candidates && r.candidates.length).toBeGreaterThan(0);
  });
});

describe("resolveFigmaComponent (manifest + category candidates)", () => {
  it("Card/List → ListCard via manifest (priority over Card convention)", () => {
    const r = resolveFigmaComponent({ figmaName: "Card/List" });
    expect(r.ok).toBe(true);
    expect(r.source).toBe("manifest");
    expect(r.confidence).toBe(1.0);
    expect(r.montageType).toBe("ListCard");
    expect(r.swiftSnippet).toMatch(/ListCard\(/);
    expect(r.swiftSnippet).toMatch(/\.caption\(/);
  });

  it("weak convention match surfaces same-category candidates", () => {
    const r = resolveFigmaComponent({ figmaName: "Card/Bogus" });
    expect(r.ok).toBe(true); // resolver still produces something
    if (r.unmatchedSegments) {
      expect(r.categoryCandidates).toBeDefined();
      const names = (r.categoryCandidates ?? []).map((c) => c.name);
      // Expect ListCard in same `contents` category
      expect(names).toContain("ListCard");
    }
  });
});

describe("get_component (modifiers section)", () => {
  it("ListCard get_component output now exposes fluent modifiers", async () => {
    const { healthCheckTool } = await import("../src/core/tools/health-check.js");
    void healthCheckTool; // touch unused
    const { allTools } = await import("../src/core/tools/index.js");
    const { loadConfig } = await import("../src/core/config.js");
    const tools = allTools({ config: loadConfig({}), transport: "stdio" });
    const get = tools.find((t) => t.name === "get_component")!;
    const r = await get.handler({ componentName: "ListCard" });
    const text = r.content[0]!.text;
    expect(text).toMatch(/Instance Methods/);
    expect(text).toMatch(/fluent modifiers/);
    expect(text).toMatch(/caption/);
    expect(text).toMatch(/extraCaption/);
  });
});
