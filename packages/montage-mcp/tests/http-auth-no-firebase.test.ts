import { describe, it, expect, vi } from "vitest";

// Simulates an install that omitted optional dependencies.
vi.mock("firebase-admin/app", () => {
  throw new Error("Cannot find package 'firebase-admin'");
});

import { createGoogleAuth, loadAuthConfig } from "../src/http-auth.js";

describe("createGoogleAuth without firebase-admin", () => {
  it("fails with an explicit message", async () => {
    const cfg = loadAuthConfig({
      MONTAGE_MCP_AUTH: "google",
      GOOGLE_CLIENT_ID: "id",
      GOOGLE_CLIENT_SECRET: "secret",
      FIREBASE_API_KEY: "key",
      FIREBASE_PROJECT_ID: "project",
      FIREBASE_CLIENT_EMAIL: "svc@project.iam.gserviceaccount.com",
      FIREBASE_PRIVATE_KEY: "pem",
      MONTAGE_MCP_PUBLIC_URL: "https://mcp.example.com",
    } as NodeJS.ProcessEnv)!;
    await expect(createGoogleAuth(cfg)).rejects.toThrow(/optional dependency "firebase-admin"/);
  });
});
