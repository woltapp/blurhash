import { defineConfig } from "tsup";

export default defineConfig([
  {
    name: "main",
    entry: ["./src/index.ts"],
    outDir: "./dist",
    format: ["cjs", "esm"],
    legacyOutput: true,
    sourcemap: true,
    clean: true,
    splitting: false,
    dts: false,
  },
  {
    name: "typedefs",
    entry: ["./src/index.ts"],
    outDir: "./dist",
    clean: false,
    dts: {
      only: true,
    },
  },
]);
