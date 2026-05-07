/* eslint-disable no-console */
/**
 * Builds slim JSON indexes for `@wanteddev/montage-ios-mcp`.
 *
 * Inputs:
 *   - .build/derived_data/.../Montage.doccarchive/data/documentation/montage/
 *   - Sources/Montage/Asset/Icon.xcassets/
 *
 * Outputs (committed to git, npm-bundled):
 *   - packages/montage-mcp/data/components.json
 *   - packages/montage-mcp/data/tokens.json
 *   - packages/montage-mcp/data/icons.json
 *
 * Run via `make mcp-data` (also wired into `make all`).
 */

const fs = require('fs');
const path = require('path');

const REPO_ROOT = path.resolve(__dirname, '..');
const DOCC = path.join(
  REPO_ROOT,
  '.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data/documentation/montage',
);
const ICON_ASSETS = path.join(REPO_ROOT, 'Sources/Montage/Asset/Icon.xcassets');
const OUT_DIR = path.join(REPO_ROOT, 'packages/montage-mcp/data');

const CATEGORY_MAP = {
  actions: ['actionarea', 'button', 'chip', 'iconbutton', 'textbutton'],
  contents: [
    'accordion', 'avatar', 'avatargroup', 'card', 'contentbadge',
    'listcard', 'listcell', 'playbadge', 'sectionheader', 'thumbnail',
  ],
  feedback: ['fallbackview', 'pushbadge', 'snackbar', 'toast'],
  loading: ['loading', 'skeleton'],
  navigations: [
    'category', 'pagecounter', 'paginationdots',
    'progressindicator', 'progresstracker', 'tab', 'topnavigation',
  ],
  presentation: ['bottomsheet', 'popover', 'popup', 'tooltip'],
  'selection-input': [
    'checkbox', 'checkmark', 'filterbutton', 'framedstyle', 'radio',
    'segmentedcontrol', 'select', 'slider', 'switch', 'textarea', 'textfield',
  ],
  utilities: [
    'color', 'flowlayout', 'icon', 'interaction', 'modalnavigation',
    'opacity', 'pulltorefresh', 'scrollview', 'shadow', 'spacing', 'typography',
  ],
};

const TOKEN_NAMES = ['color', 'typography', 'spacing', 'shadow', 'opacity'];

const SKIP_NAMES = new Set([
  'corefoundation', 'foundation', 'swift', 'swiftui',
  'swiftuicore', 'uikit', 'contentbadgeuiview', 'interactionuiview',
]);

function categoryOf(slug) {
  for (const [cat, list] of Object.entries(CATEGORY_MAP)) {
    if (list.includes(slug)) return cat;
  }
  return 'uncategorized';
}

function readJson(p) {
  return JSON.parse(fs.readFileSync(p, 'utf-8'));
}

function abstractText(json) {
  if (!Array.isArray(json.abstract)) return '';
  return json.abstract.map((seg) => seg.text ?? '').join('').trim();
}

function fragmentSignature(fragments) {
  if (!Array.isArray(fragments)) return '';
  return fragments.map((f) => f.text ?? '').join('').trim();
}

/** Last path segment of a `doc://montage.Montage/.../X` identifier. */
function tail(identifier) {
  return identifier.split('/').pop() || identifier;
}

function findSection(json, titlePred) {
  const sections = Array.isArray(json.topicSections) ? json.topicSections : [];
  return sections.find((s) => titlePred(String(s.title || ''))) || null;
}

function extractInitializers(json) {
  const sec = findSection(json, (t) => t === 'Initializers');
  if (!sec) return [];
  return (sec.identifiers || []).map((id) => ({
    signature: tail(id),
    docId: id,
  }));
}

/** Strip the disambiguating hash that DocC appends to overloaded methods (e.g. "title(_:)-3g6lv" → "title(_:)"). */
function stripHash(slug) {
  return slug.replace(/-[0-9a-z]{4,}$/i, '');
}

/**
 * Read each member referenced by `sectionTitle` and return its signature/summary.
 * Used for both "Instance Methods" (fluent modifiers) and "Type Methods" (static factories).
 */
