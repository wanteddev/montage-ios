// url=<FIGMA_CHIP>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/Chip.swift
// component=Chip

// [2026-11-16] Chip.swift L95-100(init), L178(.active), L247/L274(leading/trailingContent 슬롯).
// 슬롯은 크기·색을 지정해 주지 않아 docstring(L233-239)처럼 resizable·template·frame·foregroundStyle을 붙인다(2026-11-16 김삼열 님 검수).
// 크기는 Figma 실측(XSmall 12·Small 14·Medium 14·Large 16), 색은 fontColor(L304-311)와 같다: 비활성 foregroundDisablePrimary, Active surfaceBrandPrimary, 기본 foregroundNeutralPrimary.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const variant = I.getEnum('Variant', { Solid: '.solid', Outlined: '.outlined' });
const size = I.getEnum('Size', { XSmall: '.xsmall', Small: '.small', Medium: '.medium', Large: '.large' });
const args: string[] = [];
if (variant !== '.solid') args.push(`variant: ${variant}`);
if (size !== '.medium') args.push(`size: ${size}`);
args.push(`text: "${I.getString('Text')}"`);

const dim = I.getEnum('Size', { XSmall: '.dimension12', Small: '.dimension14', Medium: '.dimension14', Large: '.dimension16' });
// Disable·Active는 True/False VARIANT라 getEnum으로 읽는다.
const variantFlag = (prop: string): boolean => I.getEnum(prop, { True: true, False: false }) === true;
const disabled = variantFlag('Disable');
const active = variantFlag('Active');
const tint = disabled ? '.foregroundDisablePrimary' : active ? '.surfaceBrandPrimary' : '.foregroundNeutralPrimary';
const slotIcon = (ref: string): string =>
  `{\n    Image.icon(${ref})\n        .resizable()\n        .renderingMode(.template)\n        .frame(width: ${dim}, height: ${dim})\n        .foregroundStyle(SwiftUI.Color.semantic(${tint}))\n}`;

let code = `Montage.Chip(${args.join(', ')})${action}`;
if (active) code += '\n.active(true)';
if (I.getBoolean('Leading Content') === true)
  code += `\n.leadingContent ${slotIcon(iconRef('Leading Content'))}`;
if (I.getBoolean('Trailing Content') === true)
  code += `\n.trailingContent ${slotIcon(iconRef('Trailing Content'))}`;
if (disabled) code += '\n.disabled(true)';

export default { id: 'Chip', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
