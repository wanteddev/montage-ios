const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const repoRoot = path.resolve(__dirname, '..');

const jsonCache = new Map();

// 변환 결과 집계
//
// 변환기는 개별 파일의 실패를 로그로만 남기고 계속 진행하므로, 삭제한 documentation
// 폴더를 되살릴지 판단하려면 성공/실패 건수를 따로 들고 있어야 한다.
let conversionSuccessCount = 0;
const conversionFailures = [];

function readJsonCached(filePath) {
  if (jsonCache.has(filePath)) {
    return jsonCache.get(filePath);
  }
  const parsed = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
  jsonCache.set(filePath, parsed);
  return parsed;
}

function renderAbstractText(abstract) {
  if (!Array.isArray(abstract)) return '';
  return abstract.map((a) => {
    if (a.type === 'codeVoice' && a.code) return '`' + a.code + '`';
    return a.text || '';
  }).join('');
}

// 시그니쳐 해시 생성 함수
function generateHash(signature) {
  return crypto.createHash('md5').update(signature).digest('hex').substring(0, 8);
}

// 링크 생성 함수
function makeLink(title, url, deprecated = false) {
  let link = `[${title}](${url})`;
  if (deprecated) link = `~~${link}~~\n\n`;
  return link;
}

// deprecationSummary 블록 렌더링 함수
function renderDeprecationBlock(symbolJson) {
  if (!symbolJson.deprecationSummary) return '';
  const depText = renderInlineContent(symbolJson.deprecationSummary, symbolJson.references, { joinWith: '' });
  return `>  **Deprecated**\n>\n>  ${depText}\n\n`;
}

// 토픽 섹션 변환
function renderTopicSection(section, references, depth = 0, mdPath = '') {
  if (section.title === 'Classes' || section.title === 'Default Implementations') {
    // Classes, Default Implementations 섹션 표시 안함
    return '';
  }
  let md = `###${'#'.repeat(depth)} ${section.title}\n\n`;
  // 중복 제거를 위해 Set 사용
  const uniqueIdentifiers = [...new Set(section.identifiers || [])];
  for (const id of uniqueIdentifiers) {
    const ref = references ? references[id] : null;
    if (!ref) continue;
    let title = ref.title || '';
    let url = ref.url || '';
    let deprecated = Boolean(ref.deprecated);
    let desc = '';
    if (ref.abstract && Array.isArray(ref.abstract)) {
      desc = renderAbstractText(ref.abstract);
    }

    let symbolDetails = '';
    if (ref.title === 'UIKit') continue;
    if (ref.kind === 'symbol') {
      // 심볼의 상세 정보를 가져오기
      const symbolJsonPath = path.join(dataRoot, `${url}.json`);
      md += `<details>\n`;
      try {
        if (fs.existsSync(symbolJsonPath)) {
          const symbolJson = readJsonCached(symbolJsonPath);

          // deprecationSummary 처리
          symbolDetails += renderDeprecationBlock(symbolJson);

          if (symbolJson.primaryContentSections) {
            // 파라미터 정보 추가
            const parameters = symbolJson.primaryContentSections.find(s => s.kind === 'parameters');
            if (parameters) {
              symbolDetails += '\n- **Parameters**\n';
              symbolDetails += '  | Parameter | Description |\n';
              symbolDetails += '  | --- | --- |\n';
              parameters.parameters.forEach(param => {
                if (param.name && param.content) {
                  const paramText = renderInlineContent(param.content, symbolJson.references, { joinWith: '' });
                  symbolDetails += `  | \`${param.name}\` | ${paramText} |\n`;
                }
              });
            }

            // 리턴값 정보 추가
            const isInitializer =
              symbolJson.metadata && symbolJson.metadata.roleHeading === 'Initializer';
            if (!isInitializer) {
              const returnsSection = symbolJson.primaryContentSections.find(
                s =>
                  s.kind === 'content' &&
                  Array.isArray(s.content) &&
                  s.content.some(c => c.type === 'heading' && c.text === 'Return Value')
              );
              if (returnsSection && returnsSection.content) {
                symbolDetails += '- **Return Value**\n';
                let found = false;
                returnsSection.content.forEach(item => {
                  if (item.type === 'heading' && item.text === 'Return Value') {
                    found = true;
                    return;
                  }
                  if (found && item.type === 'paragraph' && item.inlineContent) {
                    const returnText = renderInlineContent([item], symbolJson.references, { joinWith: '' });
                    symbolDetails += `\n  ${returnText}\n`;
                  }
                });
              }
            }

            // Discussion 정보 추가
            const discussionSection = symbolJson.primaryContentSections.find(
              s => s.kind === 'content' && Array.isArray(s.content) && s.content.some(c => c.type === 'heading' && c.text === 'Discussion')
            );
            if (discussionSection && discussionSection.content) {
              symbolDetails += '- **Discussion**\n';
              let found = false;
              discussionSection.content.forEach(item => {
                if (item.type === 'heading' && item.text === 'Discussion') {
                  found = true;
                  return;
                }
                if (found) {
                  if (item.type === 'paragraph' && item.inlineContent) {
                    const discText = renderInlineContent([item], symbolJson.references, { joinWith: '' });
                    symbolDetails += `\n  ${discText}\n`;
                  } else if (item.type === 'codeListing' && item.code) {
                    // 코드 리스팅 처리 - 두 뎁스 들여쓰기
                    symbolDetails += '\n  ```swift\n';
                    item.code.forEach(line => {
                      symbolDetails += `  ${line}\n`;
                    });
                    symbolDetails += '  ```\n\n';
                  } else if (item.type === 'unorderedList' && item.items) {
                    // 리스트 처리 - 두 뎁스 들여쓰기
                    item.items.forEach((li) => {
                      const txt = renderInlineContent(li.content, symbolJson.references, { joinWith: '' });
                      symbolDetails += `  - ${txt}\n`;
                    });
                    symbolDetails += '\n';
                  } else if (item.type === 'aside' && item.content) {
                    // aside(노트 등) 처리 - 두 뎁스 들여쓰기
                    const asideMd = renderAside([item], symbolJson.references)
                      .split('\n')
                      .map(line => line ? `  ${line}` : '')
                      .join('\n');
                    symbolDetails += asideMd;
                  } else if (item.text) {
                    symbolDetails += `\n  ${item.text}\n`;
                  }
                }
              });
            }
          }
          if (symbolJson.topicSections) {
            for (const sec of symbolJson.topicSections) {
              symbolDetails += renderTopicSection(sec, symbolJson.references, depth + 1, mdPath);
            }
          }
        }
      } catch (error) {
        console.error(`✗ 심볼 상세 정보 읽기 실패 (${url}):`, error.message);
      }

      const member = `\`\`${(ref.fragments || []).map((f) => f.text).join('') || title}\`\``;
      md += `\n<summary>${deprecated ? `~~${member}~~` : `${member}`}</summary>\n\n`;
      if (desc) md += `\n${desc}\n`;
      if (symbolDetails) md += symbolDetails;
      md += '</details>\n';
    } else {
      const urlPathLastComponent = url.split('/').at(-1);
      if (urlPathLastComponent.startsWith('UI')) {
        // UIKit 관련 문서 제외
        return;
      }
      md += `\n${makeLink(title, `/docs/utilities/ios-utilities/${urlPathLastComponent}`, deprecated)}\n`;
      if (desc) md += `\n${desc}\n`;
    }
  }
  md += '\n';
  return md;
}

