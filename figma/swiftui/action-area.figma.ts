// url=<FIGMA_ACTION_AREA>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/ActionArea.swift
// component=ActionArea

// [2026-11-16] 근거: ActionArea.swift L48(init variant:), L192-208(Variant strong/neutral(main:sub:alternative:)·cancel(main:)),
// L231(ButtonInfo init text:action:), L155(caption(_:icon:), strong·neutral만 표시 L209-214), L168(extra(_:divider:), divider 기본 true).
// Compact (Web Only)는 iOS case가 없어 strong으로 쓰고 주석. 버튼 비활성·로딩은 ButtonInfo.custom { }(L242)으로 Button을 직접 넣는다(2026-11-16 김삼열 님 검수). main 기본 버튼은 primary solid large + fillWidth(L392-401).
import figma from 'figma';

import { readActionArea } from '../shared/d-action-area';
import { block, indent, iosIconOf } from '../shared/d-util';

const a = readActionArea();
const info = (label: string) => `.init(text: "${label}", action: ${block('// action')})`;
const notes: string[] = [];
const kind = ({ Neutral: 'neutral', Cancel: 'cancel' } as Record<string, string>)[a.variant] ?? 'strong';
if (a.variant.startsWith('Compact')) notes.push('// Compact는 Web 전용이라 iOS에서는 .strong으로 표시됩니다.');
const mainInfo = (): string => {
  if (!a.main.disabled && !a.main.loading) return info(a.main.label);
  const mods = ['.fillWidth(true)'];
  if (a.main.loading) mods.push('.loading(true)');
  if (a.main.disabled) mods.push('.disabled(true)');
  return `.custom ${block(`Montage.Button(text: "${a.main.label}") ${block('// action')}\n${mods.join('\n')}`)}`;
};

const parts = [`main: ${mainInfo()}`];
if (kind !== 'cancel') {
  if (a.sub) parts.push(`sub: ${info(a.sub)}`);
  if (a.alternative) parts.push(`alternative: ${info(a.alternative)}`);
} else if (a.sub || a.alternative) {
  notes.push('// .cancel은 main 버튼만 표시합니다.');
}
const lines = [
  ...notes,
  `Montage.ActionArea(variant: .${kind}(\n    ${parts.map((p) => indent(p, 4)).join(',\n    ')}\n))`,
];
if (a.caption && kind !== 'cancel') {
  const icon = a.captionIcon !== undefined ? `, icon: ${a.captionIcon ? iosIconOf(a.captionIcon) : '.circleInfo'}` : '';
  lines.push(`.caption("${a.caption}"${icon})`);
}
if (a.extra) {
  const content = block('// 추가 콘텐츠');
  lines.push(a.divider ? `.extra ${content}` : `.extra(${content}, divider: false)`);
}
export default {
  id: 'ActionArea',
  imports: ['import Montage'],
  example: figma.code`${lines.join('\n')}`,
  metadata: { nestable: true },
};
