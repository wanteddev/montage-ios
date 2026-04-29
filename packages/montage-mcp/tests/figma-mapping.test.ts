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
  it("maps semantic/text/primary to Color.Semantic.Text.primary", () => {
    const r = resolveFigmaToken({ figmaTokenName: "semantic/text/primary", kind: "color" });
    expect(r.ok).toBe(true);
    expect(r.swiftExpression).toBe("Color.Semantic.Text.primary");
  });

  it("preserves numeric leaves", () => {
    const r = resolveFigmaToken({ figmaTokenName: "atomic/blue/500", kind: "color" });
    expect(r.swiftExpression).toBe("Color.Atomic.Blue.500");
  });

  it("rejects unknown kind via tool layer (not the resolver)", () => {
    // resolver takes typed input; tool wrapper validates strings. Just sanity-check kinds we accept.
    const kinds = ["color", "typography", "spacing", "shadow", "opacity"] as const;
    for (const k of kinds) {
      const r = resolveFigmaToken({ figmaTokenName: "a/b", kind: k });
      expect(r.ok).toBe(true);
      expect(r.swiftExpression).toMatch(/^[A-Z]/);
    }
  });
});
