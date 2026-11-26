// 그룹 e: Modal Navigation 렌더(iOS ModalNavigation / Android WantedDialog*TopAppBar) (2026-11-16)
// 근거
// - iOS  ModalNavigation.swift Variant, title, leading, trailings,
//        iconButtonBackground, searchField, Resource.Leading/Trailing
// - Android dialogtopbar/WantedDialogTopAppBar.kt WantedDialogTopAppBar, WantedDialogCloseTopAppBar,
//        WantedDialogSearchTopAppBar, WantedDialogTopAppBarContract.kt Variant
import { androidIcon, iosIcon } from './icon-name';
import {
  bool,
  find,
  indent,
  IOS_ACTION,
  iosLeadingCase,
  iosModalTrailingCase,
  ok,
  prop,
  q,
  readActionGroup,
  readLeading,
  readTrailing,
  searchPlaceholder,
  str,
  type H,
  type Leading,
  type Trailing,
} from './e-nav';
import { P } from './compose';

export type ModalNavModel = {
  variant: 'Normal' | 'Emphasized' | 'Floating' | 'Search';
  title?: string;
  leading?: Leading;
  trailings: Trailing[];
  placeholder?: string;
  toolbar: boolean;
};

const iosConvert = (n: string) => ({ ref: iosIcon(n) });

/** Modal/Resource/Navigation · Modal/Full/Resource/Navigation 인스턴스 읽기 */
export const readModalNav = (nav: H, convert: (n: string) => { ref: string; note?: string }): ModalNavModel | undefined => {
  if (!ok(nav)) return undefined;
  const variant = String(prop(nav, 'Variant') ?? 'Emphasized') as ModalNavModel['variant'];
  const bar = find(nav, '┗ Bar', 'Bar');
  const model: ModalNavModel = { variant, trailings: [], toolbar: false };
  if (!ok(bar)) return model;

  if (variant === 'Floating') {
    if (bool(bar, '┗ Title​', '┗ Title') === true) model.title = str(bar, '┗ Text');
  } else if (variant !== 'Search') {
    if (bool(bar, '┗ Title') === true) model.title = str(bar, '┗ Text');
  }
  if (bool(bar, '┗ Leading Button') === true) model.leading = readLeading(find(bar, 'Leading Button'), convert);
  if (bool(bar, '┗ Trailing Button') !== false) {
    model.trailings = variant === 'Floating'
      ? readActionGroup(bar, convert)
      : readTrailing(find(bar, 'Trailing Button'), convert);
  }
  if (variant === 'Search') model.placeholder = searchPlaceholder(bar);
  model.toolbar = bool(bar, 'Tool Bar') === true || bool(bar, 'Tool Bar 2') === true;
  return model;
};

// ── iOS ───────────────────────────────────────────────

const IOS_VARIANT: Record<string, string> = {
  Normal: '.normal',
  Emphasized: '.emphasized',
  Floating: '.floating',
  Search: '.search',
};

/** Montage.ModalNavigation 스니펫. 기본값(.normal)이 아닐 때만 .variant를 쓴다. */
export const renderIosModalNav = (nav: H): string => {
  const m = readModalNav(nav, iosConvert);
  if (!m) return 'Montage.ModalNavigation()';
  const lines: string[] = [];
  if (m.toolbar) lines.push('// iOS ModalNavigation에는 툴바(Tab·Segmented Control) 슬롯이 없습니다.');
  lines.push('Montage.ModalNavigation()');
  if (m.variant !== 'Normal') lines.push(`.variant(${IOS_VARIANT[m.variant] ?? '.emphasized'})`);
  if (m.title !== undefined && m.variant !== 'Search') lines.push(`.title(${q(m.title)})`);
  if (m.leading) lines.push(`.leading(${iosLeadingCase(m.leading)})`);
  if (m.trailings.length === 1) {
    lines.push(`.trailings(${iosModalTrailingCase(m.trailings[0])})`);
  } else if (m.trailings.length > 1) {
    const items = m.trailings.map((t) => '    ' + indent(iosModalTrailingCase(t)));
    lines.push(`.trailings(\n${items.join(',\n')}\n)`);
  }
  if (m.variant === 'Floating' && m.trailings.some((t) => t.background)) lines.push('.iconButtonBackground()');
  if (m.variant === 'Search') {
    const args: string[] = [];
    if (m.placeholder) args.push(`placeholder: ${q(m.placeholder)}`);
    args.push('searchTerm: $searchTerm');
    lines.push(`.searchField(${args.join(', ')})`);
  }
  return lines.join('\n');
};

// ── Android ───────────────────────────────────────────

