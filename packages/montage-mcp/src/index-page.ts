import { PACKAGE_NAME, PACKAGE_VERSION } from "./core/config.js";

const NPM_PACKAGE = "@wanteddev/montage-ios-mcp";
const REPO_URL = "https://github.com/wanteddev/montage-ios";
const PUBLIC_ORIGIN = "https://montage-ios.lab.wntd.co";

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

export function renderIndexPage(_origin: string): string {
  const safeOrigin = escapeHtml(PUBLIC_ORIGIN);
  const sseUrl = `${safeOrigin}/sse`;
  const remoteAddCmd = `claude mcp add --transport sse montage-ios ${sseUrl}`;
  const stdioAddCmd = `claude mcp add montage-ios -- npx -y ${NPM_PACKAGE}`;
  const cursorJson = `{
  "mcpServers": {
    "montage-ios": {
      "url": "${sseUrl}"
    }
  }
}`;
  const safeName = escapeHtml(PACKAGE_NAME);
  const safeVersion = escapeHtml(PACKAGE_VERSION);

  return `<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${safeName} — Setup</title>
<style>
  :root {
    color-scheme: light dark;
    --bg: #ffffff;
    --fg: #1a1a1a;
    --muted: #666;
    --border: #e5e5e5;
    --code-bg: #f5f5f5;
    --accent: #0066cc;
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #1a1a1a;
      --fg: #f0f0f0;
      --muted: #999;
      --border: #333;
      --code-bg: #2a2a2a;
      --accent: #4d9fff;
    }
  }
  * { box-sizing: border-box; }
  body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Pretendard", sans-serif;
    background: var(--bg);
    color: var(--fg);
    line-height: 1.6;
  }
  main { max-width: 760px; margin: 0 auto; padding: 48px 24px 96px; }
  h1 { font-size: 28px; margin: 0 0 8px; }
  h2 { font-size: 20px; margin: 32px 0 12px; padding-top: 12px; border-top: 1px solid var(--border); }
  h2:first-of-type { border-top: none; padding-top: 0; }
  p { margin: 8px 0; color: var(--fg); }
  .meta { color: var(--muted); font-size: 14px; margin-bottom: 24px; }
  .meta code { font-size: 13px; }
  code, pre { font-family: ui-monospace, "SF Mono", Menlo, Consolas, monospace; }
  code { background: var(--code-bg); padding: 2px 6px; border-radius: 4px; font-size: 13px; }
  .block { position: relative; }
  pre {
    background: var(--code-bg);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 14px 16px;
    overflow-x: auto;
    font-size: 13px;
    margin: 8px 0;
  }
  button.copy {
    position: absolute;
    top: 8px;
    right: 8px;
    border: 1px solid var(--border);
    background: var(--bg);
    color: var(--fg);
    border-radius: 6px;
    padding: 4px 10px;
    font-size: 12px;
    cursor: pointer;
  }
  button.copy:hover { border-color: var(--accent); color: var(--accent); }
  ul { padding-left: 20px; }
  li { margin: 6px 0; }
  a { color: var(--accent); }
  table { border-collapse: collapse; width: 100%; margin: 12px 0; font-size: 14px; }
  th, td { border: 1px solid var(--border); padding: 8px 12px; text-align: left; }
  th { background: var(--code-bg); }
</style>
</head>
<body>
<main>
  <h1>${safeName}</h1>
  <p class="meta">v${safeVersion} · MCP server for Montage iOS Design System · <a href="${REPO_URL}">GitHub</a></p>

  <p>이 서버는 AI 코딩 어시스턴트(Claude Code, Cursor 등)에 Montage 컴포넌트 문서·디자인 토큰·아이콘·Figma 매핑 도구를 제공합니다. 아래 안내를 따라 클라이언트에 등록하면 바로 사용할 수 있습니다.</p>

  <h2>1. Claude Code (원격 SSE)</h2>
  <p>가장 권장되는 방식. 항상 최신 데이터를 사용합니다.</p>
  <div class="block">
    <pre id="cmd-remote">${escapeHtml(remoteAddCmd)}</pre>
    <button class="copy" data-target="cmd-remote">복사</button>
  </div>

  <h2>2. Claude Code (로컬 stdio, npx)</h2>
  <p>오프라인에서도 동작. npm 레지스트리에서 패키지를 받아 로컬 프로세스로 실행합니다.</p>
  <div class="block">
    <pre id="cmd-stdio">${escapeHtml(stdioAddCmd)}</pre>
    <button class="copy" data-target="cmd-stdio">복사</button>
  </div>

  <h2>3. Cursor / 기타 MCP 클라이언트</h2>
  <p>설정 파일에 SSE 엔드포인트를 추가합니다.</p>
  <div class="block">
    <pre id="cmd-cursor">${escapeHtml(cursorJson)}</pre>
    <button class="copy" data-target="cmd-cursor">복사</button>
  </div>

  <h2>제공 도구</h2>
  <table>
    <thead><tr><th>도구</th><th>설명</th></tr></thead>
    <tbody>
      <tr><td><code>figma_to_swiftui_workflow</code></td><td>Figma → Montage SwiftUI 변환 워크플로우 (다른 도구들을 오케스트레이션)</td></tr>
      <tr><td><code>health_check</code></td><td>서버 상태 + 버전</td></tr>
      <tr><td><code>getting_started</code></td><td>Montage 시작 가이드</td></tr>
      <tr><td><code>montage_coding_guidelines</code></td><td>SwiftUI 작성 규칙</td></tr>
      <tr><td><code>list_components</code></td><td>전체 컴포넌트 카탈로그</td></tr>
      <tr><td><code>get_component</code></td><td>컴포넌트 상세 API</td></tr>
      <tr><td><code>list_tokens</code></td><td>디자인 토큰 목록</td></tr>
      <tr><td><code>get_color_usage</code></td><td>컬러 토큰 사용 가이드</td></tr>
      <tr><td><code>list_icons</code></td><td>아이콘 목록 (검색 지원)</td></tr>
      <tr><td><code>resolve_figma_component</code></td><td>Figma → Montage 컴포넌트 매핑</td></tr>
      <tr><td><code>resolve_figma_token</code></td><td>Figma → Montage 토큰 매핑</td></tr>
    </tbody>
  </table>

  <h2>엔드포인트</h2>
  <ul>
    <li><code>GET /</code> — 이 안내 페이지</li>
    <li><code>GET /sse</code> — MCP SSE 스트림</li>
    <li><code>POST /messages?sessionId=...</code> — MCP 메시지 수신</li>
    <li><code>GET /healthz</code> — 헬스체크 JSON</li>
  </ul>
</main>
<script>
  document.querySelectorAll('button.copy').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const id = btn.getAttribute('data-target');
      if (!id) return;
      const el = document.getElementById(id);
      if (!el) return;
      try {
        await navigator.clipboard.writeText(el.innerText);
        const original = btn.textContent;
        btn.textContent = '복사됨';
        setTimeout(() => { btn.textContent = original; }, 1500);
      } catch {
        // ignore
      }
    });
  });
</script>
</body>
</html>`;
}
