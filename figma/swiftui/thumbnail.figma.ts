// url=<FIGMA_THUMBNAIL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/Thumbnail.swift
// component=Thumbnail

// [2026-11-16] 근거: Thumbnail.swift L61-96(Ratio r21x9…r9x21), L143(init(urlString:ratio:)), L159(.radius), L170(.border).
// 비율은 안쪽 'Ratio' 인스턴스의 Aspect Ratio에서 읽는다. iOS Thumbnail에는 overlay API가 없어
// Overlay=Playtime이면 SwiftUI .overlay로 PlayBadge를 얹는 형태로 쓴다(Custom은 주석만).
import figma from 'figma';

import { flag, flagOf, variantOf } from '../shared/a-util';

const I = figma.selectedInstance;
const safe = <T>(fn: () => T): T | undefined => { try { return fn(); } catch { return undefined; } };
const ok = (n: unknown) => !!n && (n as { type?: string }).type !== 'ERROR';

const RATIO: Record<string, string> = {
  '21:9': '.r21x9', '2:1': '.r2x1', '16:9': '.r16x9', '1.618:1': '.r1_618x1', '16:10': '.r16x10',
  '3:2': '.r3x2', '4:3': '.r4x3', '5:4': '.r5x4', '1:1': '.r1x1', '4:5': '.r4x5', '3:4': '.r3x4',
  '2:3': '.r2x3', '10:16': '.r10x16', '1:1.618': '.r1x1_618', '9:16': '.r9x16', '1:2': '.r1x2', '9:21': '.r9x21',
};
const ratioLayer = safe(() => I.findInstance('Ratio'));
const ratioName = ok(ratioLayer) ? variantOf(ratioLayer as never, 'Aspect Ratio') : undefined;
const ratio = (ratioName && RATIO[ratioName]) || '.r1x1';

let code = `Montage.Thumbnail(urlString: imageUrl, ratio: ${ratio})`;
if (flag('Radius')) code += '\n.radius()';
if (flag('Border')) code += '\n.border()';
if (flag('Overlay')) {
  const swap = safe(() => I.getInstanceSwap('┗ Instance'));
  const play = ok(swap) ? safe(() => swap!.findInstance('Playtime')) : undefined;
  if (ok(play)) {
    const sz = variantOf(play as never, 'Size');
    let badge = 'Montage.PlayBadge()';
    if (sz === 'Small') badge += '\n        .size(.small)';
    if (sz === 'Large') badge += '\n        .size(.large)';
    if (flagOf(play as never, 'Alternative')) badge += '\n        .alternative()';
    code += `\n.overlay {\n    ${badge}\n}`;
  } else {
    code += '\n// 오버레이(Custom)는 .overlay { … }로 직접 얹습니다.';
  }
}

export default { id: 'Thumbnail', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
