// Code Connect 아이콘 batch 생성(icon_code_connect_batch.js)과 icon_sync.js 연동 테스트
//
// - 커밋된 batch가 생성기가 내는 정규화된 형태인지(순서·name/component 정합성. 노드 ID 값 자체는 확인하지 못한다)
// - batch 아이콘 이름이 Icon enum case와 1:1인지
// - icon_sync.js가 가짜 레포에서 batch를 쓰고, result.json이 어긋나면 아무것도 바꾸지 않는지
//
// CI에서는 돌지 않는다. 레포 루트에서 `npm test`로 실행한다.

const test = require('node:test');
const { after } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const { BATCH_PATH, buildIconBatch, iconNamesInBatch } = require('../icon_code_connect_batch');

const REPO_ROOT = path.resolve(__dirname, '../..');
const ICON_SWIFT_REL = 'Sources/Montage/1 Components/9 Utilities/Icon.swift';

const readCommittedBatch = () => fs.readFileSync(path.join(REPO_ROOT, BATCH_PATH), 'utf8');

/** batch → result.json 항목(노드 ID, SVG 파일명)으로 되돌린다 */
const entriesFromBatch = (batchJson) =>
  JSON.parse(batchJson).flatMap((group) =>
    group.components.flatMap(({ url, variants }) =>
      variants.map(({ component }) => {
        const n = component.replace(/^Icon/, '');
        return { id: url.split('node-id=')[1], name: n.charAt(0).toLowerCase() + n.slice(1) };
      })
    )
  );

const iconEnumCases = (swift) => {
  const body = swift.match(/public enum Icon: String, CaseIterable\s*\{\s*\n([\s\S]*?)\n\}/)[1];
  return body
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line.startsWith('case '))
    .map((line) => line.slice('case '.length));
};

test('커밋된 batch가 생성기 출력 형태와 같다', () => {
  const committed = readCommittedBatch();
  assert.equal(buildIconBatch(entriesFromBatch(committed)), committed);
});

test('batch 아이콘 이름이 Icon enum case와 1:1이다', () => {
  const cases = iconEnumCases(fs.readFileSync(path.join(REPO_ROOT, ICON_SWIFT_REL), 'utf8'));
  assert.deepEqual(iconNamesInBatch(readCommittedBatch()), [...cases].sort());
});

test('노드별로 묶고, 입력 순서와 무관하게 같은 결과를 낸다', () => {
  const entries = [
    { id: '8-731', name: 'blankColor' },
    { id: '6362-15083', name: 'arrowDownThick' },
    { id: '40167-141716', name: 'blankColor' },
    { id: '6362-15083', name: 'arrowDown' },
    { id: '6362-15083', name: 'arrowDown' },
  ];
  const out = buildIconBatch(entries);
  assert.equal(buildIconBatch([...entries].reverse()), out);
  assert.deepEqual(JSON.parse(out)[0].components, [
    {
      url: '<FIGMA_ICONS_BASE>?node-id=6362-15083',
      component: 'IconArrowDown',
      variants: [
        { name: 'arrowDown', component: 'IconArrowDown' },
        { name: 'arrowDownThick', component: 'IconArrowDownThick' },
      ],
    },
    {
      url: '<FIGMA_ICONS_BASE>?node-id=40167-141716',
      component: 'IconBlankColor',
      variants: [{ name: 'blank', component: 'IconBlankColor' }],
    },
    {
      url: '<FIGMA_ICONS_BASE>?node-id=8-731',
      component: 'IconBlankColor',
      variants: [{ name: 'blank', component: 'IconBlankColor' }],
    },
  ]);
});

test('형식이 잘못된 항목은 거부한다', () => {
  assert.throws(() => buildIconBatch([]));
  assert.throws(() => buildIconBatch([{ id: '1:2', name: 'heart' }]));
  assert.throws(() => buildIconBatch([{ id: '1-2', name: 'Heart' }]));
});

// --- icon_sync.js 연동 ---

const ICON_SWIFT_FIXTURE = `import SwiftUI

public enum Icon: String, CaseIterable {
    case heart
}
`;

