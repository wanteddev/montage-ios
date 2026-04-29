import { describe, it, expect } from "vitest";
import { healthCheckTool } from "../src/core/tools/health-check.js";
import { loadConfig } from "../src/core/config.js";

describe("health_check", () => {
  it("returns ok status with name, version, and timestamp", async () => {
    const tool = healthCheckTool({ config: loadConfig({}) });
    const result = await tool.handler({});
    expect(result.isError).toBeFalsy();
    expect(result.content).toHaveLength(1);
    const body = JSON.parse(result.content[0]!.text);
    expect(body.status).toBe("ok");
    expect(body.name).toBe("@wanteddev/montage-ios-mcp");
    expect(body.version).toMatch(/^\d+\.\d+\.\d+/);
    expect(body.timestamp).toMatch(/^\d{4}-\d{2}-\d{2}T/);
  });
});
