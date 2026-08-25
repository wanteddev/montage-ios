// docc_to_md.js 통합 테스트
//
// 변환기는 top-level에서 즉시 실행되는 스크립트라 함수 단위로 불러올 수 없다.
// 그래서 임시 디렉터리에 가짜 레포(scripts/ + Sources/Montage/ + documentation/ +
// .doccarchive)를 만들고 스크립트를 서브프로세스로 돌려, 종료 코드와 documentation
// 폴더의 최종 상태를 확인한다.
//
// 실행: node --test scripts/tests/

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const SCRIPT_SOURCE = path.resolve(__dirname, '../docc_to_md.js');
const ARCHIVE_REL = '.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data/documentation';
const EXISTING_DOC_REL = 'documentation/components/feedback/toast/ios.md';
const EXISTING_DOC_BODY = '# 기존 문서\n';

// 변환에 성공하는 최소 심볼 JSON. Toast.swift 매핑을 타고
// documentation/components/feedback/toast/ios.md 로 나간다.
const VALID_SYMBOL_JSON = JSON.stringify({
  metadata: { title: 'Toast', roleHeading: 'Structure' },
  abstract: [{ type: 'text', text: '테스트용 심볼' }],
  identifier: { url: 'doc://Montage/documentation/Montage/Toast' },
  primaryContentSections: [],
  topicSections: [],
  references: {},
});

function writeFile(repoRoot, relPath, body) {
  const full = path.join(repoRoot, relPath);
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.writeFileSync(full, body, 'utf-8');
}

// 가짜 레포를 만든다. archiveFiles 가 비면 아카이브 디렉터리 자체를 만들지 않는다.
function makeRepo({ archiveFiles = {}, existingDocs = true } = {}) {
  const repoRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'docc-md-test-'));

  fs.mkdirSync(path.join(repoRoot, 'scripts'), { recursive: true });
  fs.copyFileSync(SCRIPT_SOURCE, path.join(repoRoot, 'scripts/docc_to_md.js'));

  writeFile(
    repoRoot,
    'Sources/Montage/1 Components/7 Feedback/Toast.swift',
    'public struct Toast {}\n'
  );

  if (existingDocs) {
    writeFile(repoRoot, EXISTING_DOC_REL, EXISTING_DOC_BODY);
  }

  for (const [name, body] of Object.entries(archiveFiles)) {
    writeFile(repoRoot, path.join(ARCHIVE_REL, 'montage', name), body);
  }

  return repoRoot;
}

function run(repoRoot, env = {}) {
  const result = spawnSync(process.execPath, ['scripts/docc_to_md.js'], {
    cwd: repoRoot,
    encoding: 'utf-8',
    env: { ...process.env, ...env },
  });
  return {
    status: result.status,
    output: `${result.stdout || ''}${result.stderr || ''}`,
  };
}

function countMarkdown(dir) {
  let count = 0;
  const stack = [dir];
  while (stack.length > 0) {
    const current = stack.pop();
    let entries;
    try {
      entries = fs.readdirSync(current, { withFileTypes: true });
    } catch (error) {
      continue;
    }
    for (const entry of entries) {
      if (entry.isDirectory()) stack.push(path.join(current, entry.name));
      else if (entry.name.endsWith('.md')) count += 1;
    }
  }
  return count;
}

// 기존 문서가 손대지 않은 그대로 남아 있는지 확인한다.
function assertDocsPreserved(repoRoot) {
  const docPath = path.join(repoRoot, EXISTING_DOC_REL);
  assert.ok(fs.existsSync(docPath), '기존 documentation 파일이 사라졌다');
  assert.equal(fs.readFileSync(docPath, 'utf-8'), EXISTING_DOC_BODY);
  assert.equal(countMarkdown(path.join(repoRoot, 'documentation')), 1);
  assert.equal(
    fs.existsSync(path.join(repoRoot, '.build/documentation-backup')),
    false,
    '백업 폴더가 남아 있다'
  );
}

const repos = [];
function trackRepo(repoRoot) {
  repos.push(repoRoot);
  return repoRoot;
}

test.after(() => {
  repos.forEach((repoRoot) => fs.rmSync(repoRoot, { recursive: true, force: true }));
});

test('아카이브 경로가 없으면 기존 문서를 보존하고 중단한다', () => {
  const repoRoot = trackRepo(makeRepo());
  const { status, output } = run(repoRoot);

  assert.equal(status, 1);
  assert.match(output, /사용할 수 있는 DocC 아카이브가 없습니다/);
  assert.match(output, /아카이브 경로가 존재하지 않습니다/);
  assertDocsPreserved(repoRoot);
});

test('아카이브에 심볼 JSON이 없으면 기존 문서를 보존하고 중단한다', () => {
  const repoRoot = trackRepo(makeRepo({ archiveFiles: { 'index.html': '<html></html>' } }));
  const { status, output } = run(repoRoot);

  assert.equal(status, 1);
  assert.match(output, /아카이브에 심볼 JSON이 없습니다/);
  assertDocsPreserved(repoRoot);
});

