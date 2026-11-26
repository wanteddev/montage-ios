// url=<FIGMA_TAB>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/Tab.swift
// component=Tab

// [2026-11-16] Tab.swift init selectedIndex·items·itemDisabled, .resize, .size, .horizontalPadding,
// .iconButton(.hug에서만 표시). 기본값 resize .hug·size .medium. 좌우 그라디언트는 스크롤 위치로 자동 표시(Gradient 속성 무시).
import figma from 'figma';

import { readItem, disabledIndices, swiftList } from '../shared/b-items';
import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';

// 'Tab 1'…'Tab 8' 불리언으로 켠 항목만. 각 항목: ┗ Text·Active·Disabled
const items = [1, 2, 3, 4, 5, 6, 7, 8]
  .filter((n) => I.getBoolean(`Tab ${n}`) === true)
  .map((n) => readItem(I.findInstance(`Tab ${n}`), '┗ Text'));
const disabled = disabledIndices(items);

const resize = I.getEnum('Resize', { Hug: '', Fill: '.fill' });
const size = I.getEnum('Size', { Small: '.small', Medium: '', Large: '.large' });

const args = [`selectedIndex: $selectedIndex`, `items: ${swiftList(items.map((i) => i.label))}`];
if (disabled.length) args.push(`itemDisabled: { [${disabled.join(', ')}].contains($0) }`);

let code = `Montage.Tab(${args.join(', ')})`;
if (resize) code += `\n.resize(${resize})`;
if (size) code += `\n.size(${size})`;
// horizontalPadding·iconButton은 resize == .hug일 때만 적용된다(Tab.swift body의 resize == .hug 분기 — 2026-11-16 김삼열 님 검수). Fill이면 padding은 생략.
if (!resize && I.getEnum('Horizontal Padding', { True: true, False: false }) === true) code += '\n.horizontalPadding()';
if (I.getBoolean('Trailing Icon Button') === true) {
  if (resize) code += '\n// iconButton은 .resize(.hug)에서만 표시됩니다.';
  code += `\n.iconButton(${iconRef('Icon Button')}) {\n    // action\n}`;
}

export default { id: 'Tab', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
