const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const jsonCache = new Map();

function readJsonCached(filePath) {
  if (jsonCache.has(filePath)) {
    return jsonCache.get(filePath);
  }
  const parsed = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
  jsonCache.set(filePath, parsed);
  return parsed;
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
      desc = ref.abstract.map((a) => a.text || '').join(' ');
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
            const returnsSection = symbolJson.primaryContentSections.find(
              s => s.kind === 'content' && Array.isArray(s.content) && s.content.some(c => c.type === 'heading' && c.text === 'Return Value')
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
  let md = '';
  for (const aside of content) {
    if (aside.type === 'aside' && aside.style === 'note') {
      const name = aside.name || 'Note';
      const rendered = renderInlineContent(aside.content, references, {
        blockQuote: true,
        joinWith: '\n',
      });
      if (rendered.replace(/>\s*[,]*\s*$/g, '').trim()) {
        md += `>  **${name}**\n>\n`;
        md += rendered.replace(/>\s*[,]*\s*$/g, '').trim() + '\n\n';
      }
    }
  }
  return md;
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
    fm += `description: ${json.abstract.map((a) => a.text).join(' ')}\n`;
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
    md += `> **Deprecation**\n>\n>`;
    md += json.deprecationSummary
      .map((s) => s.inlineContent.map((v) => v.text).join('\n> '))
      .join('\n> ');
    md += '\n\n';
  }

  // Overview/예시/기타
  md += renderContentSections(json.primaryContentSections, json.references);

  // Topics (topicSections)
  const hasAssociatedExtensions = Boolean(associatedExtensions && associatedExtensions.trim());

  if (json.topicSections) {
    md += '## Topics\n\n';
    json.topicSections.forEach((sec, index) => {
      md += renderTopicSection(sec, json.references, 0, mdPath);
      if (json.topicSections.length > 0 && index < json.topicSections.length - 1) {
        md += '___\n';
      }
    });
  }
  if (hasAssociatedExtensions) {
    if (json.topicSections && json.topicSections.length > 0) {
      md += '___\n';
    }
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
    console.log(`✓ 변환 완료: ${mdPath}`);
  } catch (error) {
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

  let desc = Array.isArray(ref.abstract) ? ref.abstract.map((a) => a.text || '').join(' ') : '';
  let symbolDetails = '';

  const symbolUrl = ref.url ? ref.url.replace(/^\//, '') : '';
  if (symbolUrl) {
    const symbolJsonPath = path.join(dataRoot, `${symbolUrl}.json`);
    if (fs.existsSync(symbolJsonPath)) {
      try {
        const symbolJson = readJsonCached(symbolJsonPath);

        if (!desc && Array.isArray(symbolJson.abstract)) {
          desc = symbolJson.abstract.map((a) => a.text || '').join(' ');
        }

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

const montageSrcRoot = path.join(__dirname, 'Sources/Montage');
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

// documentation 폴더 정리
const documentationDir = path.join(__dirname, 'documentation');
if (fs.existsSync(documentationDir)) {
  console.log('🗑️  기존 documentation 폴더 삭제 중...');
  fs.rmSync(documentationDir, { recursive: true, force: true });
  console.log('✓ 삭제 완료\n');
}

console.log('📂 Swift 타입-파일 매핑 시작...');
walkSwiftFiles(montageSrcRoot);
console.log(`✓ Swift 타입-파일 매핑 완료 (${Object.keys(swiftFileMap).length}개 타입)\n`);

const dataRoot = path.join('.build/derived_data/Build/Products/Dev-iphoneos/Montage.doccarchive/data');
const doccRoot = path.join(dataRoot, 'documentation');

console.log('🔎 Extended Module 인덱싱 시작...');
collectExtendedModuleMarkdown(dataRoot);
console.log(`✓ 인덱싱 완료 (확장 심볼 ${Object.keys(extensionMdMap).length}개)\n`);

console.log('🔄 JSON → Markdown 변환 시작...');
walk(doccRoot);

Object.values(convertedSwiftFileMap).forEach((item) => {
  if (!item.isConverted) {
    console.warn(`⚠️ md 파일로 변환되지 않은 Swift 타입: ${item.componentTitle}`);
    if (componentExtensionHashIndex[item.componentTitle]) {
      console.log(renderAssociatedExtensionsSection(item.componentTitle));
    }
  }
});

console.log('\n' + '='.repeat(50));
console.log('✅ 모든 변환 작업 완료!');
console.log('='.repeat(50));