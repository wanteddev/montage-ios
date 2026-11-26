// url=<FIGMA_CHECK_MARK>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Checkmark.swift
// component=Checkmark

// [2026-11-16] 근거: Checkmark.swift init(checked:size:onSelect:), .label, .tight. controlled. 레이블이 없어도 tight가 적용된다(2026-11-16 김삼열 님 검수).
// Figma Tight·Disable·State는 True/False VARIANT라 flag()로 읽는다.
import figma from 'figma';

import { flag, textOf } from '../shared/a-util';

const I = figma.selectedInstance;
const checked = I.getPropertyValue('State') === 'Checked';
const size = I.getEnum('Size', { Medium: '.medium', Small: '.small' });
const args = [`checked: ${checked}`];
if (size !== '.medium') args.push(`size: ${size}`);

const label = flag('Label');
const tight = flag('Tight');
let code = '';
code += `Montage.Checkmark(${args.join(', ')}) { isChecked in\n    // checked = isChecked\n}`;
if (label) code += `\n.label("${textOf('┗ Text​')}")`;
if (tight) code += '\n.tight()';
if (flag('Disable')) code += '\n.disabled(true)';

export default { id: 'Checkmark', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