export const D = `${P}.navigations.topbar.dialogtopbar`;
export const TB = `${P}.navigations.topbar`;
export const PAINTER = 'androidx.compose.ui.res.painterResource';

export type Rendered = { code: string; imports: string[]; notes: string[] };

/** WantedTopAppBarIconButton 한 개 */
export const androidIconButton = (ref: string, badge = false): string => {
  const args = [`painter = painterResource(${ref})`];
  if (badge) args.push('badge = { /* WantedPushBadge */ }');
  return args.length === 1
    ? `WantedTopAppBarIconButton(${args[0]})`
    : `WantedTopAppBarIconButton(\n    ${args.join(',\n    ')}\n)`;
};

/** 여러 줄 인자 블록 렌더 (composeBuilder와 같은 규칙: 4칸, 마지막 쉼표 없음) */
export const call = (fn: string, args: string[]): string =>
  args.length ? `${fn}(\n    ${args.map((a) => indent(a)).join(',\n    ')}\n)` : `${fn}()`;

/** 람다 슬롯: name = {\n    body\n} */
export const slot = (name: string, body: string[]): string =>
  `${name} = {\n${body.map((b) => '    ' + indent(b)).join('\n')}\n}`;

export const renderAndroidLeading = (l: Leading, imports: Set<string>): string => {
  if (l.kind === 'text') {
    imports.add(`import ${P}.actions.button.textbutton.WantedTextButton`);
    return `WantedTextButton(text = ${q(l.text)})`;
  }
  imports.add(`import ${TB}.WantedTopAppBarIconButton`);
  imports.add(`import ${PAINTER}`);
  const ref = l.kind === 'back' ? 'R.drawable.icon_normal_arrow_left' : l.icon?.ref ?? 'R.drawable.icon_normal_blank';
  return androidIconButton(ref);
};

export const renderAndroidAction = (t: Trailing, imports: Set<string>): string => {
  if (t.kind === 'text') {
    imports.add(`import ${P}.actions.button.textbutton.WantedTextButton`);
    return `WantedTextButton(text = ${q(t.text)})`;
  }
  imports.add(`import ${TB}.WantedTopAppBarIconButton`);
  imports.add(`import ${PAINTER}`);
  const ref = t.kind === 'close' ? 'R.drawable.icon_normal_close' : t.icon?.ref ?? 'R.drawable.icon_normal_blank';
  return androidIconButton(ref, t.badge === true);
};

export const renderAndroidModalNav = (nav: H): Rendered => {
  const notes: string[] = [];
  const convert = (n: string) => {
    const r = androidIcon(n);
    if (r.note && !notes.includes(r.note)) notes.push(r.note);
    return r;
  };
  const m = readModalNav(nav, convert);
  const imports = new Set<string>();
  if (!m) return { code: '', imports: [], notes };
  if (m.toolbar) notes.push('// Android WantedDialogTopAppBar에는 툴바(Tab·Segmented Control) 슬롯이 없습니다.');

  const args: string[] = [];
  const navIcon = m.leading ? [slot('navigationIcon', [renderAndroidLeading(m.leading, imports)])] : [];
  const variantImport = `${D}.WantedDialogTopAppBarContract.Variant`;
  const onlyClose = m.trailings.length === 1 && m.trailings[0].kind === 'close';
  let fn: string;

  if (m.variant === 'Search') {
    fn = 'WantedDialogSearchTopAppBar';
    args.push('text = ""');
    if (m.placeholder) args.push(`placeholder = ${q(m.placeholder)}`);
    const cancel = m.trailings.find((t) => t.kind === 'text');
    if (cancel) args.push(`cancelText = ${q(cancel.text)}`);
    args.push(...navIcon);
  } else {
    fn = onlyClose ? 'WantedDialogCloseTopAppBar' : 'WantedDialogTopAppBar';
    if (m.variant === 'Emphasized') {
      args.push('variant = Variant.Emphasized');
      imports.add(`import ${variantImport}`);
    } else if (m.variant === 'Floating') {
      args.push(onlyClose && m.trailings[0].background ? 'variant = Variant.Floating(iconBackground = true)' : 'variant = Variant.Floating()');
      imports.add(`import ${variantImport}`);
    }
    if (m.title !== undefined) args.push(`title = ${q(m.title)}`);
    args.push(...navIcon);
    if (!onlyClose && m.trailings.length) {
      args.push(slot('actions', m.trailings.map((t) => renderAndroidAction(t, imports))));
    }
  }
  imports.add(`import ${D}.${fn}`);
  return { code: call(fn, args), imports: [...imports], notes };
};

export { IOS_ACTION };
