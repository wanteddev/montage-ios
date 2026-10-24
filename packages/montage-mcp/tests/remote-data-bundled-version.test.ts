import { describe, it, expect, vi } from "vitest";

// A bundled copy whose version field is not a number (e.g. a hand-edited "1").
vi.mock("../src/core/data/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../src/core/data/index.js")>();
  return {
    ...actual,
    readBundledJson: (name: string) =>
      name === "components.json" ? { schema: "1", components: [] } : actual.readBundledJson(name as never),
  };
});

import { refreshRemoteData } from "../src/core/data/remote.js";

describe("remote data with a non-numeric bundled version", () => {
  it("refuses to replace the file", async () => {
    const stderr = vi.spyOn(process.stderr, "write").mockImplementation(() => true);
    const body = JSON.stringify({ schema: "1", components: [{ name: "X" }] });
    const fetchImpl = (async (input: string | URL | Request) =>
      String(input).endsWith("/components.json")
        ? new Response(body)
        : new Response("nope", { status: 404 })) as typeof fetch;
    const result = await refreshRemoteData("https://example.test/data", { fetchImpl });
    expect(result.failed).toContain("components.json");
    expect(stderr.mock.calls.map((c) => String(c[0])).join("")).toContain(
      'bundled components.json has no numeric schema ("1")',
    );
    stderr.mockRestore();
  });
});
