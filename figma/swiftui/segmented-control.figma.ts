// url=<FIGMA_SEGMENTED_CONTROL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/SegmentedControl.swift
// component=SegmentedControl

// [2026-11-16] SegmentedControl.swift L59(Item init leadingIcon·title), L88(items init), L100(labels init),
// L186(.size, 기본 .large), L199(.iconOnly — title은 VoiceOver 라벨로 쓰임).
import figma from 'figma';

import { readItem, swiftList, swiftStr } from '../shared/b-items';
import { iosIcon } from '../shared/icon-name';
import { iconFromInstance } from '../shared/resolve-icon';

const I = figma.selectedInstance;

// Segment 1·2는 항상 보이고 3~6은 'Segment N' 불리언으로 켠다. 각 Knob: Text·Active, 아이콘은 안쪽 'Icon' 래퍼.
const segments = [1, 2, 3, 4, 5, 6]
  .filter((n) => n <= 2 || I.getBoolean(`Segment ${n}`) === true)
  .map((n) => readItem(I.findInstance(`Segment ${n}`), 'Text'));

const size = I.getEnum('Size', { Small: '.small', Medium: '.medium', Large: '' });
const iconOnly = I.getEnum('Icon Only', { True: true, False: false }) === true;
const withIcon = iconOnly || I.getEnum('Leading Icon', { True: true, False: false }) === true;

const iconOf = (seg: (typeof segments)[number]): string => {
  const inner = seg.node && seg.node.type !== 'ERROR' ? seg.node.findInstance('Icon') : undefined;
  return iconFromInstance(inner, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
};

let code: string;
if (withIcon) {
  const items = segments.map((s) => `.init(leadingIcon: .icon(${iconOf(s)}), title: ${swiftStr(s.label)})`);
  code = `Montage.SegmentedControl(\n    selectedIndex: $selectedIndex,\n    items: [\n        ${items.join(',\n        ')}\n    ]\n)`;
} else {
  code = `Montage.SegmentedControl(selectedIndex: $selectedIndex, labels: ${swiftList(segments.map((s) => s.label))})`;
}
if (size) code += `\n.size(${size})`;
if (iconOnly) code += '\n.iconOnly()';

export default { id: 'SegmentedControl', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