function extractMembers(json, componentDir, sectionTitle) {
  const sec = findSection(json, (t) => t === sectionTitle);
  if (!sec || !fs.existsSync(componentDir)) return [];
  const seen = new Set(); // dedupe overloads by stripped name
  const out = [];
  for (const id of sec.identifiers || []) {
    const fileSlug = tail(id);
    const memberPath = path.join(componentDir, `${fileSlug}.json`);
    if (!fs.existsSync(memberPath)) continue;
    let mj;
    try { mj = readJson(memberPath); } catch { continue; }
    const meta = mj.metadata || {};
    const sig = fragmentSignature(meta.fragments);
    if (!sig) continue;
    const baseName = stripHash(fileSlug);
    const summary = abstractText(mj);
    const dedupeKey = `${baseName}::${sig}`;
    if (seen.has(dedupeKey)) continue;
    seen.add(dedupeKey);
    out.push({
      name: baseName,
      signature: sig,
      summary,
      kind: meta.symbolKind || 'method',
    });
  }
  return out;
}

function extractNestedTypes(componentDir, componentName) {
  if (!fs.existsSync(componentDir)) return [];
  const entries = fs.readdirSync(componentDir, { withFileTypes: true });
  const types = [];
  for (const ent of entries) {
    if (!ent.isDirectory()) continue;
    const slug = ent.name;
    const typeJsonPath = path.join(componentDir, `${slug}.json`);
    if (!fs.existsSync(typeJsonPath)) continue;
    let typeJson;
    try {
      typeJson = readJson(typeJsonPath);
    } catch {
      continue;
    }
    const symbolKind = typeJson?.metadata?.symbolKind;
    if (!symbolKind) continue;
    const title = typeJson?.metadata?.title || slug;
    const record = {
      name: title,
      kind: symbolKind,
      summary: abstractText(typeJson),
    };
    if (symbolKind === 'enum') {
      const casesSec = findSection(typeJson, (t) => t === 'Enumeration Cases' || t === 'Cases');
      if (casesSec) {
        record.cases = (casesSec.identifiers || []).map((id) => {
          const t = tail(id);
          return t.replace(/\(.*\)$/, '');
        });
      }
    }
    // Static factories like `TopNavigation.LeadingButton.back(action:)` live as
    // "Type Methods" / "Type Properties" inside the nested-type subdir.
    const nestedDir = path.join(componentDir, slug);
    if (fs.existsSync(nestedDir)) {
      const staticMethods = extractMembers(typeJson, nestedDir, 'Type Methods');
      const staticProps = extractMembers(typeJson, nestedDir, 'Type Properties');
      const modifiers = extractMembers(typeJson, nestedDir, 'Instance Methods');
      if (staticMethods.length > 0) record.staticMethods = staticMethods;
      if (staticProps.length > 0) record.staticProperties = staticProps;
      if (modifiers.length > 0) record.modifiers = modifiers;
    }
    types.push(record);
  }
  return types;
}

function buildComponents() {
  if (!fs.existsSync(DOCC)) {
    console.error(`[mcp-data] doccarchive not found: ${DOCC}`);
    console.error('         Run `make docc` first.');
    process.exit(1);
  }
  const entries = fs.readdirSync(DOCC, { withFileTypes: true });
  const components = [];
  for (const ent of entries) {
    if (!ent.isFile() || !ent.name.endsWith('.json')) continue;
    const slug = ent.name.replace(/\.json$/, '');
    if (SKIP_NAMES.has(slug)) continue;
    if (TOKEN_NAMES.includes(slug)) continue; // tokens go to tokens.json
    const jsonPath = path.join(DOCC, ent.name);
    let json;
    try {
      json = readJson(jsonPath);
    } catch (err) {
      console.warn(`[mcp-data] skip ${slug}: ${err.message}`);
      continue;
    }
    const meta = json.metadata || {};
    if (meta.symbolKind !== 'struct' && meta.symbolKind !== 'class' && meta.symbolKind !== 'enum') {
      continue;
    }
    const compDir = path.join(DOCC, slug);
    components.push({
      slug,
      name: meta.title || slug,
      category: categoryOf(slug),
      kind: meta.symbolKind,
      declaration: fragmentSignature(meta.fragments),
      summary: abstractText(json),
      initializers: extractInitializers(json),
      modifiers: extractMembers(json, compDir, 'Instance Methods'),
      staticMembers: extractMembers(json, compDir, 'Type Methods'),
      nestedTypes: extractNestedTypes(compDir, meta.title || slug),
    });
  }
  components.sort((a, b) => a.name.localeCompare(b.name));
  return components;
}

