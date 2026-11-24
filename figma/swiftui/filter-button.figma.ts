// url=<FIGMA_FILTER_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/FilterButton.swift
// component=FilterButton

// [2026-11-16] FilterButton.swift L70-75(init variant·size·text·handler), L143(.expanded), L155(.active(_:label:)).
// 비활성은 SwiftUI .disabled. iOS의 활성 라벨은 본문을 대체해 표시한다(L90) — Figma는 본문 뒤에 덧붙임.
import figma from 'figma';

import { swiftStr } from '../shared/b-items';

const I = figma.selectedInstance;
const on = (prop: string): boolean => I.getEnum(prop, { True: true, False: false }) === true;

const variant = I.getEnum('Variant', { Solid: '', Outlined: '.outlined' });
const size = I.getEnum('Size', { XSmall: '.xsmall', Small: '.small', Medium: '', Large: '.large' });
const args: string[] = [];
if (variant) args.push(`variant: ${variant}`);
if (size) args.push(`size: ${size}`);
args.push(`text: ${swiftStr(I.getString('Label'))}`);

let code = `Montage.FilterButton(${args.join(', ')}) {\n    // action\n}`;
if (on('Expanded')) code += '\n.expanded()';
if (on('Active')) {
  if (I.getBoolean('Active Label') === true) {
    code += '\n// iOS는 활성 라벨이 본문 텍스트를 대체합니다(Figma는 본문 뒤에 덧붙여 표시).';
    code += `\n.active(true, label: ${swiftStr(I.getString('┗ Text'))})`;
  } else {
    code += '\n.active(true)';
  }
}
if (on('Disable')) code += '\n.disabled(true)';

export default { id: 'FilterButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
