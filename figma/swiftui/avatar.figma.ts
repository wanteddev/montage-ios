// url=<FIGMA_AVATAR>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/Avatar.swift
// component=Avatar

// [2026-11-16] 근거: Avatar.swift L147(init(_ imageUrl:variant:size:onTap:), size 기본 .small), L226(.pushBadge).
// Interaction=true → onTap 클로저(탭 영역·눌림 효과), Placeholder=True → 이미지 없음(유형별 기본 이미지 표시).
import figma from 'figma';

import { flag } from '../shared/a-util';

const I = figma.selectedInstance;
const variant = I.getEnum('Variant', { Person: '.person', Company: '.company', Academy: '.academy' });
const size = I.getEnum('Size', { XSmall: '.xsmall', Small: '.small', Medium: '.medium', Large: '.large', XLarge: '.xlarge' });
const placeholder = flag('Placeholder');

const args = [placeholder ? '""' : 'imageUrl', `variant: ${variant}`];
if (size !== '.small') args.push(`size: ${size}`);
let code = placeholder ? '// 이미지가 없으면 유형별 기본 이미지가 표시됩니다.\n' : '';
code += `Montage.Avatar(${args.join(', ')})`;
if (flag('Interaction')) code += ' {\n    // action\n}';
if (flag('Push Badge')) code += '\n.pushBadge()';

export default { id: 'Avatar', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
