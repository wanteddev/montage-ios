// url=<FIGMA_TOOLTIP>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/8%20Presentation/Tooltip.swift
// component=Tooltip

// [2026-11-16] 근거: Tooltip.swift ActionMode, Size, Position + arrowPosition,
// View.tooltip(isPresented:mode:position:size:message:). mode는 필수라 .click으로 둔다.
// Figma Position(툴팁이 놓이는 쪽) Left·Right → .leading·.trailing, Arrow Align → arrowPosition. Shortcut은 iOS에 없다.
import figma from 'figma';

import { q } from '../shared/e-nav';
import { readTooltip } from '../shared/e-tooltip';

const m = readTooltip();
const pre: string[] = [];
if (m.shortcut) pre.push('// iOS Tooltip은 단축키(Shortcut) 표시를 지원하지 않습니다.');
const side: Record<string, string> = { Top: 'top', Bottom: 'bottom', Left: 'leading', Right: 'trailing' };
const arrow: Record<string, string> = {
  Leading: '.leading',
  Trailing: '.trailing',
  Top: '.top',
  Bottom: '.bottom',
};
const a = arrow[m.align];
const position = `.${side[m.position] ?? 'bottom'}(${a ? `arrowPosition: ${a}` : ''})`;
const args = ['isPresented: $isPresented', 'mode: .click', `position: ${position}`];
if (m.size === 'Small') args.push('size: .small');
args.push(`message: ${q(m.label)}`);

const code = [...pre, `.tooltip(\n    ${args.join(',\n    ')}\n)`].join('\n');

export default { id: 'Tooltip', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
