#!/usr/bin/env node

/**
 * Third-party license extractor for Montage.
 *
 * Usage:
 *   node generate_third_party_licenses.mjs
 *
 * The script reads Package.resolved, fetches (or overrides) license texts,
 * and rewrites THIRD_PARTY_LICENSES.md with a consistent table + sections.
 */

import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, ".");
const packageResolvedPath = path.join(projectRoot, "Package.resolved");
const outputPath = path.join(projectRoot, "THIRD_PARTY_LICENSES.md");
const overridesPath = path.join(__dirname, "license-overrides.json");

function readJSON(file) {
  return JSON.parse(fs.readFileSync(file, "utf8"));
}

function loadOverrides() {
  if (!fs.existsSync(overridesPath)) {
    return {};
  }
  const raw = readJSON(overridesPath);
  const overrides = {};
  for (const [identity, config] of Object.entries(raw)) {
    const entry = { ...config };
    if (entry.textFile) {
      const licensePath = path.resolve(__dirname, entry.textFile);
      entry.licenseText = fs.readFileSync(licensePath, "utf8").trim();
    }
    if (entry.noticeFile) {
      const noticePath = path.resolve(__dirname, entry.noticeFile);
      entry.noticeText = fs.readFileSync(noticePath, "utf8").trim();
    }
    overrides[identity] = entry;
  }
  return overrides;
}

function ensurePackageResolvedExists() {
  if (!fs.existsSync(packageResolvedPath)) {
    console.error(`Package.resolved not found at ${packageResolvedPath}`);
    process.exit(1);
  }
}

function versionLabel(state) {
  if (state.version) return state.version;
  if (state.branch && state.revision) {
    return `${state.branch}@${state.revision.slice(0, 7)}`;
  }
  if (state.revision) return state.revision.slice(0, 7);
  return "unknown";
}

function detectLicenseName(text, options = {}) {
  const { sourceUrl } = options;

  const inferFromSource = () => {
    if (!sourceUrl) return null;
    const lowerSource = sourceUrl.toLowerCase();
    if (lowerSource.includes("/mit")) {
      return "MIT License";
    }
    if (lowerSource.includes("apache-2.0")) {
      return "Apache License 2.0";
    }
    return null;
  };

  if (!text) {
    return inferFromSource() ?? "Unknown";
  }

  const normalized = text.replace(/\r\n?/g, "\n").trim();
  const collapsed = normalized.replace(/\s+/g, " ").toLowerCase();

  const mappings = [
    { keyword: "Apache License", name: "Apache License 2.0" },
    { keyword: "SIL OPEN FONT LICENSE", name: "SIL Open Font License 1.1" },
    { keyword: "BSD 3-Clause", name: "BSD 3-Clause License" },
    { keyword: "BSD 2-Clause", name: "BSD 2-Clause License" }
  ];

  const upper = normalized.toUpperCase();
  for (const mapping of mappings) {
    if (upper.includes(mapping.keyword.toUpperCase())) {
      return mapping.name;
    }
  }

  const hasMitHeader = /^\s*mit\s+license\b/i.test(normalized) || collapsed.includes("the mit license");
  const hasPermissionSentence = collapsed.includes("permission is hereby granted, free of charge");
  const hasSpdxToken = /\bspdx(-license)?-identifier\s*:\s*mit\b/i.test(normalized) || /\blicense\s*:\s*mit\b/i.test(normalized);

  if (hasMitHeader || hasPermissionSentence || hasSpdxToken) {
    return "MIT License";
  }

  return inferFromSource() ?? "Unknown";
}

const obligationHints = {
  "Apache License 2.0": "NOTICE/저작권 유지 + 특허 종료 조항",
  "MIT License": "저작권 및 허가 문구 유지",
  "SIL Open Font License 1.1": "Reserved Font Name 유지, OFL 전문 포함"
};

function toRawGitHub(url, ref, fileName) {
  try {
    const parsed = new URL(url);
    if (parsed.hostname !== "github.com") return null;
    const segments = parsed.pathname.replace(/\.git$/, "").split("/").filter(Boolean);
    if (segments.length < 2) return null;
    const [owner, repo] = segments;
    return `https://raw.githubusercontent.com/${owner}/${repo}/${ref}/${fileName}`;
  } catch {
    return null;
  }
}

function buildRefCandidates(state) {
  const base = state.version ?? state.revision ?? state.branch ?? "main";
  const refs = new Set();
  const enqueue = (value) => {
    if (value && !refs.has(value)) {
      refs.add(value);
    }
  };
  enqueue(base);
  if (base && base.startsWith("v")) {
    enqueue(base.slice(1));
  } else if (base) {
    enqueue(`v${base}`);
  }
  for (const value of Array.from(refs)) {
    if (!value.startsWith("refs/")) {
      enqueue(`refs/tags/${value}`);
    }
  }
  return Array.from(refs);
}

