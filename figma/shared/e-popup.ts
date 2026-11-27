// 그룹 e: Popup·Bottom Sheet·Full 공통 조각 (2026-11-16)
// 근거
// - iOS  Popup.swift Resize, View.popup, BottomSheet.swift Resize, View.bottomSheet
import { renderIosModalNav } from './e-modal';
import { bool, find, indent, iosActionAreaPlaceholder, ok, prop, type H } from './e-nav';

const IOS_CONTENT = '{\n    // 콘텐츠\n}';

/** 내용(Action Area의 버튼 문구 등)은 Action Area 인스턴스의 Code Connect를 따른다. */
export const iosActionArea = (owner: H): string => {
  const actions = find(find(owner, 'Action Area'), 'Actions');
  return iosActionAreaPlaceholder(prop(actions, 'Variant'));
};

/** iOS 수정자 호출: .name(\n    args\n) {\n    // 콘텐츠\n} */
export const iosModifierCall = (name: string, args: string[]): string =>
  `.${name}(\n    ${args.map((a) => indent(a)).join(',\n    ')}\n) ${IOS_CONTENT}`;

export const iosClosureArg = (label: string, body: string): string =>
  `${label}: {\n    ${indent(body)}\n}`;

// ── Popup (Modal/Resource/Modal 본체) ─────────────────────

export const renderIosPopup = (body: H): string => {
  const pre: string[] = [];
  const args = ['isPresented: $isPresented'];
  if (prop(body, 'Resize') === 'Fixed') args.push('resize: .fixed(<#높이#>)');
  const size = prop(body, 'Size');
  if (size && size !== 'Medium') pre.push(`// iOS Popup에는 크기 축이 없습니다(Size=${size} → 화면 폭 기준 Medium으로 표시).`);
  if (bool(body, 'Navigation') === true) {
    const nav = find(body, 'Navigation');
    if (ok(nav)) args.push(iosClosureArg('navigation', renderIosModalNav(nav)));
  }
  if (bool(body, 'Action') === true) args.push(iosClosureArg('actionArea', iosActionArea(body)));
  return [...pre, iosModifierCall('popup', args)].join('\n');
};
