// url=<FIGMA_POPOVER>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/8%20Presentation/Popover.swift
// component=Popover

// [2026-11-16] 근거: Popover.swift View.popoverNormal(isPresented:heading:text:closeButton:action:subAction:),
// View.popoverCustom(isPresented:content:). action은 기본값이 없어 Action=false면 nil로 쓴다.
// iOS 팝오버 위치는 시스템 popover가 정한다(Position 대응 인자 없음).
import figma from 'figma';

import { indent, q } from '../shared/e-nav';
import { readPopover } from '../shared/e-popover';

const m = readPopover();
const pre: string[] = [];
if (m.horizontal) pre.push('// iOS 팝오버의 위치(Left and Right)는 시스템이 정합니다.');
const tuple = (title: string) => `(title: ${q(title)}, action: {\n    // action\n})`;

let code: string;
if (m.custom) {
  code = '.popoverCustom(isPresented: $isPresented) {\n    // 콘텐츠\n}';
} else {
  const args = ['isPresented: $isPresented'];
  if (m.heading !== undefined) args.push(`heading: ${q(m.heading)}`);
  args.push(`text: ${q(m.text)}`);
  if (!m.closeButton) args.push('closeButton: false');
  args.push(m.action !== undefined ? `action: ${tuple(m.action)}` : 'action: nil');
  if (m.subAction !== undefined) args.push(`subAction: ${tuple(m.subAction)}`);
  code = `.popoverNormal(\n    ${args.map((a) => indent(a)).join(',\n    ')}\n)`;
}
code = [...pre, code].join('\n');

export default { id: 'Popover', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
