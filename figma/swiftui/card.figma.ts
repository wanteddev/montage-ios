// url=<FIGMA_CARD>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/Card.swift
// component=Card

// [2026-11-16] 근거: Card.swift L43-53(init thumbnail:skeleton:title:), L69-89(caption·subCaption·extraCaption),
// L103-116(overlay caption:buttonIcon:), L121-136(top/bottomContent). Platform(Desktop/Mobile)은 iOS API가 없어 반영하지 않는다.
// 썸네일은 안쪽 Thumbnail 인스턴스 템플릿을 그대로 쓴다(없으면 기본 표기).
import figma from 'figma';

import { thumbnailCode, wrapperContents } from '../shared/d-card';
import { block, findFirst, flag, I, indent, iosHStack, iosIconOf, safe, text } from '../shared/d-util';

const thumb = thumbnailCode() ?? 'Montage.Thumbnail(urlString: imageUrl, ratio: .r4x3)';
const thumbArg = thumb.includes('\n') ? `thumbnail: ${block(thumb, 4)}` : `thumbnail: { ${thumb} }`;
const skeleton = flag('Skeleton');

const lines: string[] = [];
if (skeleton) lines.push('// Skeleton=True: isLoading이 true인 동안 스켈레톤으로 표시됩니다.');
lines.push(`Montage.Card(\n    ${indent(thumbArg, 0)},\n    skeleton: $isLoading,\n    title: "${text('Title', '제목')}"\n)`);
if (flag('Caption')) lines.push(`.caption("${text('┗ Text', '캡션')}")`);
if (flag('Sub Caption')) lines.push(`.subCaption("${text('\u2517 Text\u180E\u180E\u180E', '보조 캡션')}")`);
if (flag('Extra Caption')) lines.push(`.extraCaption("${text('\u2517 Text\u180E\u180E', '추가 캡션')}")`);

if (flag('Thumbnail Overlay')) {
  const args: string[] = [];
  if (flag('┗ Overlay Caption')) args.push(`caption: "${text('\u3164\u2517 Text', '오버레이 캡션')}"`);
  if (flag('Toggle Icon')) {
    const toggle = findFirst(I, ['Toggle Icon']);
    const icon = findFirst(toggle, ['Icon/Normal/Bookmark', 'Icon']) ?? safe(() => toggle.getInstanceSwap('Icon'));
    args.push(`buttonIcon: ${icon ? iosIconOf(icon) : '.bookmark'}`);
  }
  if (args.length) lines.push(`.overlay(${args.join(', ')})`);
}

const slot = (show: string, layer: string, modifier: string) => {
  if (!flag(show)) return;
  const items = wrapperContents(layer, 'ios');
  lines.push(`.${modifier} ${block(iosHStack(items, '.spacing6'))}`);
};
// Figma 슬롯 간격: Top·Bottom 6.
slot('Show Top Content', 'Top Content', 'topContent');
slot('Show Bottom Content', 'Bottom Content', 'bottomContent');

export default {
  id: 'Card',
  imports: ['import Montage'],
  example: figma.code`${lines.join('\n')}`,
  metadata: { nestable: true },
};
