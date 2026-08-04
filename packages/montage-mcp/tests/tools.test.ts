import { describe, it, expect } from "vitest";
import { loadConfig } from "../src/core/config.js";
import { allTools } from "../src/core/tools/index.js";

const ctx = { config: loadConfig({}), transport: "stdio" as const };
const tools = allTools(ctx);
const byName = new Map(tools.map((t) => [t.name, t]));

function get(name: string) {
  const t = byName.get(name);
  if (!t) throw new Error(`tool not registered: ${name}`);
  return t;
}

describe("tool registry", () => {
  it("registers the 8 mirror tools", () => {
    expect(byName.has("health_check")).toBe(true);
    expect(byName.has("getting_started")).toBe(true);
    expect(byName.has("montage_coding_guidelines")).toBe(true);
    expect(byName.has("list_components")).toBe(true);
    expect(byName.has("get_component")).toBe(true);
    expect(byName.has("list_tokens")).toBe(true);
    expect(byName.has("get_color_usage")).toBe(true);
    expect(byName.has("list_icons")).toBe(true);
  });
});

describe("getting_started", () => {
  it("returns non-empty content", async () => {
    const r = await get("getting_started").handler({});
    expect(r.isError).toBeFalsy();
    expect(r.content[0]!.text.length).toBeGreaterThan(50);
  });
});

describe("montage_coding_guidelines", () => {
  it("mentions design tokens and Figma workflow", async () => {
    const r = await get("montage_coding_guidelines").handler({});
    expect(r.content[0]!.text).toMatch(/디자인 토큰|design token/i);
    expect(r.content[0]!.text).toMatch(/Figma/i);
  });
});

describe("figma_to_swiftui_workflow", () => {
  it("returns the Figma→SwiftUI procedure", async () => {
    const r = await get("figma_to_swiftui_workflow").handler({});
    expect(r.isError).toBeFalsy();
    const text = r.content[0]!.text;
    expect(text).toMatch(/resolve_figma_component/);
    expect(text).toMatch(/resolve_figma_token/);
    expect(text).toMatch(/montage_coding_guidelines/);
  });
});

describe("list_components", () => {
  it("groups by known categories and lists Button under Actions", async () => {
    const r = await get("list_components").handler({});
    const text = r.content[0]!.text;
    expect(text).toMatch(/## Actions/);
    expect(text).toMatch(/\*\*Button\*\*/);
    expect(text).toMatch(/## Selection & Input/);
  });
});

describe("get_component", () => {
  it("returns Button with both initializers and Variant enum cases", async () => {
    const r = await get("get_component").handler({ componentName: "Button" });
    expect(r.isError).toBeFalsy();
    const text = r.content[0]!.text;
    expect(text).toMatch(/init\(variant:color:size:icon:handler:\)/);
    expect(text).toMatch(/init\(variant:color:size:text:leadingIcon:trailingIcon:handler:\)/);
    expect(text).toMatch(/Button\.Variant/);
    expect(text).toMatch(/`\.solid`/);
    expect(text).toMatch(/`\.outlined`/);
  });

  it("is case-insensitive", async () => {
    const r = await get("get_component").handler({ componentName: "BUTTON" });
    expect(r.isError).toBeFalsy();
    expect(r.content[0]!.text).toMatch(/^# Button/);
  });

  it("renders enum cases with their associated value labels", async () => {
    // `.bottom`만 노출하면 offset을 넘길 수 있다는 사실을 알 수 없다.
    const snackBar = await get("get_component").handler({ componentName: "SnackBar" });
    expect(snackBar.content[0]!.text).toMatch(/`\.bottom\(offset:\)`/);
    expect(snackBar.content[0]!.text).toMatch(/`\.top\(offset:\)`/);

    const popup = await get("get_component").handler({ componentName: "Popup" });
    expect(popup.content[0]!.text).toMatch(/`\.fixed\(_:\)`/);
    // associated value가 없는 case는 이름 그대로 유지된다.
    expect(popup.content[0]!.text).toMatch(/`\.hug`/);
  });

  it("keeps bare case names for enums without associated values", async () => {
    const r = await get("get_component").handler({ componentName: "Button" });
    const text = r.content[0]!.text;
    expect(text).toMatch(/`\.solid`/);
    expect(text).not.toMatch(/`\.solid\(/);
  });

  it("renders initializers of nested types", async () => {
    const r = await get("get_component").handler({ componentName: "ActionArea" });
    const text = r.content[0]!.text;
    expect(text).toMatch(/ActionArea\.ButtonInfo\.init\(text:action:\)/);
  });

  it("returns error for unknown component", async () => {
    const r = await get("get_component").handler({ componentName: "Nope" });
    expect(r.isError).toBe(true);
  });
});

describe("list_tokens", () => {
  it("includes all five token kinds", async () => {
    const r = await get("list_tokens").handler({});
    const text = r.content[0]!.text;
    expect(text).toMatch(/## Color/);
    expect(text).toMatch(/## Typography/);
    expect(text).toMatch(/## Spacing/);
    expect(text).toMatch(/## Shadow/);
    expect(text).toMatch(/## Opacity/);
  });
});

describe("get_color_usage", () => {
  it("returns the color guide markdown", async () => {
    const r = await get("get_color_usage").handler({});
    expect(r.content[0]!.text.length).toBeGreaterThan(500);
  });
});

describe("list_icons", () => {
  it("returns full list when no query", async () => {
    const r = await get("list_icons").handler({});
    expect(r.content[0]!.text).toMatch(/Total in catalog/);
  });

  it("filters by query (case-insensitive)", async () => {
    const r = await get("list_icons").handler({ query: "arrow", limit: 50 });
    const text = r.content[0]!.text;
    expect(text).toMatch(/Filter\*?\*?:\s*`arrow`/);
    expect(text.toLowerCase()).toMatch(/arrow/);
  });
});
