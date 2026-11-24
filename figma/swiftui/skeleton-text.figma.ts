// url=<FIGMA_SKELETON_TEXT>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/5%20Loading/Skeleton.swift
// component=Skeleton.SkeletonView

// [2026-11-16] 근거: Skeleton.swift L45-50(Align), L125-129(.text(variant:alignment:cornerRadius:)), L276(.color).
// iOS 텍스트 스켈레톤은 뷰 높이와 variant lineHeight로 줄 수·줄 길이를 자동 계산한다(첫 줄 100%).
// Figma 'Length'(100/75/50/25%)는 지정할 인자가 없어 주석으로만 남긴다. variant는 대체할 텍스트의 타이포로 채운다.
import figma from 'figma';

const I = figma.selectedInstance;
const align = I.getEnum('Align', { Leading: '', Center: '.center', Trailing: '.trailing' });
const length = String(I.getPropertyValue('Length') ?? '100%');
const white = I.getPropertyValue('Color') === 'White';

const args = ['variant: <#Typography.Variant#>'];
if (align) args.push(`alignment: ${align}`);
let code = length !== '100%' ? `// iOS는 줄 길이를 자동 계산합니다(Figma Length ${length} 지정 불가).\n` : '';
code += `Montage.Skeleton.SkeletonView(.text(${args.join(', ')}))`;
if (white) code += '\n.color(.semantic(.staticWhite).opacity(.opacity28))';

export default { id: 'Skeleton.SkeletonView', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