// Relationships 변환
function renderRelationships(sections, references) {
  let md = '';
  for (const sec of sections) {
    if (sec.kind === 'relationships' && sec.title === 'Conforms To') {
      md += 'Conforms To\n\n';
      for (const id of sec.identifiers) {
        const ref = references ? references[id] : null;
        if (ref) {
          md += `\`${ref.title}\`\n\n`;
        }
      }
      md += '\n\n';
    }
  }
  return md;
}

// content(배열) 렌더링 공통 함수
function renderInlineContent(content, references, options = {}) {
  // options: { blockQuote: true/false, joinWith: '\n' or '\n\n' }
  if (!content) return '';
  let lines = content.map((c) => {
    if (c.inlineContent) {
      return c.inlineContent
        .map((ic) => {
          if (ic.type === 'codeVoice' && ic.code) {
            return '`' + ic.code + '`';
          }
          if (ic.type === 'reference' && ic.identifier) {
            const ref = references ? references[ic.identifier] : null;
            if (ref) {
              return `[${ref.title}](${ref.url}.md)`;
            }
          }
          return ic.text || '';
        })
        .join('');
    }
    if (c.text) return c.text;
    return '';
  });
  if (options.blockQuote) {
    lines = lines
      .join('\n')
      .split('\n')
      .map((line) => '> ' + line);
  }
  return Array.isArray(lines) ? lines.join(options.joinWith || '\n') : lines;
}

function renderAside(content, references) {
  const ALLOWED_STYLES = ['note', 'warning', 'important', 'tip'];
  let md = '';
  for (const aside of content) {
    if (aside.type !== 'aside' || !ALLOWED_STYLES.includes(aside.style)) continue;
    const name =
      aside.name || aside.style[0].toUpperCase() + aside.style.slice(1);
    const lines = [];
    for (const block of aside.content || []) {
      if (block.type === 'paragraph') {
        const text = renderRichInline(block.inlineContent, references).trim();
        if (text) {
          lines.push(text);
          lines.push('');
        }
      } else if (block.type === 'codeListing' && Array.isArray(block.code)) {
        lines.push('```' + (block.syntax || ''));
        for (const ln of block.code) lines.push(ln);
        lines.push('```');
        lines.push('');
      }
    }
    while (lines.length && lines[lines.length - 1] === '') lines.pop();
    if (!lines.length) continue;
    md += `>  **${name}**\n>\n`;
    md +=
      lines.map((l) => (l === '' ? '>' : '> ' + l)).join('\n') + '\n\n';
  }
  return md;
}

function renderRichInline(inlineContent, references) {
  if (!inlineContent) return '';
  return inlineContent
    .map((ic) => {
      if (ic.type === 'text') return ic.text || '';
      if (ic.type === 'codeVoice') return '`' + (ic.code || '') + '`';
      if (ic.type === 'strong')
        return '**' + renderRichInline(ic.inlineContent, references) + '**';
      if (ic.type === 'emphasis')
        return '*' + renderRichInline(ic.inlineContent, references) + '*';
      if (ic.type === 'reference' && ic.identifier) {
        const ref = references ? references[ic.identifier] : null;
        return ref ? `[${ref.title}](${ref.url}.md)` : '';
      }
      return '';
    })
    .join('');
}

