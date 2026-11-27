// url=<FIGMA_LIST_CARD>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCard.swift
// component=ListCard

// [2026-11-16] 근거: ListCard.swift init thumbnail:skeleton:title:, caption·extraCaption,
// top/bottom/leading/trailingContent. Platform(Desktop/Mobile)은 iOS API가 없어 반영하지 않는다.
// 'Show \bLeading Content'는 Figma 속성명에 백스페이스 문자(U+0008)가 들어 있다.
import figma from 'figma';

import { thumbnailCode, wrapperContents } from '../shared/d-card';
import { block, flag, iosHStack, text } from '../shared/d-util';

const thumb = thumbnailCode() ?? 'Montage.Thumbnail(urlString: imageUrl, ratio: .r1x1)';
const thumbArg = thumb.includes('\n') ? `thumbnail: ${block(thumb, 4)}` : `thumbnail: { ${thumb} }`;

const lines: string[] = [];
if (flag('Skeleton')) lines.push('// Skeleton=True: isLoading이 true인 동안 스켈레톤으로 표시됩니다.');
lines.push(`Montage.ListCard(\n    ${thumbArg},\n    skeleton: $isLoading,\n    title: "${text('Title', '제목')}"\n)`);
if (flag('Caption')) lines.push(`.caption("${text('┗ Text᠎', '캡션')}")`);
if (flag('Extra Caption')) lines.push(`.extraCaption("${text('┗ Text', '추가 캡션')}")`);

// Figma 슬롯 간격: Top·Bottom 6, Leading·Trailing 8.
const slot = (show: string, layer: string, modifier: string, spacing: string) => {
  if (!flag(show)) return;
  const items = wrapperContents(layer);
  lines.push(`.${modifier} ${block(iosHStack(items, spacing))}`);
};
slot('Show Top Content', 'Top Content', 'topContent', '.spacing6');
slot('Show Bottom Content', 'Bottom Content', 'bottomContent', '.spacing6');
slot('Show \u0008Leading Content', 'Leading Content', 'leadingContent', '.spacing8');
slot('Show Trailing Content', 'Trailing Content', 'trailingContent', '.spacing8');

export default {
  id: 'ListCard',
  imports: ['import Montage'],
  example: figma.code`${lines.join('\n')}`,
  metadata: { nestable: true },
};
