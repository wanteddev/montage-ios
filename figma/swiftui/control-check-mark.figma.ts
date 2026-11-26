// url=<FIGMA_CONTROL_CHECK_MARK>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Checkmark.swift
// component=Checkmark

// [2026-11-16] 근거: Checkmark.swift init(checked:size:onSelect:), .tight. 레이블이 없어도 컨테이너 폭이 줄어든다(medium 24→20, small 20→16, Control.swift tight — 2026-11-16 김삼열 님 검수).
// 컨트롤 단독(Check Mark/Resource/Control). Size 값은 Normal|Small.
import figma from 'figma';

import { flag } from '../shared/a-util';

const I = figma.selectedInstance;
const checked = I.getPropertyValue('State') === 'Checked';
const size = I.getEnum('Size', { Normal: '.medium', Small: '.small' });
const args = [`checked: ${checked}`];
if (size !== '.medium') args.push(`size: ${size}`);

let code = `Montage.Checkmark(${args.join(', ')}) { isChecked in\n    // checked = isChecked\n}`;
if (flag('Tight')) code += '\n.tight()';
if (flag('Disable')) code += '\n.disabled(true)';

export default { id: 'Checkmark', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
