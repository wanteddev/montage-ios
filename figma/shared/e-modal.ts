// 그룹 e: Modal Navigation 렌더(iOS ModalNavigation) (2026-11-16)
// 근거
// - iOS  ModalNavigation.swift Variant, title, leading, trailings,
//        iconButtonBackground, searchField, Resource.Leading/Trailing
import { iosIcon } from './icon-name';
import {
  bool,
  find,
  indent,
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
const readModalNav = (nav: H): ModalNavModel | undefined => {
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
  if (bool(bar, '┗ Leading Button') === true) model.leading = readLeading(find(bar, 'Leading Button'), iosConvert);
  if (bool(bar, '┗ Trailing Button') !== false) {
    model.trailings = variant === 'Floating'
      ? readActionGroup(bar, iosConvert)
      : readTrailing(find(bar, 'Trailing Button'), iosConvert);
  }
  if (variant === 'Search') model.placeholder = searchPlaceholder(bar);
  model.toolbar = bool(bar, 'Tool Bar') === true || bool(bar, 'Tool Bar 2') === true;
  return model;
};

const IOS_VARIANT: Record<string, string> = {
  Normal: '.normal',
  Emphasized: '.emphasized',
  Floating: '.floating',
  Search: '.search',
};

/** Montage.ModalNavigation 스니펫. 기본값(.normal)이 아닐 때만 .variant를 쓴다. */
export const renderIosModalNav = (nav: H): string => {
  const m = readModalNav(nav);
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