const fakeRepos = [];
after(() => fakeRepos.forEach((root) => fs.rmSync(root, { recursive: true, force: true })));

const makeFakeRepo = ({ svgs, result }) => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'icon-sync-'));
  fakeRepos.push(root);
  fs.mkdirSync(path.join(root, 'scripts'));
  for (const file of ['icon_sync.js', 'icon_code_connect_batch.js']) {
    fs.copyFileSync(path.join(REPO_ROOT, 'scripts', file), path.join(root, 'scripts', file));
  }
  fs.mkdirSync(path.join(root, 'Sources/Montage/Asset/Icon.xcassets/heart.imageset'), { recursive: true });
  fs.mkdirSync(path.dirname(path.join(root, ICON_SWIFT_REL)), { recursive: true });
  fs.writeFileSync(path.join(root, ICON_SWIFT_REL), ICON_SWIFT_FIXTURE);
  fs.mkdirSync(path.join(root, 'figma/swiftui'), { recursive: true });
  fs.writeFileSync(path.join(root, BATCH_PATH), 'OLD\n');
  fs.mkdirSync(path.join(root, 'output'));
  for (const name of svgs) {
    fs.writeFileSync(path.join(root, 'output', `${name}.svg`), '<svg width="24" height="24"></svg>');
  }
  if (result) {
    fs.writeFileSync(path.join(root, 'output/result.json'), JSON.stringify(result));
  }
  return root;
};

const runIconSync = (root) =>
  spawnSync(process.execPath, ['scripts/icon_sync.js'], { cwd: root, encoding: 'utf8' });

test('icon_sync.js가 에셋·enum과 함께 batch를 갱신한다', () => {
  const root = makeFakeRepo({
    svgs: ['heart', 'agentColor'],
    result: [
      { id: '1-2', name: 'heart', description: '' },
      { id: '3-4', name: 'agentColor', description: '' },
    ],
  });
  const run = runIconSync(root);
  assert.equal(run.status, 0, run.stderr);

  assert.deepEqual(iconEnumCases(fs.readFileSync(path.join(root, ICON_SWIFT_REL), 'utf8')), ['agentColor', 'heart']);
  const batch = fs.readFileSync(path.join(root, BATCH_PATH), 'utf8');
  assert.deepEqual(iconNamesInBatch(batch), ['agentColor', 'heart']);
  assert.equal(JSON.parse(batch)[0].components[0].url, '<FIGMA_ICONS_BASE>?node-id=3-4');
});

test('result.json이 없거나 SVG와 어긋나면 아무 파일도 바꾸지 않고 실패한다', () => {
  const cases = [
    { label: 'result.json 없음', result: undefined, message: /result\.json가 없어/ },
    { label: 'SVG에만 있음', result: [{ id: '1-2', name: 'heart' }], message: /SVG에만 있음: agentColor/ },
    {
      label: 'result.json에만 있음',
      result: [
        { id: '1-2', name: 'heart' },
        { id: '3-4', name: 'agentColor' },
        { id: '5-6', name: 'bell' },
      ],
      message: /result\.json에만 있음: bell/,
    },
    {
      label: '노드 ID 형식 오류',
      result: [
        { id: '1:2', name: 'heart' },
        { id: '3-4', name: 'agentColor' },
      ],
      message: /노드 ID 형식이 아닙니다/,
    },
  ];
  for (const { label, result, message } of cases) {
    const root = makeFakeRepo({ svgs: ['heart', 'agentColor'], result });
    const run = runIconSync(root);
    assert.notEqual(run.status, 0, label);
    assert.match(run.stderr, message, label);
    assert.equal(fs.readFileSync(path.join(root, BATCH_PATH), 'utf8'), 'OLD\n', label);
    assert.equal(fs.readFileSync(path.join(root, ICON_SWIFT_REL), 'utf8'), ICON_SWIFT_FIXTURE, label);
    assert.ok(fs.existsSync(path.join(root, 'Sources/Montage/Asset/Icon.xcassets/heart.imageset')), label);
    assert.ok(fs.existsSync(path.join(root, 'output')), label);
  }
});