function renderContentSections(sections, references) {
  let md = '';
  for (const section of sections || []) {
    for (const item of section.content || []) {
      if (item.type === 'heading') {
        if (item.text === 'Overview') md += '## Overview\n\n';
        else md += `## ${item.text}\n\n`;
      }
      if (item.type === 'paragraph' && item.inlineContent) {
        md +=
          renderInlineContent([item], references, { joinWith: '\n\n' }) +
          '\n\n';
      }
      if (item.type === 'unorderedList' && item.items) {
        item.items.forEach((li) => {
          const txt = renderInlineContent(li.content, references, {
            joinWith: '',
          });
          md += `- ${txt}\n`;
        });
        md += '\n';
      }
      if (item.type === 'codeListing') {
        md += '```swift\n' + item.code.join('\n') + '\n```\n\n';
      }
      if (item.type === 'aside') {
        md += renderAside([item], references);
      }
    }
  }
  return md;
}

// 메타데이터 → 프론트매터
function renderFrontmatter(json, isUtil = false) {
  let fm = `---\n`;
  if (json.metadata && json.metadata.title) {
    let title = json.metadata.title;
    // 카멜/파스칼 케이스를 센텐스 케이스로 변환
    if (title.length > 0 && !isUtil) {
      // 1. 단어 경계에 공백 추가 (카멜/파스칼 케이스 → 단어 분리)
      title = title
        .replace(/([a-z])([A-Z])/g, '$1 $2')
        .replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2')
        .trim();

      // 2. 각 단어별로 처리
      title = title
        .split(' ')
        .map((word, idx) => {
          // 2글자 이상 연속 대문자(약어)는 그대로, 나머지는 센텐스 케이스
          if (/^[A-Z]{2,}$/.test(word)) {
            return word;
          }
          // 첫 단어만 대문자, 나머지는 소문자
          if (idx === 0) {
            return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
          }
          return word.toLowerCase();
        })
        .join(' ');
    }
    fm += `title: ${title}\n`;
  }
  if (json.abstract && Array.isArray(json.abstract)) {
    fm += `description: ${renderAbstractText(json.abstract)}\n`;
  }
  if (json.metadata && json.metadata.createdAt)
    fm += `createdAt: ${json.metadata.createdAt}\n`;
  fm += `---\n\n`;
  return fm;
}

// 메인 변환 함수
function jsonToMarkdown(json, isUtil = false, mdPath = '', associatedExtensions = '') {
  let md = renderFrontmatter(json, isUtil);

  // 선언부
  if (json.primaryContentSections) {
    const decl = json.primaryContentSections.find(
      (s) => s.kind === 'declarations',
    );
    if (
      decl &&
      decl.declarations &&
      decl.declarations[0] &&
      decl.declarations[0].tokens
    ) {
      md +=
        '```swift\n' +
        decl.declarations[0].tokens.map((t) => t.text).join('') +
        '\n```\n\n';
    }
  }

  if (json.deprecationSummary) {
    md += renderDeprecationBlock(json);
  }

  // Overview/예시/기타
  md += renderContentSections(json.primaryContentSections, json.references);

  // Topics (topicSections)
  const hasAssociatedExtensions = Boolean(associatedExtensions && associatedExtensions.trim());

  if (json.topicSections) {
    md += '## Topics\n\n';
    json.topicSections.forEach((sec, index) => {
      md += renderTopicSection(sec, json.references, 0, mdPath);
    });
  }
  if (hasAssociatedExtensions) {
    md += associatedExtensions;
  }

  // Relationships
  if (json.relationshipsSections) {
    md += '## Relationships\n\n';
    md += renderRelationships(json.relationshipsSections, json.references);
  }

  return md;
}