test('JSON이 전부 잘려 있으면 기존 문서를 보존하고 중단한다', () => {
  const repoRoot = trackRepo(makeRepo({
    archiveFiles: {
      'toast.json': '{"metadata": {"title": "Toa',
      'button.json': 'not json at all',
    },
  }));
  const { status, output } = run(repoRoot);

  assert.equal(status, 1);
  assert.match(output, /JSON 2개를 모두 읽을 수 없습니다/);
  assertDocsPreserved(repoRoot);
});

test('변환에 실패한 파일이 있으면 기존 문서를 복원하고 중단한다', () => {
  const repoRoot = trackRepo(makeRepo({
    archiveFiles: {
      'toast.json': VALID_SYMBOL_JSON,
      // title 이 없어 convertFile 내부에서 예외가 발생한다
      'bad.json': JSON.stringify({ metadata: { roleHeading: 'Structure' } }),
    },
  }));
  const { status, output } = run(repoRoot);

  assert.equal(status, 1);
  assert.match(output, /1개 파일 변환에 실패했습니다/);
  assertDocsPreserved(repoRoot);
});

test('문서 수가 절반 미만으로 줄면 기존 문서를 복원하고 중단한다', () => {
  const repoRoot = trackRepo(makeRepo({ archiveFiles: { 'toast.json': VALID_SYMBOL_JSON } }));
  // 기존 문서를 4개로 늘려 1개 생성 결과가 급감으로 걸리게 만든다
  ['a', 'b', 'c'].forEach((name) => {
    writeFile(repoRoot, `documentation/components/feedback/${name}/ios.md`, '# 기존 문서\n');
  });

  const { status, output } = run(repoRoot);

  assert.equal(status, 1);
  assert.match(output, /생성된 문서 수가 직전보다 크게 줄었습니다/);
  assert.match(output, /이전: 4개 → 현재: 1개/);
  assert.equal(countMarkdown(path.join(repoRoot, 'documentation')), 4);
  assert.equal(fs.existsSync(path.join(repoRoot, '.build/documentation-backup')), false);
});

test('MONTAGE_ALLOW_DOC_SHRINK=1 이면 급감을 허용한다', () => {
  const repoRoot = trackRepo(makeRepo({ archiveFiles: { 'toast.json': VALID_SYMBOL_JSON } }));
  ['a', 'b', 'c'].forEach((name) => {
    writeFile(repoRoot, `documentation/components/feedback/${name}/ios.md`, '# 기존 문서\n');
  });

  const { status, output } = run(repoRoot, { MONTAGE_ALLOW_DOC_SHRINK: '1' });

  assert.equal(status, 0);
  assert.match(output, /모든 변환 작업 완료/);
  assert.equal(countMarkdown(path.join(repoRoot, 'documentation')), 1);
});

test('정상 아카이브는 문서를 새로 생성하고 백업을 남기지 않는다', () => {
  const repoRoot = trackRepo(makeRepo({ archiveFiles: { 'toast.json': VALID_SYMBOL_JSON } }));
  const { status, output } = run(repoRoot);

  assert.equal(status, 0);
  assert.match(output, /모든 변환 작업 완료/);

  const docPath = path.join(repoRoot, EXISTING_DOC_REL);
  assert.ok(fs.existsSync(docPath));
  // 기존 내용이 변환 결과로 교체됐다
  assert.notEqual(fs.readFileSync(docPath, 'utf-8'), EXISTING_DOC_BODY);
  assert.equal(countMarkdown(path.join(repoRoot, 'documentation')), 1);
  assert.equal(fs.existsSync(path.join(repoRoot, '.build/documentation-backup')), false);
});

test('백업이 없는 상태에서 변환이 실패하면 부분 생성물을 남기지 않는다', () => {
  const repoRoot = trackRepo(makeRepo({
    archiveFiles: {
      'toast.json': VALID_SYMBOL_JSON,
      'bad.json': JSON.stringify({ metadata: { roleHeading: 'Structure' } }),
    },
    existingDocs: false,
  }));
  const { status, output } = run(repoRoot);

  assert.equal(status, 1);
  assert.match(output, /1개 파일 변환에 실패했습니다/);
  assert.match(output, /생성 중이던 documentation 폴더를 삭제했습니다/);
  // toast.json 은 변환에 성공했지만 그 결과물이 남아 있으면 안 된다
  assert.equal(countMarkdown(path.join(repoRoot, 'documentation')), 0);
  assert.equal(fs.existsSync(path.join(repoRoot, 'documentation')), false);
  assert.equal(fs.existsSync(path.join(repoRoot, '.build/documentation-backup')), false);
});

test('기존 documentation 폴더가 없어도 정상 변환한다', () => {
  const repoRoot = trackRepo(makeRepo({
    archiveFiles: { 'toast.json': VALID_SYMBOL_JSON },
    existingDocs: false,
  }));
  const { status } = run(repoRoot);

  assert.equal(status, 0);
  assert.equal(countMarkdown(path.join(repoRoot, 'documentation')), 1);
});
