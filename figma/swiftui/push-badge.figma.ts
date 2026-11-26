// url=<FIGMA_PUSH_BADGE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/7%20Feedback/PushBadge.swift
// component=PushBadge

// [2026-11-16] 근거: PushBadge.swift Variant .dot/.text/.maxCount, init, .size, .outlineBorder.
// 단독 배지 스니펫. 다른 뷰에 붙일 때는 View.pushBadge(variant:size:…)를 쓴다.
// Max Count는 Figma에서 99+ 고정(Text 속성 미연결) → 개수 변수 count로 표기.
import figma from 'figma';

import { flag, textOf } from '../shared/a-util';

const I = figma.selectedInstance;
const variant = I.getEnum('Variant', { Dot: 'dot', Text: 'text', 'Max Count': 'maxCount' });
const size = I.getEnum('Size', { XSmall: '.xsmall', Small: '.small', Medium: '.medium' });

const v =
  variant === 'text' ? `.text("${textOf('Text')}")`
  : variant === 'maxCount' ? '.maxCount(count)'
  : '.dot';
let code = `Montage.PushBadge(variant: ${v})`;
if (size !== '.xsmall') code += `\n.size(${size})`;
if (flag('Outline Border')) code += '\n.outlineBorder()';

export default { id: 'PushBadge', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
