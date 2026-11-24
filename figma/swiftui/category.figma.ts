// url=<FIGMA_CATEGORY>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/Category.swift
// component=Category

// [2026-11-16] Category.swift L65-70(init selectedIndex·items), L157(.itemDisabled), L167(.variant), L177(.size),
// L187/L197(.horizontalPadding/.verticalPadding), L209(.iconButton). 좌우 그라디언트는 스크롤 위치로 자동 표시(Gradient 속성 무시).
import figma from 'figma';

import { readItemsByName, disabledIndices, swiftList } from '../shared/b-items';
import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';

// 'Chip list' 슬롯 안의 'Chip 1'… 인스턴스: Text·Active·Disabled
const items = readItemsByName(/^Chip \d+$/, 'Text');
const labels = items.length ? items.map((i) => i.label) : ['텍스트'];
const disabled = disabledIndices(items);

const variant = I.getEnum('Variant', { Normal: '', Alternative: '.alternative' });
const size = I.getEnum('Size', { Small: '.small', Medium: '', Large: '.large', XLarge: '.xlarge' });

let code = `Montage.Category(selectedIndex: $selectedIndex, items: ${swiftList(labels)})`;
if (disabled.length) code += `\n.itemDisabled { [${disabled.join(', ')}].contains($0) }`;
if (variant) code += `\n.variant(${variant})`;
if (size) code += `\n.size(${size})`;
if (I.getEnum('Horizontal Padding', { True: true, False: false }) === true) code += '\n.horizontalPadding()';
if (I.getBoolean('Vertical Padding') === true) code += '\n.verticalPadding()';
if (I.getBoolean('Icon Button') === true)
  code += `\n.iconButton(${iconRef('Icon Button')}) {\n    // action\n}`;

export default { id: 'Category', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