function buildTokens() {
  const tokens = {};
  for (const slug of TOKEN_NAMES) {
    const jsonPath = path.join(DOCC, `${slug}.json`);
    if (!fs.existsSync(jsonPath)) {
      tokens[slug] = null;
      continue;
    }
    const json = readJson(jsonPath);
    const meta = json.metadata || {};
    const sections = Array.isArray(json.topicSections) ? json.topicSections : [];
    tokens[slug] = {
      name: meta.title || slug,
      kind: meta.symbolKind || 'struct',
      summary: abstractText(json),
      sections: sections.map((s) => ({
        title: s.title || '',
        anchor: s.anchor || '',
        identifiers: (s.identifiers || []).map(tail),
      })),
      nestedTypes: extractNestedTypes(path.join(DOCC, slug), meta.title || slug),
    };
  }
  return tokens;
}

function buildIcons() {
  if (!fs.existsSync(ICON_ASSETS)) {
    console.warn(`[mcp-data] icon assets not found: ${ICON_ASSETS}`);
    return { count: 0, icons: [] };
  }
  const entries = fs.readdirSync(ICON_ASSETS, { withFileTypes: true });
  const icons = entries
    .filter((e) => e.isDirectory() && e.name.endsWith('.imageset'))
    .map((e) => e.name.replace(/\.imageset$/, ''))
    .sort((a, b) => a.localeCompare(b));
  return { count: icons.length, icons };
}

function copyMarkdownSources() {
  // Markdown sources need to be bundled with the npm package, so we mirror them
  // into packages/montage-mcp/data/markdown/. The hand-curated `coding-guidelines.md`
  // lives there directly and is not overwritten.
  const mdOutDir = path.join(OUT_DIR, 'markdown');
  if (!fs.existsSync(mdOutDir)) fs.mkdirSync(mdOutDir, { recursive: true });

  const copies = [
    {
      from: path.join(REPO_ROOT, 'GETTINGSTARTED.md'),
      to: path.join(mdOutDir, 'getting-started.md'),
    },
    {
      from: path.join(REPO_ROOT, 'documentation/utilities/ios-utility-components/color.md'),
      to: path.join(mdOutDir, 'color-usage.md'),
    },
  ];
  for (const { from, to } of copies) {
    if (!fs.existsSync(from)) {
      console.warn(`[mcp-data] markdown source missing: ${from}`);
      continue;
    }
    fs.copyFileSync(from, to);
    console.log(`[mcp-data] copied ${path.relative(REPO_ROOT, from)} → ${path.relative(REPO_ROOT, to)}`);
  }
}

function ensureFigmaMapping() {
  const target = path.join(OUT_DIR, 'figma-mapping.json');
  if (fs.existsSync(target)) return;
  const seed = {
    version: 1,
    description:
      'Manual Figma component/token → Montage Swift mapping. Convention-based matching is the fallback; entries here override.',
    components: {},
    tokens: { color: {}, typography: {}, spacing: {}, shadow: {}, opacity: {} },
  };
  fs.writeFileSync(target, JSON.stringify(seed, null, 2) + '\n');
  console.log('[mcp-data] seeded figma-mapping.json');
}

function writeJson(name, data) {
  const out = path.join(OUT_DIR, name);
  const payload = {
    schema: 1,
    ...data,
  };
  fs.writeFileSync(out, JSON.stringify(payload, null, 2) + '\n');
  console.log(`[mcp-data] wrote ${path.relative(REPO_ROOT, out)} (${JSON.stringify(payload).length} bytes)`);
}

function main() {
  if (!fs.existsSync(OUT_DIR)) {
    fs.mkdirSync(OUT_DIR, { recursive: true });
  }
  const components = buildComponents();
  const tokens = buildTokens();
  const icons = buildIcons();

  writeJson('components.json', { components });
  writeJson('tokens.json', { tokens });
  writeJson('icons.json', icons);
  copyMarkdownSources();
  ensureFigmaMapping();

  console.log(
    `[mcp-data] done — components: ${components.length}, icons: ${icons.count}`,
  );
}

main();