// 단일 파일 변환
function convertFile(jsonPath) {
  try {
    const json = readJsonCached(jsonPath);

    if (json.metadata.roleHeading === 'Initializer' ||
      json.metadata.roleHeading === 'Instance Method' ||
      json.metadata.roleHeading === 'Instance Property' ||
      json.metadata.roleHeading === 'Type Method' ||
      json.metadata.roleHeading === 'Type Property' ||
      json.metadata.roleHeading === 'Operator' ||
      json.metadata.roleHeading === 'Class' ||
      json.metadata.roleHeading === 'Enumeration' && json.metadata.title.split('.').length > 1 ||
      json.metadata.roleHeading === 'Case' ||
      json.metadata.roleHeading === 'Extended Class' ||
      json.metadata.roleHeading === 'Extended Structure' ||
      json.metadata.roleHeading === 'Extended Enumeration' ||
      json.metadata.roleHeading === 'Extended Protocol' ||
      json.metadata.roleHeading === 'API Collection' ||
      json.metadata.roleHeading === 'Structure' && json.metadata.title.split('.').length > 1) {
      // Topic 섹션 항목들 별개 문서 생성 제외
      return;
    }

    // 심볼명(클래스/구조체/프로토콜 등)에서 Swift 파일명 추출
    const jsonFileName = jsonPath.split('/').at(-1);
    if (jsonFileName.startsWith('ui') || jsonFileName.endsWith('montage.json')) {
      // UIKit 관련 문서 제외
      return;
    }

    let mdPath;
    const swiftFileRelPath = json.metadata && json.metadata.title ? swiftFileMap[json.metadata.title] : undefined;
    const jsonFileBase = jsonFileName.replace(/\.json$/, '').toLowerCase();

    if (swiftFileRelPath) {
      const swiftFilePath = swiftFileRelPath.replace(/[0-9] /g, '').toLowerCase();

      if (swiftFilePath.includes('utilities')) {
        mdPath = path.join('documentation', swiftFilePath.replace(/components\/(utilities).*$/, '$1'), 'ios-utility-components', `${jsonFileBase}.md`);
      } else {
        mdPath = path.join('documentation', swiftFilePath, jsonFileBase, 'ios.md');
      }
    } else if (json.metadata && json.metadata.roleHeading === 'Extended Module') {
      mdPath = path.join('documentation/utilities/ios-extensions/', `${jsonFileBase}.md`);
    } else {
      mdPath = path.join('documentation/utilities/ios-utilities/', `${jsonFileBase}.md`);
    }

    let associatedExtensions = '';
    if (json && json.metadata && json.metadata.title) {
      associatedExtensions = renderAssociatedExtensionsSection(json.metadata.title);
    }
    const md = jsonToMarkdown(json, mdPath.includes('utilities'), mdPath, associatedExtensions);
    fs.mkdirSync(path.dirname(mdPath), { recursive: true });
    fs.writeFileSync(mdPath, md, 'utf-8');
    if (convertedSwiftFileMap[jsonFileBase] !== undefined) {
      convertedSwiftFileMap[jsonFileBase].isConverted = true;
    }
    conversionSuccessCount += 1;
    console.log(`✓ 변환 완료: ${mdPath}`);
  } catch (error) {
    conversionFailures.push({ jsonPath, message: error.message });
    console.error(`✗ 변환 실패: ${jsonPath}`, error.message);
  }
}

// 재귀적으로 montage/ 하위 모든 json 변환
function walk(dir) {
  fs.readdirSync(dir).forEach((f) => {
    const full = path.join(dir, f);
    if (fs.statSync(full).isDirectory()) walk(full);
    else if (f.endsWith('.json')) convertFile(full);
  });
}

function findMatchingParen(str, startIndex) {
  let depth = 0;
  for (let i = startIndex; i < str.length; i++) {
    const ch = str[i];
    if (ch === '(') {
      depth++;
    } else if (ch === ')') {
      depth--;
      if (depth === 0) return i;
    }
  }
  return -1;
}

function stripParameterDefaults(signature) {
  const start = signature.indexOf('(');
  if (start === -1) return signature;
  const end = findMatchingParen(signature, start);
  if (end === -1) return signature;

  const paramsSegment = signature.slice(start + 1, end);

  const cleanedParams = cleanParameterList(paramsSegment);

  return signature.slice(0, start + 1) + cleanedParams + signature.slice(end);
}

function cleanParameterList(params) {
  const segments = [];
  let current = '';
  let depth = 0;
  for (let i = 0; i < params.length; i++) {
    const ch = params[i];
    if (ch === '(') {
      depth++;
    } else if (ch === ')') {
      depth--;
    }

    if (ch === ',' && depth === 0) {
      if (current.trim()) segments.push(current.trim());
      current = '';
      continue;
    }

    current += ch;
  }

  if (current.trim()) segments.push(current.trim());

  const cleaned = segments
    .map((segment) => {
      let depth = 0;
      let cutIndex = -1;
      for (let i = 0; i < segment.length; i++) {
        const ch = segment[i];
        if (ch === '(') depth++;
        else if (ch === ')') depth--;
        else if (ch === '=' && depth === 0) {
          cutIndex = i;
          break;
        }
      }
      if (cutIndex !== -1) {
        segment = segment.slice(0, cutIndex).trim();
      }
      return segment.replace(/\s+/g, ' ').trim();
    })
    .filter(Boolean);

  return cleaned.join(', ');
}

function canonicalizeSignature(signature) {
  let normalized = signature
    .replace(/\s+/g, ' ')
    .replace(/\(\s+/g, '(')
    .replace(/\s+\)/g, ')')
    .replace(/\s*,\s*/g, ', ')
    .replace(/\s*:\s*/g, ': ')
    .replace(/\s*->\s*/g, ' -> ')
    .replace(/\s+where\s+/g, ' where ');

  // 파라미터 속성 제거 (예: @escaping, @ViewBuilder 등)
  normalized = normalized.replace(/@\w+\s+/g, '');

  if (signature.includes('func')) {
    // 제네릭 제약 제거 (<T: Foo, U: Bar> -> <T, U>)
    normalized = normalized.replace(/<([^>]+)>/g, (_, contents) => {
      const cleaned = contents
        .split(',')
        .map((part) => part.trim().replace(/([A-Za-z0-9_]+)\s*:\s*[^,]+/, '$1'))
        .join(', ');
      return `<${cleaned}>`;
    });


    // 외부/내부 파라미터명 정리
    normalized = normalized
      // 외부 라벨 + 내부 이름이 있는 경우 내부 이름 제거
      .replace(/([A-Za-z0-9_]+)\s+[A-Za-z0-9_]+\s*:/g, '$1:')
      // 외부 라벨이 _ 인 경우 라벨 자체 제거
      .replace(/_\s*:\s*/g, '');

    // 파라미터 기본값 제거
    normalized = stripParameterDefaults(normalized);
  }

  // 불필요한 공백 정리
  normalized = normalized
    .replace(/,\s+\)/g, ')')
    .replace(/\s*,\s*/g, ', ')
    .replace(/\(\s+/g, '(')
    .replace(/\s+\)/g, ')')
    .replace(/\s{2,}/g, ' ')
    .replace(/\s+,/g, ',')
    .replace(/:\s+/g, ': ')
    .replace(/\(\s+/g, '(')
    .replace(/\s+\)/g, ')');

  return normalized.trim();
}

