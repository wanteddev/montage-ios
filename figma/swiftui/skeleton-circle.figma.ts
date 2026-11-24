// url=<FIGMA_SKELETON_CIRCLE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/5%20Loading/Skeleton.swift
// component=Skeleton.SkeletonView

// [2026-11-16] 근거: Skeleton.swift L158(Kind), L207(SkeletonView init), L276(.color).
// Color=White는 Web과 같은 Static White 28%로 표기(Avatar.swift L308의 .opacity(.opacity28) 방식).
// 다른 뷰를 가릴 때는 View.skeleton(isPresented:kind:color:opacity:size:) (L397)를 쓴다.
import figma from 'figma';

const I = figma.selectedInstance;
const white = I.getPropertyValue('Color') === 'White';
let code = 'Montage.Skeleton.SkeletonView(.circle)';
if (white) code += '\n.color(.semantic(.staticWhite).opacity(.opacity28))';

export default { id: 'Skeleton.SkeletonView', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
