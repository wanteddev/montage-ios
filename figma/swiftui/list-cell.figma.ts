// url=<FIGMA_LIST_CELL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell

// [2026-11-16] 근거: ListCell.swift init(label:onTap:)과 기본값, modifier, chevron(_:)·슬롯 4종(leadingResources(_:)·trailingResources(_:) 등), Resource.
// 슬롯 4개는 안에 든 하위 파트(List Cell/Resource/*) 템플릿이 넘긴 Resource case를 모아 배열로 넣는다.
// selected: trailing 요소가 있으면 그 요소만, 없으면 Check(selected(_:) docstring). Check 파트는 요소로 넣지 않는다.
// Interaction=False면 onTap을 넘기지 않는다(탭·인터랙션 배경 없음).
import figma from 'figma';

import { flag, I, indent, slotParts, text } from '../shared/d-util';

const action = ' {\n    // action\n}';

const resources = (show: string, slot: string): string[] | undefined => {
  if (!flag(show)) return undefined;
  const parts = slotParts(slot);
  const codes = parts.filter((p) => !p.selectedCheck && typeof p.code === 'string');
  const notes = codes.map((p) => p.note).filter((n): n is string => typeof n === 'string');
  if (codes.length === 0) {
    // 파트가 Check뿐이면 selected로 표현, 연결된 파트가 없으면 slot 자리표시
    if (parts.some((p) => p.selectedCheck)) return [];
    return ['.slot {\n    // 콘텐츠\n}'];
  }
  return [...notes.map((n) => `__NOTE__${n}`), ...codes.map((p) => p.code as string)];
};

const modifiers: string[] = [];
const notes: string[] = [];
const pushResources = (name: string, list: string[] | undefined) => {
  if (!list || list.length === 0) return;
  const items = list.filter((x) => !x.startsWith('__NOTE__'));
  list.filter((x) => x.startsWith('__NOTE__')).forEach((n) => notes.push(n.slice(8)));
  modifiers.push(
    items.length === 1 && !items[0].includes('\n')
      ? `.${name}([${items[0]}])`
      : `.${name}([\n    ${items.map((x) => indent(x, 4)).join(',\n    ')}\n])`,
  );
};

if (flag('Description')) modifiers.push(`.description("${text('┗ Text', '설명')}")`);
const padding = ({ None: '.none', Small: '.small', Large: '.large' } as Record<string, string>)[
  String(I.getPropertyValue('Vertical Padding'))
];
if (padding) modifiers.push(`.verticalPadding(${padding})`);
if (I.getPropertyValue('Vertical Align') === 'Center') modifiers.push('.verticalAlign(.center)');
if (I.getPropertyValue('Variant') === 'Full') modifiers.push('.variant(.full)');
if (flag('Text Ellipsis')) modifiers.push('.textEllipsis()');
if (flag('Selected')) modifiers.push('.selected()');
if (flag('Divider')) modifiers.push('.divider()');
pushResources('leadingResources', resources('Show Leading Content', 'Leading Content'));
pushResources('labelTrailingResources', resources('Show Label Trailing', 'Label Trailing'));
pushResources('trailingResources', resources('Show Trailing Content', 'Trailing Content'));
if (flag('Show Trailing Content') && flag('┗ Chevron')) modifiers.push('.chevron()');
pushResources('extraResources', resources('Show Extra Content', 'Extra Content'));
if (flag('Disable')) modifiers.push('.disabled(true)');

const call = `Montage.ListCell(label: "${text('Label', '텍스트')}")${flag('Interaction') ? action : ''}`;
const code = [...notes, call, ...modifiers].join('\n');

export default {
  id: 'ListCell',
  imports: ['import Montage'],
  example: figma.code`${code}`,
  metadata: { nestable: true },
};
