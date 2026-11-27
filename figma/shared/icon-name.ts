// Figma 아이콘 이름 → iOS 아이콘 표기 변환 (2026-11-16)
// 근거: docs/plans/code-connect-icon-name-mapping-2026-11-16.md
// 입력은 Web 아이콘 컴포넌트명에서 'Icon'을 뗀 이름(예: IconAgentColor → agentColor)
// 또는 Figma 아이콘 인스턴스의 Name variant(예: heart).

/** iOS `Icon` enum case. 이름이 그대로 일치한다(scripts/tests/icon_code_connect_batch.test.js에서 확인). */
export const iosIcon = (name: string): string => `.${name}`;

/** Web 아이콘 컴포넌트명(IconHeartFill) → 이름(heartFill) */
export const nameFromComponent = (component: string): string => {
  const n = component.replace(/^Icon/, '');
  return n.charAt(0).toLowerCase() + n.slice(1);
};
