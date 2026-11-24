// url=<FIGMA_TOP_NAVIGATION>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/TopNavigation.swift
// component=TopNavigation

// [2026-11-16] 근거: TopNavigation.swift L48-63(Variant), L74(init), L103(variant), L126(title),
// L152(leadingContent), L180(trailingContents), L194(searchField), L234(toolbar),
// L595(LeadingButton), L651(TrailingTextButton), L696(TrailingIconButton), L744(Resource.Leading), L836-866(Resource.Toolbar)
// Bar의 제목·leading·trailing·검색·툴바를 읽는다. Background 속성은 iOS에 대응 API가 없다(스크롤로 자동).
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import {
  bool,
  find,
  indent,
  IOS_ACTION,
  iosLeadingCase,
  placeholders,
  prop,
  q,
  readLeading,
  readTool,
  readTrailing,
  searchPlaceholder,
  str,
} from '../shared/e-nav';

const I = figma.selectedInstance;
const convert = (n: string) => ({ ref: iosIcon(n) });
const VARIANT: Record<string, string> = {
  Normal: '.normal',
  Display: '.display',
  Search: '.search',
  Floating: '.floating',
};
const variantName = String(prop(I, 'Variant') ?? 'Normal');
const variant = VARIANT[variantName] ?? '.normal';
const bar = find(I, variantName === 'Floating' ? 'Nav Bar' : 'Bar', 'Bar', 'Nav Bar');
const pre: string[] = [];
const lines = ['Montage.TopNavigation()'];
if (variant !== '.normal') lines.push(`.variant(${variant})`);

// 제목 (Search는 검색 필드, Display·Floating은 속성명이 다르다)
const titleOn =
  variantName === 'Normal' || variantName === 'Floating'
    ? bool(bar, 'Title')
    : variantName === 'Display'
      ? bool(bar, '┗ Title')
      : false;
if (titleOn === true) lines.push(`.title(${q(str(bar, '┗ Text'))})`);

// Leading (Display에는 없음)
if (variantName !== 'Display' && bool(bar, '┗ Leading Button') === true) {
  const l = readLeading(find(bar, 'Leading Button'), convert);
  if (l) {
    lines.push(
      `.leadingContent {\n    ${indent(`Montage.TopNavigation.LeadingButton(${iosLeadingCase(l)})`)}\n}`,
    );
  }
}

// Trailing: 최대 3개
const trailing =
  bool(bar, '┗ Trailing Button') === true ? readTrailing(find(bar, 'Trailing Button'), convert) : [];
const items = trailing.map((t) => {
  if (t.kind === 'text') return `Montage.TopNavigation.TrailingTextButton(text: ${q(t.text)})${IOS_ACTION}`;
  const args = [`icon: ${t.icon?.ref ?? '.blank'}`];
  if (t.badge) args.push('showPushBadge: true');
  return `Montage.TopNavigation.TrailingIconButton(${args.join(', ')})${IOS_ACTION}`;
});
if (variantName === 'Display' && bool(bar, '┗ Avatar') === true) {
  pre.push('// Display의 Avatar는 trailingContents에 Avatar 뷰를 직접 넣습니다.');
}
if (items.length) {
  const blocks = items.map((c) => `    {\n        ${indent(c, '        ')}\n    }`);
  lines.push(`.trailingContents(\n${blocks.join(',\n')}\n)`);
}

// Search
if (variantName === 'Search') {
  const ph = searchPlaceholder(bar);
  lines.push(`.searchField(${ph ? `placeholder: ${q(ph)}, ` : ''}searchTerm: $searchTerm)`);
}

// Toolbar (Floating은 그리지 않음)
if (variantName !== 'Floating' && bool(I, 'Tool Bar') === true) {
  const tool = readTool(find(I, 'Tool Bar'));
  if (tool?.kind === 'tab') lines.push(`.toolbar(.tab(selectedIndex: $selectedIndex, items: ${placeholders('탭', tool.count)}))`);
  else if (tool?.kind === 'segmentedControl')
    lines.push(`.toolbar(.segmentedControl(selectedIndex: $selectedIndex, labels: ${placeholders('항목', tool.count)}))`);
  else if (tool?.kind === 'category')
    lines.push(`.toolbar(.category(selectedIndex: $selectedIndex, items: ${placeholders('카테고리', tool.count)}))`);
  else lines.push('.toolbar(.slot {\n    // 툴바 콘텐츠\n})');
}

const code = [...pre, ...lines].join('\n');

export default {
  id: 'TopNavigation',
  imports: ['import Montage'],
  example: figma.code`${code}`,
  metadata: { nestable: true },
};
