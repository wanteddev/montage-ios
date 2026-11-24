// url=<FIGMA_ACCORDION>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/Accordion.swift
// component=Accordion

// [2026-11-16] 근거: Accordion.swift L117-141(init title:description:content:), L202(verticalPadding, 기본 .large),
// L227(variant, Fill Width=True → .full), L237(hideDivider), L251(leadingIcon), L287(trailingContent { isExpanded in }).
// 펼침 상태(Expand)는 내부 @State라(L297) 지정할 수 없다. 'Trailing Content'(접힘)/'Trailing Content᠎'(펼침) 교체 속성에
// 기본 화살표가 아닌 Accordion 파트(Icon Button/Text Button)가 들어 있으면 trailingContent로 넣는다.
// '┗ Icon'(제목 옆 아이콘)은 iOS API가 없어 반영하지 않는다.
import figma from 'figma';

import { block, flag, I, iosIconOf, run, safe, text } from '../shared/d-util';

const expanded = flag('Expand');
const args = [`title: "${text('Heading', '제목')}"`];
if (flag('Description')) args.push(`description: "${text('┗ Text', '설명')}"`);

const lines: string[] = [];
if (expanded) lines.push('// Expand=True: 펼침은 사용자가 탭해 바꾸는 내부 상태입니다.');
lines.push(
  `Montage.Accordion(${args.join(', ')})${flag('Show Content') ? ` ${block('// 콘텐츠')}` : ''}`,
);
const padding = ({ Small: '.small', Medium: '.medium' } as Record<string, string>)[String(I.getPropertyValue('Vertical Padding'))];
if (padding) lines.push(`.verticalPadding(${padding})`);
if (flag('Fill Width')) lines.push('.variant(.full)');
if (!flag('Divider')) lines.push('.hideDivider()');
if (flag('Leading Icon')) {
  const icon = safe(() => I.findInstance('Icon', { path: ['Leading Content'] }));
  lines.push(`.leadingIcon(${iosIconOf(icon && icon.type !== 'ERROR' ? icon : safe(() => I.findInstance('Icon')))})`);
}
const swap = safe(() => I.getInstanceSwap(expanded ? 'Trailing Content᠎' : 'Trailing Content'));
const trailing = run(swap);
if (trailing) lines.push(`.trailingContent ${block(trailing.code, 0, ' isExpanded in')}`);

export default {
  id: 'Accordion',
  imports: ['import Montage'],
  example: figma.code`${lines.join('\n')}`,
  metadata: { nestable: true },
};
