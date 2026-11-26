// url=<FIGMA_MODAL_BOTTOM_SHEET>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/8%20Presentation/BottomSheet.swift
// component=BottomSheet

// [2026-11-16] 근거: BottomSheet.swift Resize .hug/.fixedRatio/.fixedHeight/.flexible/.fill,
// View.bottomSheet(isPresented:isFullScreenCover:needHandle:resize:…:navigation:actionArea:onDismiss:_:),
// isFullScreenCover → fullScreenCover + resize(.fill) + 핸들 없음 + modalKind .full.
// Resize=Fill + Platform=iOS는 iOS의 전체 화면 모달(isFullScreenCover)이다(2026-09-28 Modal iOS QA 확인).
// Navigation은 Contents 슬롯 안에 놓이므로 여기서 읽지 않는다(Modal Navigation 인스턴스의 Code Connect 참고).
import figma from 'figma';

import { bool, prop } from '../shared/e-nav';
import { iosActionArea, iosClosureArg, iosModifierCall } from '../shared/e-popup';

const I = figma.selectedInstance;
const platform = prop(I, 'Platform');
const resize = String(prop(I, 'Resize') ?? 'Hug');
const args = ['isPresented: $isPresented'];
if (resize === 'Fill' && platform === 'iOS') args.push('isFullScreenCover: true');
else if (resize === 'Flexible') args.push('resize: .flexible');
else if (resize === 'Fill') args.push('resize: .fill');
else if (resize === 'Fixed') args.push('resize: .fixedHeight(<#높이#>)');
if (bool(I, 'Action') === true) args.push(iosClosureArg('actionArea', iosActionArea(I)));

const code = iosModifierCall('bottomSheet', args);

export default { id: 'BottomSheet', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
