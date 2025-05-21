const fs = require('fs');
const path = require('path');

// 링크 생성 함수
function makeLink(title, url, deprecated = false) {
  let link = `[${title}](${url})`;
  if (deprecated) link = `~${link}~\n\n- \`Deprecated\``;
  return link;
}

// 토픽 섹션 변환
function renderTopicSection(section, references) {
  let md = `### ${section.title}\n\n`;
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
    if (ref.role === 'symbol' && ref.kind === 'symbol') {
      // 함수/메서드/프로퍼티
      md += `- [${(ref.fragments || []).map((f) => f.text).join('') || title}](${url})\n`;
      if (desc) md += `  - ${desc}\n`;
    } else if (ref.kind === 'symbol' && ref.role === 'symbol') {
      // 클래스/열거형 등
      md += `- ${makeLink(title, url, deprecated)}\n`;
      if (desc) md += `  - ${desc}\n`;
    } else {
      md += `- ${makeLink(title, url, deprecated)}\n`;
      if (desc) md += `  - ${desc}\n`;
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
          md += `\`${ref.title}\``;
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
              return `[${ref.title}](${ref.url})`;
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
        md += `>  ${name}\n>\n`;
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
function renderFrontmatter(json) {
  let fm = `---\n`;
  if (json.metadata && json.metadata.title)
    fm += `title: ${json.metadata.title}\n`;
  if (json.abstract && Array.isArray(json.abstract)) {
    fm += `description: ${json.abstract.map((a) => a.text).join(' ')}\n`;
  }
  if (json.metadata && json.metadata.createdAt)
    fm += `createdAt: ${json.metadata.createdAt}\n`;
  fm += `---\n\n`;
  return fm;
}

// 메인 변환 함수
function jsonToMarkdown(json) {
  let md = renderFrontmatter(json);

  if (json.references) {
    const isDeprecated = json.references[json.identifier.url]
      ? json.references[json.identifier.url].deprecated
      : false;

    if (isDeprecated) {
      md += `\`deprecated\`\n\n`;
    }
  }

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
    for (const sec of json.topicSections) {
      md += renderTopicSection(sec, json.references);
    }
  }

  // Relationships
  if (json.relationshipsSections) {
    md += '## Relationships\n\n';
    md += renderRelationships(json.relationshipsSections, json.references);
  }

  return md;
}

let count = 0;

// 단일 파일 변환
function convertFile(jsonPath) {
  const relPath = path.relative('docc/data/documentation', jsonPath);
  const mdPath = path.join('documentation', relPath).replace(/\.json$/, '.md');
  const json = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));
  const md = jsonToMarkdown(json);
  fs.mkdirSync(path.dirname(mdPath), { recursive: true });
  fs.writeFileSync(mdPath, md, 'utf-8');
  count++;
}

// 재귀적으로 montage/ 하위 모든 json 변환
function walk(dir) {
  fs.readdirSync(dir).forEach((f) => {
    const full = path.join(dir, f);
    if (fs.statSync(full).isDirectory()) walk(full);
    else if (f.endsWith('.json')) convertFile(full);
  });
}

// 시작점
console.time('start');
walk('docc/data/documentation');
console.timeEnd('start');
console.log(`변환 완료: ${count}개의 파일`);

