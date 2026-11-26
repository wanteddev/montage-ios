// url=<FIGMA_FALLBACK_VIEW>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/7%20Feedback/FallbackView.swift
// component=FallbackView

// [2026-11-16] 근거: FallbackView.swift init title:description:, ButtonActionArea single·horizontal·vertical,
// Padding normal·compact(기본 .normal), buttonActionArea, padding. 구 Empty State.
// Platform(Desktop/Mobile)은 iOS API가 없어 반영하지 않는다(버튼 크기는 코드가 정한다).
import figma from 'figma';

import { iosButtonActionArea, readButtons } from '../shared/d-fallback';
import { findFirst, flag, I, indent, text } from '../shared/d-util';

const args: string[] = [];
if (flag('Heading')) args.push(`title: "${text('┗ Text', '타이틀이 들어가요.')}"`);
args.push(`description: "${text('Description', '설명')}"`);

const lines = [`Montage.FallbackView(\n    ${args.join(',\n    ')}\n)`];
if (flag('Action Area')) {
  const buttons = readButtons(findFirst(I, ['Action Area']));
  if (buttons) lines.push(`.buttonActionArea(\n    ${indent(iosButtonActionArea(buttons), 4)}\n)`);
}
if (I.getPropertyValue('Padding') === 'Compact') lines.push('.padding(.compact)');

export default {
  id: 'FallbackView',
  imports: ['import Montage'],
  example: figma.code`${lines.join('\n')}`,
  metadata: { nestable: true },
};
