import { defineConfig } from "tsdown";

export default defineConfig({
  entry: {
    stdio: "src/stdio.ts",
    http: "src/http.ts",
  },
  outDir: "dist",
  format: "esm",
  target: "node20",
  platform: "node",
  clean: true,
  shims: true,
  sourcemap: true,
  dts: false,
});
