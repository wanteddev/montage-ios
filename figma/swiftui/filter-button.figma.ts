// url=<FIGMA_FILTER_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/FilterButton.swift
// component=FilterButton

// [2026-11-16] FilterButton.swift init variant·size·text·handler, .expanded, .active(_:label:).
// 비활성은 SwiftUI .disabled. 활성 라벨은 .active(true, label:)일 때 본문 텍스트 뒤에 덧붙여 표시한다(Figma와 같음).
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
