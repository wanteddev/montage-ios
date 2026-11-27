// Figma 아이콘 sync 결과 → SwiftUI Code Connect 아이콘 batch(figma/swiftui/icons.figma.batch.json)
//
// figma-icon-sync 워크플로의 sync job(montage-web 재사용 워크플로)이 output/result.json에
// 아이콘마다 { id: 컴포넌트 세트 노드 ID('40167-141864'), name: SVG 파일명('agentColor') }를 남긴다.
// icon_sync.js가 이 파일로 batch를 다시 만들어, 아이콘이 추가·삭제되면 batch도 같은 커밋에 반영된다.
//
// 출력 규칙(montage-web scripts/figma-icon.mjs와 같은 구조)
// - 노드(url) 하나에 아이콘 variant 여러 개가 묶일 수 있다(예: arrowDown, arrowDownThick).
// - 같은 아이콘이 노드 두 곳에 있으면 노드마다 항목을 둔다(예: blankColor).
// - variant name은 Figma Name variant 값이라 'Color' 접미사를 뗀다. component는 'Icon' + 파스칼 케이스.
// - 순서는 이름 → 노드 ID 순으로 정렬해 result.json 순서와 무관하게 같은 결과가 나오게 한다.
//
// montage-web과 다른 점: 웹은 중복 노드를 노드 ID로만 걸러, 아이콘 X가 노드 A·B에 있고 B에 다른 아이콘도 있으면
// B의 X를 빠뜨린다(그 인스턴스는 템플릿 fallback으로 다른 아이콘 스니펫이 나온다). 여기서는 (노드 ID, 이름) 쌍을
// 모두 넣는다. 웹 로직으로 되돌리지 않는다.

const BATCH_PATH = 'figma/swiftui/icons.figma.batch.json';
const NODE_ID_PATTERN = /^\d+-\d+$/;

const componentName = (name) => `Icon${name.charAt(0).toUpperCase()}${name.slice(1)}`;

const compare = (a, b) => (a < b ? -1 : a > b ? 1 : 0);

/**
 * @param {Array<{ id: string; name: string }>} entries output/result.json 항목
 * @returns {string} icons.figma.batch.json 내용(끝 줄바꿈 포함)
 */
const buildIconBatch = (entries) => {
  if (!Array.isArray(entries) || entries.length === 0) {
    throw new Error('result.json에 아이콘 항목이 없습니다.');
  }

  const seen = new Set();
  const unique = [];
  for (const entry of entries) {
    const { id, name } = entry ?? {};
    if (typeof name !== 'string' || !/^[a-z][A-Za-z0-9]*$/.test(name)) {
      throw new Error(`아이콘 이름 형식이 아닙니다: ${JSON.stringify(entry)}`);
    }
    if (typeof id !== 'string' || !NODE_ID_PATTERN.test(id)) {
      throw new Error(`노드 ID 형식이 아닙니다: ${JSON.stringify(entry)}`);
    }
    const key = `${id} ${name}`;
    if (!seen.has(key)) {
      seen.add(key);
      unique.push({ id, name });
    }
  }

  unique.sort((a, b) => compare(a.name, b.name) || compare(a.id, b.id));

  const variantsByUrl = new Map();
  for (const { id, name } of unique) {
    const url = `<FIGMA_ICONS_BASE>?node-id=${id}`;
    const variants = variantsByUrl.get(url) ?? [];
    variants.push({ name: name.replace(/Color$/, ''), component: componentName(name) });
    variantsByUrl.set(url, variants);
  }

  const batch = [
    {
      templateFile: './icons.figma.batch.ts',
      components: [...variantsByUrl].map(([url, variants]) => ({
        url,
        component: variants[0].component,
        variants,
      })),
    },
  ];

  return `${JSON.stringify(batch, null, 2)}\n`;
};

/** batch에 들어간 아이콘 이름(= SVG 파일명 = Icon enum case) 목록 */
const iconNamesInBatch = (batchJson) => {
  const names = new Set();
  for (const group of JSON.parse(batchJson)) {
    for (const component of group.components) {
      for (const { component: c } of component.variants) {
        const n = c.replace(/^Icon/, '');
        names.add(n.charAt(0).toLowerCase() + n.slice(1));
      }
    }
  }
  return [...names].sort(compare);
};

/** 두 이름 목록이 다르면 차이를 담아 throw */
const assertSameNames = (expected, actual, expectedLabel, actualLabel) => {
  const a = new Set(expected);
  const b = new Set(actual);
  const onlyExpected = [...a].filter((n) => !b.has(n)).sort(compare);
  const onlyActual = [...b].filter((n) => !a.has(n)).sort(compare);
  if (onlyExpected.length || onlyActual.length) {
    throw new Error(
      [
        `${expectedLabel}와 ${actualLabel}의 아이콘 이름이 다릅니다.`,
        `${expectedLabel}에만 있음: ${onlyExpected.join(', ') || '(없음)'}`,
        `${actualLabel}에만 있음: ${onlyActual.join(', ') || '(없음)'}`,
      ].join('\n'),
    );
  }
};

module.exports = { BATCH_PATH, buildIconBatch, iconNamesInBatch, assertSameNames };
