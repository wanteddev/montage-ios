const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');
const TurndownService = require('turndown');


async function extractAndConvertToMarkdown(baseUrl) {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  const visitedUrls = new Set();
  const queue = [baseUrl];

  try {
    console.log('사이트맵 생성 및 마크다운 변환 시작...');

    while (queue.length > 0) {
      const currentUrl = queue.shift();
      if (visitedUrls.has(currentUrl)) continue;
      console.log(`\n페이지 처리 중: ${currentUrl}`);
      visitedUrls.add(currentUrl);

      try {
        await page.goto(currentUrl, { waitUntil: 'networkidle', timeout: 60000 });

        const contentSelector = '.content';
        try {
          await page.waitForSelector(contentSelector, { timeout: 10000, state: 'attached' });
        } catch (error) {
          console.error(`페이지 로드 실패: ${currentUrl} - .content 요소를 찾을 수 없습니다.`);
          continue;
        }

        const urlObj = new URL(currentUrl);
        let urlPath = urlObj.pathname;
        if (urlPath.startsWith('/')) urlPath = urlPath.slice(1);
        if (urlPath.endsWith('/')) urlPath = urlPath.slice(0, -1);

        const savePath = path.join(`${urlPath}.md`); // urlPath는 이미 .md가 없을 것이므로 여기서 .md 추가
        const saveDir = path.dirname(savePath);
        if (!fs.existsSync(saveDir)) fs.mkdirSync(saveDir, { recursive: true });

        console.log('마크다운 변환 중...');
        const finalMarkdown = await page.evaluate(() => {
          // --- Start: Browser-side normalizeMdPath --- 
          function normalizeMdPathInternal(pathSegment) {
            if (!pathSegment) return '';
            if (pathSegment.includes('view-implementations')) {
              return '/documentation/montage/swiftuicore/view.md'; // 전체 경로 반환
            }
            // mailto, tel 등의 프로토콜은 그대로 반환
            if (pathSegment.startsWith('mailto:') || pathSegment.startsWith('tel:') || pathSegment.startsWith('http')) {
              // 외부 http 링크는 그대로 두거나, 특정 도메인만 내부 링크로 처리할 수 있음.
              // 여기서는 일단 외부링크로 간주하고 그대로 둠.
              // 만약 netlify 링크를 내부화하려면 여기서 추가 처리
              if (pathSegment.startsWith('https://incandescent-mandazi-032ed8.netlify.app')) {
                let internalPath = pathSegment.replace('https://incandescent-mandazi-032ed8.netlify.app', '');
                // 여기서 다시 normalizeMdPathInternal을 재귀적으로 호출하면 순환에 빠질 수 있으므로 주의
                // 여기서는 상대경로화된 부분에 대해서만 .md 처리를 시도한다.
                if (internalPath.endsWith('.md') || internalPath.includes('?') || internalPath.includes('#')) {
                  return internalPath;
                }
                const lastDot = internalPath.lastIndexOf('.');
                const lastSlash = internalPath.lastIndexOf('/');
                if (lastDot > Math.max(0, lastSlash) &&
                  !internalPath.substring(lastDot).includes('(') &&
                  !internalPath.substring(lastDot).includes(')') &&
                  !internalPath.substring(lastDot).includes('/')) {
                  return internalPath;
                }
                let cleanInternalPath = internalPath.endsWith('/') ? internalPath.slice(0, -1) : internalPath;
                return `${cleanInternalPath}.md`;
              }
              return pathSegment; // 외부 http 링크는 그대로 반환
            }
            if (pathSegment.endsWith('.md') || pathSegment.includes('?') || pathSegment.includes('#')) {
              return pathSegment;
            }
            const lastDotIndex = pathSegment.lastIndexOf('.');
            const lastSlashIndex = pathSegment.lastIndexOf('/');
            if (lastDotIndex > Math.max(0, lastSlashIndex) &&
              !pathSegment.substring(lastDotIndex).includes('(') &&
              !pathSegment.substring(lastDotIndex).includes(')') &&
              !pathSegment.substring(lastDotIndex).includes('/')) {
              return pathSegment;
            }
            let cleanPath = pathSegment.endsWith('/') ? pathSegment.slice(0, -1) : pathSegment;
            // 이미 /documentation/montage/ 로 시작하는 경우 중복 방지
            if (cleanPath.startsWith('/documentation/montage/')) {
              return `${cleanPath}.md`;
            }
            // 절대 경로가 아닌 경우, 현재 문서 기준으로 상대 경로화 필요할 수 있으나,
            // 여기서는 /documentation/montage/ 를 기준으로 링크를 만든다고 가정
            return `/documentation/montage/${cleanPath}.md`;
          }
          // --- End: Browser-side normalizeMdPath --- 

          const contentElement = document.querySelector('.content');
          if (!contentElement) return '컨텐츠를 찾을 수 없습니다.';

          // OnThisPageNav 요소 제거
          const onThisPageNav = contentElement.querySelector('.OnThisPageNav');
          if (onThisPageNav) {
            onThisPageNav.remove();
          }

          // TurndownService 생성 (브라우저 내에서 사용 가능한 방식으로)
          class TurndownService {
            constructor(options = {}) {
              this.options = Object.assign({
                headingStyle: 'atx',
                hr: '---',
                bulletListMarker: '-',
                codeBlockStyle: 'fenced',
                emDelimiter: '*',
                fence: '```',
                strongDelimiter: '**',
                linkStyle: 'inlined',
                linkReferenceStyle: 'full'
              }, options);
              
              this.rules = {
                breadcrumb: {
                  filter: '.nav-menu-items',
                  replacement: (content, node) => {
                    return ``;
                  }
                },
                heading: {
                  filter: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'],
                  replacement: (content, node) => {
                    const level = Number(node.nodeName.charAt(1));
                    const hashes = '#'.repeat(level);
                    const deprecated = node.querySelector('small.Deprecated, small[data-tag-name="Deprecated"]') ? '`Deprecated`' : '';
                    return `\n\n${hashes} ${content} ${deprecated}\n\n`;
                  }
                },
                deprecatedTopicBadge: {
                  filter: '.badge-deprecated',
                  replacement: (content, node) => {
                    return '\n\n  `Deprecated`';
                  }
                },
                paragraph: {
                  filter: 'p',
                  replacement: content => `\n\n${content}\n\n`
                },
                lineBreak: {
                  filter: 'br',
                  replacement: () => '\n\n'
                },
                strong: {
                  filter: ['strong', 'b'],
                  replacement: content => `**${content}**`
                },
                emphasis: {
                  filter: ['em', 'i'],
                  replacement: content => `*${content}*`
                },
                code: {
                  filter: '.declaration',
                  replacement: (content, node) => {
                    const codeElement = node.querySelector('code');
                    if (!codeElement) return '';
                    return `\n\n\`\`\`swift\n${codeElement.textContent.trim()}\n\`\`\`\n\n`;
                  }
                },
                codeListing: {
                  filter: '.code-listing',
                  replacement: (content, node) => {
                    const codeElement = node.querySelector('code');
                    if (!codeElement) return '';
                    return `\n\n\`\`\`swift\n${codeElement.textContent.trim()}\n\`\`\`\n\n`;
                  }
                },
                topicItem: {
                  filter: '.topic',
                  replacement: (content, node) => {
                    return `\n\n- ${content}`;
                  }
                },
                link: {
                  filter: 'a',
                  replacement: (content, node) => {
                    const href = node.getAttribute('href') || '';
                    const hasAdjacent = node.classList.contains('has-adjacent-elements');
                    if (href.includes('#')) {
                      return content.trim();
                    }
                    const normalizedHref = normalizeMdPathInternal(href);
                    let cleanContent = content.trim();
                    
                    if (cleanContent === 'API ReferenceView Implementations') {
                      cleanContent = cleanContent.replace('API Reference', '').trim();
                    }
                    
                    const isDeprecated = node.classList.contains('deprecated') || 
                                       node.className.includes('deprecated') || 
                                       node.closest('.badge-deprecated') !== null;
                    let result = '';
                    if (isDeprecated) {
                      result += `[~~${cleanContent}~~]`;
                    } else {
                      result += `[${cleanContent}]`;
                    }
                    result += `(${normalizedHref})\n\n`;
                    
                    if (hasAdjacent) {
                      result += `  `;
                    }
                    return result;
                  }
                },
                list: {
                  filter: ['ul', 'ol'],
                  replacement: (content, node) => {
                    return `\n\n${content.trim()}\n\n`;
                  }
                },
                listItem: {
                  filter: 'li',
                  replacement: (content, node) => {
                    const prefix = node.parentNode.nodeName === 'OL' ? 
                      `${node.parentNode.start ? node.parentNode.start : 1}. ` : 
                      '- ';
                    return `${prefix}${content.trim()}\n`;
                  }
                },
                blockquote: {
                  filter: 'aside',
                  replacement: (content, node) => {
                    const labelElement = node.querySelector('.label');
                    const labelText = labelElement ? labelElement.textContent.trim() : '';
                    // label 요소를 제외한 나머지 내용만 가져오기
                    const contentText = Array.from(node.querySelectorAll('p'))
                      .filter(p => !p.classList.contains('label'))
                      .map(p => p.textContent.trim())
                      .join('\n');
                    return `\n\n> **${labelText}**\n>\n> ${contentText}\n\n`;
                  }
                }
              };
            }
            
            turndown(htmlContent) {
              // HTML 문자열을 DOM으로 변환
              const tempDiv = document.createElement('div');
              tempDiv.innerHTML = htmlContent;
              return this.process(tempDiv);
            }
            
            process(node) {
              let output = '';
              
              if (node.nodeType === Node.ELEMENT_NODE) {
                // 요소(element) 노드 처리
                for (const rule in this.rules) {
                  const { filter, replacement } = this.rules[rule];
                  
                  if (typeof filter === 'string' && node.nodeName.toLowerCase() === filter) {
                    return replacement(this.getContent(node), node);
                  } else if (Array.isArray(filter) && filter.includes(node.nodeName.toLowerCase())) {
                    return replacement(this.getContent(node), node);
                  } else if (typeof filter === 'function' && filter(node)) {
                    return replacement(this.getContent(node), node);
                  } else if (node.classList && typeof filter === 'string' && filter.startsWith('.') && node.classList.contains(filter.substring(1))) {
                    return replacement(this.getContent(node), node);
                  }
                }
                
                // 매칭되는 규칙이 없으면 자식 노드 처리
                for (let i = 0; i < node.childNodes.length; i++) {
                  output += this.process(node.childNodes[i]);
                }
              } else if (node.nodeType === Node.TEXT_NODE) {
                // 텍스트 노드 처리
                output = node.nodeValue;
              }
              
              return output;
            }
            
            getContent(node) {
              let result = '';
              for (let i = 0; i < node.childNodes.length; i++) {
                result += this.process(node.childNodes[i]);
              }
              return result;
            }
          }
          
          // TurndownService 초기화 및 규칙 추가
          const turndownService = new TurndownService({
            headingStyle: 'atx',
            codeBlockStyle: 'fenced'
          });
          
          // 나머지 콘텐츠 변환
          const contentHTML = contentElement.innerHTML;
          const markdownContent = turndownService.turndown(contentHTML);
          
          // 특정 패턴 정리
          let cleanedContent = markdownContent
            .replace(/\n{3,}/g, '\n\n')  // 과도한 줄바꿈 제거
            .replace(/.*Current page is.*$/gm, '')  // 현재 페이지 정보 제거
            .replace(/#+\s+#/g, '#')  // 중복된 헤더 정리
            .replace(/\*\*\s+\*\*/g, '')  // 빈 강조 구문 제거
            .replace(/-- /g, '- ')  // 이중 리스트 마커 정리
          
          // 모든 콘텐츠 병합
          return cleanedContent;
        });

        fs.writeFileSync(savePath, finalMarkdown);
        console.log(`마크다운 저장 완료: ${savePath}`);

        const linksToFollow = await page.evaluate(() => {
          return Array.from(document.querySelectorAll('a'))
            .map(a => a.getAttribute('href'))
            .filter(href => href && href.includes('/documentation/montage/')) // 기준 URL 포함 링크만
            .map(href => {
              try {
                // 외부로 전달되는 링크는 절대 URL이어야 함
                const absoluteUrl = new URL(href, document.baseURI).href;
                const url = new URL(absoluteUrl);
                url.hash = '';
                return url.href;
              } catch (e) { return null; }
            })
            .filter(href => href !== null);
        });

        for (const link of linksToFollow) {
          if (!visitedUrls.has(link) && !queue.includes(link)) {
            if (link.includes('view-implementations')) {
              queue.push('https://incandescent-mandazi-032ed8.netlify.app/documentation/montage/swiftuicore/view.md');
            } else {
              queue.push(link);
            }
          }
        }
      } catch (error) {
        console.error(`페이지 처리 실패: ${currentUrl}`, error);
      }
    }
    console.log('모든 페이지 처리 완료.');
  } catch (error) {
    console.error('처리 중 오류 발생:', error);
  } finally {
    await browser.close();
  }
}

(async () => {
  try {
    require.resolve('playwright');
    try {
      // turndown 패키지가 설치되어 있는지 확인
      require.resolve('turndown');
      const baseUrl = 'https://incandescent-mandazi-032ed8.netlify.app/documentation/montage/';
      await extractAndConvertToMarkdown(baseUrl);
    } catch (e) {
      console.error('turndown이 설치되어 있지 않습니다. 먼저 설치해주세요:');
      console.error('npm install turndown || yarn add turndown');
    }
  } catch (e) {
    console.error('playwright가 설치되어 있지 않습니다. 먼저 설치해주세요:');
    console.error('npm install playwright || yarn add playwright');
  }
})();
