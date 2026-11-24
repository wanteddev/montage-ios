// url=<FIGMA_MODAL_FULL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/8%20Presentation/BottomSheet.swift
// component=BottomSheet

// [2026-11-16] iOS에는 전용 Full 모달 타입이 없고, 전체 화면 모달은 bottomSheet(isFullScreenCover: true)다
// (BottomSheet.swift L463-472: fullScreenCover + resize(.fill) + 핸들 없음 + modalKind .full).
// Navigation은 Modal/Full/Resource/Navigation 인스턴스에서 읽는다(ModalNavigation.swift: .normal은 전체 화면 모달 전용).
import figma from 'figma';

import { renderIosModalNav } from '../shared/e-modal';
import { bool, find, ok } from '../shared/e-nav';
import { iosActionArea, iosClosureArg, iosModifierCall } from '../shared/e-popup';

const I = figma.selectedInstance;
const args = ['isPresented: $isPresented', 'isFullScreenCover: true'];
const nav = find(I, 'Navigation');
if (ok(nav)) args.push(iosClosureArg('navigation', renderIosModalNav(nav)));
if (bool(I, 'Action') === true) args.push(iosClosureArg('actionArea', iosActionArea(I)));

const code = iosModifierCall('bottomSheet', args);

export default { id: 'BottomSheet', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
