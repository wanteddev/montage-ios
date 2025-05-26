const fs = require('fs');
const path = require('path');

// 링크 생성 함수
function makeLink(title, url, deprecated = false) {
  let link = `[${title}](${url})`;
  if (deprecated) link = `~~${link}~~\n\n`;
  return link;
}

// 토픽 섹션 변환
function renderTopicSection(section, references, depth = 0) {
  if (section.title === 'Classes') {
    // 클래스 표시 안함
    return '';
  }
  let md = `###${'#'.repeat(depth)} ${section.title}\n\n`;
  for (const id of section.identifiers || []) {
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
      const symbolJsonPath = path.join('.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data', `${url}.json`);
      md += `<details>\n`;
      try {
        if (fs.existsSync(symbolJsonPath)) {
          const symbolJson = JSON.parse(fs.readFileSync(symbolJsonPath, 'utf-8'));

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
              symbolDetails += renderTopicSection(sec, symbolJson.references, depth + 1);
            }
          }
        }
      } catch (error) {
        console.error(`Error reading symbol details for ${url}:`, error);
      }

      const member = `\`\`${(ref.fragments || []).map((f) => f.text).join('') || title}\`\``;
      md += `\n<summary>${deprecated ? `~~${member}~~` : `${member}`}</summary>\n`;
      if (desc) md += `\n${desc}\n`;
      if (symbolDetails) md += symbolDetails;
      md += '</details>\n';
    } else {
      const urlPathLastComponent = url.split('/').at(-1);
      if (urlPathLastComponent.startsWith('UI')) {
        // UIKit 관련 문서 제외
        return;
      }
      md += `\n${makeLink(title, `/docs/utilities/ios/${urlPathLastComponent}`, deprecated)}\n`;
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
function jsonToMarkdown(json, isUtil = false) {
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
  if (json.topicSections) {
    md += '## Topics\n\n';
    json.topicSections.forEach((sec, index, array) => {
      md += renderTopicSection(sec, json.references);
      // 마지막 섹션이 아닐 경우에만 구분선 추가
      if (index < array.length - 1) {
        md += '___\n';
      }
    });
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
  const json = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));

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
  if (json.metadata && json.metadata.title && swiftFileMap[json.metadata.title]) {
    // Swift 파일 구조와 동일하게 저장
    const swiftFilePath = swiftFileMap[json.metadata.title].replace(/[0-9] /g, '').toLowerCase();
    if (swiftFilePath.includes('utilities')) {
      if (swiftFilePath.includes('components')) {
        mdPath = path.join('documentation', swiftFilePath, 'ios', jsonFileName.replace(/\.json$/, '.md').toLowerCase());
      } else {
        mdPath = path.join('documentation', swiftFilePath.replace(/(utilities).*$/, '$1'), 'ios', jsonFileName.replace(/\.json$/, '.md').toLowerCase());
      }
    } else {
      mdPath = path.join('documentation', swiftFilePath, jsonFileName.replace(/\.json$/, '').toLowerCase(), 'ios.md');
    }
  } else {
    mdPath = path.join('documentation/utilities/ios/', jsonFileName.replace(/\.json$/, '.md'));
  }

  const md = jsonToMarkdown(json, mdPath.includes('utilities'));
  fs.mkdirSync(path.dirname(mdPath), { recursive: true });
  fs.writeFileSync(mdPath, md, 'utf-8');
}

// 재귀적으로 montage/ 하위 모든 json 변환
function walk(dir) {
  fs.readdirSync(dir).forEach((f) => {
    const full = path.join(dir, f);
    if (fs.statSync(full).isDirectory()) walk(full);
    else if (f.endsWith('.json')) convertFile(full);
  });
}

function walkSwiftFiles(dir, relBase = '') {
  fs.readdirSync(dir).forEach((file) => {
    const fullPath = path.join(dir, file);
    const relPath = path.join(relBase, file);
    if (fs.statSync(fullPath).isDirectory()) {
      walkSwiftFiles(fullPath, relPath);
    } else if (file.endsWith('.swift')) {
      swiftFileMap[file.replace(/\.swift$/, '')] = relBase; // ex: Button.swift: 3 Component/Button/
    }
  });
}

const montageSrcRoot = path.join(__dirname, 'Sources/Montage');
const swiftFileMap = {};

walkSwiftFiles(montageSrcRoot);

walk('.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data/documentation');