function recordComponentExtensionSignature(componentTitle, extendedType, kind, signatureBody) {
  const canonical = canonicalizeSignature(`${kind} ${signatureBody}`);
  const hash = generateHash(canonical);
  if (!componentExtensionHashIndex[componentTitle]) {
    componentExtensionHashIndex[componentTitle] = [];
  }
  const alreadyExists = componentExtensionHashIndex[componentTitle].some((entry) => entry.hash === hash);
  if (!alreadyExists) {
    componentExtensionHashIndex[componentTitle].push({ hash, extendedType, signature: canonical });
  }
}

function extractExtensionBodies(content) {
  const bodies = [];
  const extRegex = /extension\s+(?:[A-Za-z0-9_]+\.)?([A-Za-z0-9_]+)\s*\{/g;
  let match;
  while ((match = extRegex.exec(content)) !== null) {
    const typeName = match[1];
    let braceDepth = 1;
    let idx = extRegex.lastIndex;
    while (idx < content.length && braceDepth > 0) {
      const char = content[idx];
      if (char === '{') braceDepth++;
      else if (char === '}') braceDepth--;
      idx++;
    }
    const body = content.slice(extRegex.lastIndex, idx - 1);
    bodies.push({ typeName, body });
    extRegex.lastIndex = idx;
  }
  return bodies;
}

function collectComponentExtensionHashes(componentTitle, content) {
  const extensions = extractExtensionBodies(content);
  extensions.forEach(({ typeName, body }) => {
    const funcRegex = /public\s+(?:(static|class|mutating|nonmutating)\s+)?func\s+([^\{]+)/g;
    let result;
    while ((result = funcRegex.exec(body)) !== null) {
      const modifier = (result[1] || '').trim();
      const signatureBody = (result[2] || '').trim().replace(/\s+$/g, '');
      const kind = modifier ? `${modifier} func` : 'func';
      recordComponentExtensionSignature(componentTitle, typeName, kind, signatureBody);
    }

    const varRegex = /public\s+(?:(static|class)\s+)?var\s+([^=\{]+)/g;
    while ((result = varRegex.exec(body)) !== null) {
      const modifier = (result[1] || '').trim();
      const signatureBody = (result[2] || '').trim().replace(/\s+$/g, '');
      const kind = modifier ? `${modifier} var` : 'var';
      recordComponentExtensionSignature(componentTitle, typeName, kind, signatureBody);
    }
  });
}

function isExtensionMemberReference(ref) {
  if (!ref || ref.kind !== 'symbol') return false;
  const fragments = ref.fragments || [];
  return fragments.some(
    (fragment) => fragment.kind === 'keyword' && ['func', 'var', 'subscript'].includes(fragment.text),
  );
}

function renderExtensionMemberMarkdown(ref, dataRoot, mdPath = 'documentation/utilities/ios-extensions') {
  if (!ref) return null;

  const signatureRaw = (ref.fragments || []).map((f) => f.text).join('') || ref.title || '';
  const canonicalSignature = canonicalizeSignature(signatureRaw);
  const hash = generateHash(canonicalSignature);

  let desc = renderAbstractText(ref.abstract);
  let symbolDetails = '';

  const symbolUrl = ref.url ? ref.url.replace(/^\//, '') : '';
  if (symbolUrl) {
    const symbolJsonPath = path.join(dataRoot, `${symbolUrl}.json`);
    if (fs.existsSync(symbolJsonPath)) {
      try {
        const symbolJson = readJsonCached(symbolJsonPath);

        if (!desc && Array.isArray(symbolJson.abstract)) {
          desc = renderAbstractText(symbolJson.abstract);
        }

        // deprecationSummary 처리
        symbolDetails += renderDeprecationBlock(symbolJson);

        if (symbolJson.primaryContentSections) {
          const parameters = symbolJson.primaryContentSections.find((section) => section.kind === 'parameters');
          if (parameters && parameters.parameters && parameters.parameters.length > 0) {
            symbolDetails += '\n- **Parameters**\n';
            symbolDetails += '  | Parameter | Description |\n';
            symbolDetails += '  | --- | --- |\n';
            parameters.parameters.forEach((param) => {
              if (param.name && param.content) {
                const paramText = renderInlineContent(param.content, symbolJson.references, { joinWith: '' });
                symbolDetails += `  | \`${param.name}\` | ${paramText} |\n`;
              }
            });
          }

          const isInitializer =
            symbolJson.metadata && symbolJson.metadata.roleHeading === 'Initializer';
          if (!isInitializer) {
            const returnsSection = symbolJson.primaryContentSections.find(
              (section) =>
                section.kind === 'content' &&
                Array.isArray(section.content) &&
                section.content.some((item) => item.type === 'heading' && item.text === 'Return Value'),
            );
            if (returnsSection && returnsSection.content) {
              symbolDetails += '- **Return Value**\n';
              let foundHeading = false;
              returnsSection.content.forEach((item) => {
                if (item.type === 'heading' && item.text === 'Return Value') {
                  foundHeading = true;
                  return;
                }
                if (foundHeading) {
                  if (item.type === 'paragraph' && item.inlineContent) {
                    const returnText = renderInlineContent([item], symbolJson.references, { joinWith: '' });
                    symbolDetails += `\n  ${returnText}\n`;
                  }
                }
              });
            }
          }

          const discussionSection = symbolJson.primaryContentSections.find(
            (section) =>
              section.kind === 'content' &&
              Array.isArray(section.content) &&
              section.content.some((item) => item.type === 'heading' && item.text === 'Discussion'),
          );
          if (discussionSection && discussionSection.content) {
            symbolDetails += '- **Discussion**\n';
            let inDiscussion = false;
            discussionSection.content.forEach((item) => {
              if (item.type === 'heading' && item.text === 'Discussion') {
                inDiscussion = true;
                return;
              }
              if (inDiscussion) {
                if (item.type === 'paragraph' && item.inlineContent) {
                  const discText = renderInlineContent([item], symbolJson.references, { joinWith: '' });
                  symbolDetails += `\n  ${discText}\n`;
                } else if (item.type === 'codeListing' && Array.isArray(item.code)) {
                  symbolDetails += '\n  ```swift\n';
                  item.code.forEach((line) => {
                    symbolDetails += `  ${line}\n`;
                  });
                  symbolDetails += '  ```\n\n';
                } else if (item.type === 'unorderedList' && item.items) {
                  item.items.forEach((listItem) => {
                    const text = renderInlineContent(listItem.content, symbolJson.references, { joinWith: '' });
                    symbolDetails += `  - ${text}\n`;
                  });
                  symbolDetails += '\n';
                } else if (item.type === 'aside' && item.content) {
                  const asideMd = renderAside([item], symbolJson.references)
                    .split('\n')
                    .map((line) => (line ? `  ${line}` : ''))
                    .join('\n');
                  symbolDetails += asideMd;
                } else if (item.text) {
                  symbolDetails += `\n  ${item.text}\n`;
                }
              }
            });
          }
        }

        if (symbolJson.topicSections) {
          symbolJson.topicSections.forEach((section) => {
            symbolDetails += renderTopicSection(section, symbolJson.references, 1, mdPath);
          });
        }
      } catch (error) {
        console.error(`✗ 확장 심볼 JSON 파싱 실패 (${symbolJsonPath}):`, error.message);
      }
    }
  }

  const member = `\`\`${signatureRaw}\`\``;
  let md = '<details>\n';
  md += `\n<summary>${member}</summary>\n\n`;

  if (desc) {
    md += `\n${desc}\n`;
  }

  if (symbolDetails) {
    md += symbolDetails;
  }

  md += '</details>\n\n';

  return { hash, markdown: md };
}

function collectExtensionMembersFromJson(json, dataRoot, visitedPaths) {
  if (!json || !json.topicSections) return;

  (json.topicSections || []).forEach((section) => {
    (section.identifiers || []).forEach((identifier) => {
      const ref = json.references ? json.references[identifier] : null;
      if (!ref) return;

      if (isExtensionMemberReference(ref)) {
        const rendered = renderExtensionMemberMarkdown(ref, dataRoot);
        if (rendered && rendered.hash && !extensionMdMap[rendered.hash]) {
          extensionMdMap[rendered.hash] = rendered.markdown;
        }
      }

      const refUrl = ref.url;
      if (!refUrl) return;

      const normalized = refUrl.replace(/^\//, '');
      const childJsonPath = path.join(dataRoot, `${normalized}.json`);
      if (!fs.existsSync(childJsonPath) || visitedPaths.has(childJsonPath)) return;

      try {
        const childJson = readJsonCached(childJsonPath);
        visitedPaths.add(childJsonPath);
        collectExtensionMembersFromJson(childJson, dataRoot, visitedPaths);
      } catch (error) {
        console.error(`✗ 확장 심볼 JSON 파싱 실패 (${childJsonPath}):`, error.message);
      }
    });
  });
}

function collectExtendedModuleMarkdown(dataRoot) {
  const doccRoot = path.join(dataRoot, 'documentation');
  const visitedPaths = new Set();

  function traverse(dir) {
    fs.readdirSync(dir).forEach((name) => {
      const fullPath = path.join(dir, name);
      try {
        if (fs.statSync(fullPath).isDirectory()) {
          traverse(fullPath);
        } else if (name.endsWith('.json')) {
          const json = readJsonCached(fullPath);
          if (json && json.metadata && json.metadata.roleHeading === 'Extended Module') {
            visitedPaths.add(fullPath);
            collectExtensionMembersFromJson(json, dataRoot, visitedPaths);
          }
        }
      } catch (error) {
        console.error(`✗ Extended Module JSON 처리 실패 (${fullPath}):`, error.message);
      }
    });
  }

  if (fs.existsSync(doccRoot)) {
    traverse(doccRoot);
  }
}

function renderAssociatedExtensionsSection(title) {
  if (!title) return '';
  const entries = componentExtensionHashIndex[title];
  if (!entries || entries.length === 0) return '';

  const grouped = new Map();
  entries.forEach(({ hash, extendedType, signature }) => {
    if (!grouped.has(extendedType)) grouped.set(extendedType, new Set());
    grouped.get(extendedType).add({ hash, signature });
  });

  const sections = [];
  grouped.forEach((hashes, extendedType) => {
    const items = [];
    hashes.forEach(({ hash, signature }) => {
      const markdown = extensionMdMap[hash];
      if (markdown) items.push(markdown);
      else console.warn(`⚠ extension 심볼 MarkDown 누락: ${hash}, ${signature}`);
    });
    if (items.length > 0) {
      const detailMarkdown = `<details>\n\n<summary>\`\`extension ${extendedType}\`\`</summary>\n\n${items.join('')}\n</details>\n\n`;
      sections.push(detailMarkdown);
    }
  });

  if (sections.length === 0) return '';

  const section = `### Associated Extensions\n\n${sections.join('\n')}`;
  return section;
}

function walkSwiftFiles(dir, relBase = '') {
  fs.readdirSync(dir).forEach((file) => {
    const fullPath = path.join(dir, file);
    const relPath = path.join(relBase, file);
    if (fs.statSync(fullPath).isDirectory()) {
      walkSwiftFiles(fullPath, relPath);
    } else if (file.endsWith('.swift')) {
      // 파일명 기반 매핑 (기존 로직 유지)
      const componentTitle = file.replace(/\.swift$/, '');
      swiftFileMap[componentTitle] = relBase;
      if (relPath.includes('1 Components')) {
        convertedSwiftFileMap[componentTitle.toLowerCase()] = { componentTitle, isConverted: false };
      }

      // Swift 파일 내부의 public 타입명 추출
      try {
        const content = fs.readFileSync(fullPath, 'utf-8');
        // public enum, struct, class, protocol, actor 등을 찾음
        const typeRegex = /public\s+(enum|struct|class|protocol|actor)\s+(\w+)/g;
        let match;
        while ((match = typeRegex.exec(content)) !== null) {
          const typeName = match[2];
          swiftFileMap[typeName] = relBase;
        }

        if (/\b1 Components\b/.test(relBase)) {
          collectComponentExtensionHashes(componentTitle, content);
        }
      } catch (error) {
        console.error(`✗ Swift 파일 읽기 실패 (${fullPath}):`, error.message);
      }
    }
  });
}

const montageSrcRoot = path.join(repoRoot, 'Sources/Montage');
// Swift Type Name -> Swift File Path
const swiftFileMap = {};
// Swift File Path -> Converted
const convertedSwiftFileMap = {};
// 컴포넌트명 -> [{ hash, extendedType, signature }]
const componentExtensionHashIndex = {};
// 함수/프로퍼티 해시 -> 확장 심볼 MarkDown
const extensionMdMap = {};


console.log('='.repeat(50));
console.log('📚 DocC → Markdown 변환 시작');
console.log('='.repeat(50));

const dataRoot = path.join(
  repoRoot,
  '.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data'
);
const doccRoot = path.join(dataRoot, 'documentation');

// DocC 아카이브 검증
//
// 기존 documentation 폴더를 지우기 전에 반드시 확인한다.
// xcodebuild docbuild가 실패하면 아카이브가 없거나 비어 있는데, 그 상태로 삭제를
// 진행하면 문서를 복구하지 못한 채 삭제만 남는다.
//
// "폴더가 비어 있지 않다"만 보는 것으로는 부족하다. 빌드가 중간에 끊기면 디렉터리
// 껍데기만 남거나 JSON이 잘린 채로 남는데, walk()는 .json만 골라 처리하면서 파싱
// 오류를 로그로만 남기고 계속 진행한다. 그래서 심볼 JSON을 실제로 하나라도 읽을 수
// 있는지까지 확인해야 삭제만 남는 상황을 막을 수 있다.
function inspectDoccArchive(dir) {
  let jsonCount = 0;
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
      const full = path.join(current, entry.name);
      if (entry.isDirectory()) {
        stack.push(full);
        continue;
      }
      if (!entry.name.endsWith('.json')) continue;

      jsonCount += 1;
      try {
        const parsed = JSON.parse(fs.readFileSync(full, 'utf-8'));
        if (parsed && parsed.metadata) {
          return { parsable: true, jsonCount };
        }
      } catch (error) {
        // 잘린 JSON은 넘기고 다른 파일로 검증을 계속한다
      }
    }
  }

  return { parsable: false, jsonCount };
}

const archive = inspectDoccArchive(doccRoot);
if (!fs.existsSync(doccRoot) || !archive.parsable) {
  console.error('❌ 사용할 수 있는 DocC 아카이브가 없습니다.');
  console.error(`   경로: ${doccRoot}`);
  if (!fs.existsSync(doccRoot)) {
    console.error('   원인: 아카이브 경로가 존재하지 않습니다.');
  } else if (archive.jsonCount === 0) {
    console.error('   원인: 아카이브에 심볼 JSON이 없습니다.');
  } else {
    console.error(`   원인: JSON ${archive.jsonCount}개를 모두 읽을 수 없습니다 (손상 또는 잘림).`);
  }
  console.error('   기존 documentation 폴더를 보존한 채 중단합니다.');
  console.error('   먼저 `make docc`를 실행해 아카이브를 생성하세요.');
  process.exit(1);
}

// documentation 폴더 정리
//
// 삭제가 아니라 .build 아래로 옮겨 둔다. 변환이 실패하거나 결과물이 없으면
// 그대로 되돌려서, 아카이브가 불완전할 때 문서만 사라지는 일이 없게 한다.
const documentationDir = path.join(repoRoot, 'documentation');
const backupDir = path.join(repoRoot, '.build/documentation-backup');
let previousMarkdownCount = 0;
let backedUp = false;

function countMarkdownFiles(dir) {
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

function abortAndRestore(reason, details = []) {
  console.error('\n' + '='.repeat(50));
  console.error(`❌ ${reason}`);
  details.forEach((line) => console.error(`   ${line}`));

  // 중단 시점까지 만들어진 문서는 반쪽이므로 언제나 걷어낸다. 이걸 남겨 두면
  // 백업이 없는 첫 실행에서 부분 결과가 그대로 커밋될 수 있다.
  fs.rmSync(documentationDir, { recursive: true, force: true });
  if (backedUp) {
    fs.renameSync(backupDir, documentationDir);
    console.error('   기존 documentation 폴더를 복원했습니다.');
  } else {
    console.error('   생성 중이던 documentation 폴더를 삭제했습니다.');
  }

  console.error('='.repeat(50));
  process.exit(1);
}

if (fs.existsSync(documentationDir)) {
  console.log('🗂️  기존 documentation 폴더 임시 보관 중...');
  previousMarkdownCount = countMarkdownFiles(documentationDir);
  fs.rmSync(backupDir, { recursive: true, force: true });
  fs.mkdirSync(path.dirname(backupDir), { recursive: true });
  fs.renameSync(documentationDir, backupDir);
  backedUp = true;
  console.log(`✓ 보관 완료 (md ${previousMarkdownCount}개)\n`);
}

try {
  console.log('📂 Swift 타입-파일 매핑 시작...');
  walkSwiftFiles(montageSrcRoot);
  console.log(`✓ Swift 타입-파일 매핑 완료 (${Object.keys(swiftFileMap).length}개 타입)\n`);

  console.log('🔎 Extended Module 인덱싱 시작...');
  collectExtendedModuleMarkdown(dataRoot);
  console.log(`✓ 인덱싱 완료 (확장 심볼 ${Object.keys(extensionMdMap).length}개)\n`);

  console.log('🔄 JSON → Markdown 변환 시작...');
  walk(doccRoot);
} catch (error) {
  abortAndRestore('변환 중 오류가 발생해 중단했습니다.', [error.message]);
}

if (conversionFailures.length > 0) {
  abortAndRestore(
    `${conversionFailures.length}개 파일 변환에 실패했습니다.`,
    conversionFailures.slice(0, 10).map(({ jsonPath, message }) => `${jsonPath}: ${message}`)
  );
}

if (conversionSuccessCount === 0) {
  abortAndRestore('변환된 문서가 없습니다.', ['아카이브에 변환 대상 심볼이 없습니다.']);
}

// 문서 급감 감지
//
// 파싱 가능한 JSON이 있고 실패도 없더라도 아카이브가 반쪽일 수 있다. 이때는 삭제만
// 정상 완료된 것처럼 보이므로, 직전 문서 수 대비 절반 미만이면 중단한다.
// 컴포넌트를 실제로 대량 정리한 경우에는 MONTAGE_ALLOW_DOC_SHRINK=1로 통과시킨다.
const currentMarkdownCount = countMarkdownFiles(documentationDir);
if (
  previousMarkdownCount > 0 &&
  currentMarkdownCount * 2 < previousMarkdownCount &&
  process.env.MONTAGE_ALLOW_DOC_SHRINK !== '1'
) {
  abortAndRestore('생성된 문서 수가 직전보다 크게 줄었습니다.', [
    `이전: ${previousMarkdownCount}개 → 현재: ${currentMarkdownCount}개`,
    '아카이브가 불완전할 가능성이 높습니다. `make docc`를 다시 실행하세요.',
    '의도한 대량 삭제라면 MONTAGE_ALLOW_DOC_SHRINK=1 을 지정하세요.',
  ]);
}

if (backedUp) {
  fs.rmSync(backupDir, { recursive: true, force: true });
}

Object.values(convertedSwiftFileMap).forEach((item) => {
  if (!item.isConverted) {
    console.warn(`⚠️ md 파일로 변환되지 않은 Swift 타입: ${item.componentTitle}`);
    if (componentExtensionHashIndex[item.componentTitle]) {
      console.log(renderAssociatedExtensionsSection(item.componentTitle));
    }
  }
});

console.log('\n' + '='.repeat(50));
console.log(`✅ 모든 변환 작업 완료! (md ${currentMarkdownCount}개)`);
console.log('='.repeat(50));