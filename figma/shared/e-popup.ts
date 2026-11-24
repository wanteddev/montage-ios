// 그룹 e: Popup·Bottom Sheet·Full 공통 조각 (2026-11-16)
// 근거
// - iOS  Popup.swift L39-45(Resize), L422-441(View.popup), BottomSheet.swift L56-69(Resize), L522-546(View.bottomSheet)
// - Android popup/WantedPopup.kt L146-155(topBar/bottomBar 오버로드), WantedPopupContract.kt L18-35(Resize),
//   bottomsheet/WantedModalBottomSheet.kt L67-78, WantedModalContract.kt L21-87(ModalType),
//   actions/actionarea/WantedActionArea.kt L232-248(main/onClickMain 오버로드)
import { P } from './compose';
import { call, renderAndroidModalNav, renderIosModalNav, slot } from './e-modal';
import { bool, find, indent, iosActionAreaPlaceholder, ok, prop, type H } from './e-nav';

export const IOS_CONTENT = '{\n    // 콘텐츠\n}';

/** 내용(Action Area의 버튼 문구 등)은 Action Area 인스턴스의 Code Connect를 따른다. */
export const iosActionArea = (owner: H): string => {
  const actions = find(find(owner, 'Action Area'), 'Actions');
  return iosActionAreaPlaceholder(prop(actions, 'Variant'));
};

export const androidActionArea = (imports: Set<string>): string => {
  imports.add(`import ${P}.actions.actionarea.WantedActionArea`);
  return 'WantedActionArea(\n    main = "확인",\n    onClickMain = { }\n)';
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

export const renderAndroidPopup = (body: H): { code: string; imports: string[] } => {
  const imports = new Set<string>([`import ${P}.presentation.modal.popup.WantedPopup`]);
  const pre: string[] = [];
  const args = ['onDismissRequest = { }'];
  if (prop(body, 'Resize') === 'Fixed') {
    args.push('resize = Resize.Fixed(height = 480.dp)');
    imports.add(`import ${P}.presentation.modal.popup.WantedPopupContract.Resize`);
    imports.add('import androidx.compose.ui.unit.dp');
    pre.push('// Resize=Fixed: 높이(480.dp)는 예시 값입니다.');
  }
  const size = prop(body, 'Size');
  if (size && size !== 'Medium') pre.push(`// 모바일 Popup은 Medium 한 가지입니다(Size=${size} 미지원).`);
  if (bool(body, 'Navigation') === true) {
    const nav = renderAndroidModalNav(find(body, 'Navigation'));
    if (nav.code) {
      pre.push(...nav.notes);
      nav.imports.forEach((i) => imports.add(i));
      args.push(slot('topBar', [nav.code]));
    }
  }
  if (bool(body, 'Action') === true) args.push(slot('bottomBar', [androidActionArea(imports)]));
  args.push(slot('content', ['// 콘텐츠']));
  return { code: [...pre, call('WantedPopup', args)].join('\n'), imports: [...imports].sort() };
};