async function tryFetch(url) {
  if (globalThis.fetch) {
    try {
      const response = await fetch(url);
      if (response.ok) {
        return await response.text();
      }
    } catch {
      // swallow error and fall back to curl
    }
  }
  const result = spawnSync("curl", ["-Lks", url], { encoding: "utf8" });
  if (result.status === 0) {
    return result.stdout;
  }
  return null;
}

async function fetchLicenseFromGitHub(pin) {
  const { location, state, identity } = pin;
  const refs = buildRefCandidates(state);
  const candidates = ["LICENSE", "LICENSE.md", "LICENSE.txt", "COPYING", "COPYING.md"];
  for (const ref of refs) {
    for (const candidate of candidates) {
      const rawUrl = toRawGitHub(location, ref, candidate);
      if (!rawUrl) continue;
      const content = await tryFetch(rawUrl);
      if (content && !/^404: Not Found$/i.test(content.trim())) {
        return { text: content.trim(), source: rawUrl };
      }
    }
  }
  console.warn(`⚠️  Failed to fetch license for ${identity}.`);
  return { text: "", source: null };
}

async function fetchNoticeFromGitHub(pin) {
  const { location, state } = pin;
  const refs = buildRefCandidates(state);
  const candidates = ["NOTICE", "NOTICE.txt", "NOTICE.md"];
  for (const ref of refs) {
    for (const candidate of candidates) {
      const rawUrl = toRawGitHub(location, ref, candidate);
      if (!rawUrl) continue;
      const content = await tryFetch(rawUrl);
      if (content && !/^404: Not Found$/i.test(content.trim())) {
        return { text: content.trim(), source: rawUrl };
      }
    }
  }
  return { text: "", source: null };
}

async function buildEntry(pin, overrides) {
  const identity = pin.identity;
  const version = versionLabel(pin.state);
  const base = {
    name: identity,
    url: pin.location,
    versionLabel: version
  };

  if (overrides[identity]) {
    const override = overrides[identity];
    return {
      ...base,
      licenseName: override.license ?? "Custom",
      obligation: override.obligation ?? obligationHints[override.license] ?? "라이선스 전문 참조",
      licenseText: override.licenseText ?? override.text ?? "",
      noticeText: override.noticeText ?? "",
      source: override.source ?? "manual override"
    };
  }

  const licenseResult = await fetchLicenseFromGitHub(pin);
  const noticeResult = await fetchNoticeFromGitHub(pin);
  const licenseName = detectLicenseName(licenseResult.text, {
    sourceUrl: licenseResult.source ?? pin.location
  });
  return {
    ...base,
    licenseName,
    obligation: obligationHints[licenseName] ?? "라이선스 전문 참조",
    licenseText: licenseResult.text || "라이선스를 가져오지 못했습니다. 수동 확인이 필요합니다.",
    noticeText: noticeResult.text,
    source: licenseResult.source ?? pin.location
  };
}

async function main() {
  ensurePackageResolvedExists();
  const resolved = readJSON(packageResolvedPath);
  const overrides = loadOverrides();
  const pins = (resolved.pins ?? []).sort((a, b) => a.identity.localeCompare(b.identity));

  if (pins.length === 0) {
    console.error("No dependencies found in Package.resolved.");
    process.exit(1);
  }

  const entries = [];
  for (const pin of pins) {
    entries.push(await buildEntry(pin, overrides));
  }

  const tableRows = entries
    .map(
      (entry) =>
        `| ${entry.name} | ${entry.versionLabel} | ${entry.licenseName} | ${entry.obligation} |`
    )
    .join("\n");

  const sections = entries
    .map((entry) => {
      const metaLines = [
        `- 저장소: ${entry.url}`,
        `- 버전: ${entry.versionLabel}`,
        `- 소스: ${entry.source}`,
        `- 의무: ${entry.obligation}`
      ].join("\n");
      const noticeBlock = entry.noticeText
        ? `\n### NOTICE\n\n\`\`\`\n${entry.noticeText}\n\`\`\`\n`
        : "";
      const licenseBlock = `\n### 라이선스 전문\n\n\`\`\`\n${entry.licenseText}\n\`\`\`\n`;
      return `## ${entry.name} (${entry.licenseName})\n\n${metaLines}\n${noticeBlock}${licenseBlock}`;
    })
    .join("\n");

  const banner =
    "<!-- AUTO-GENERATED FILE. Run `node generate_third_party_licenses.mjs` to refresh. -->";
  const content = `${banner}
# Third-Party Notices

| 의존성 | 버전 | 라이선스 | 주요 의무 |
| --- | --- | --- | --- |
${tableRows}

${sections}
`;

  fs.writeFileSync(outputPath, content.trim() + "\n", "utf8");
  console.log(`✅ Generated ${path.relative(process.cwd(), outputPath)}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});

