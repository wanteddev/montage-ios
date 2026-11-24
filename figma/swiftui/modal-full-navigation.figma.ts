// url=<FIGMA_MODAL_FULL_NAVIGATION>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/9%20Utilities/ModalNavigation.swift
// component=ModalNavigation

// [2026-11-16] Full 전용(Normal·Emphasized·Floating·Search). 근거: ModalNavigation.swift L50-88(Variant), L237(title), L259(leading), L271-285(trailings),
// L294(iconButtonBackground), L310(searchField), L564-627(Resource.Leading/Trailing).
// Figma Tool Bar(Tab·Segmented Control)는 iOS에 슬롯이 없어 주석으로 남긴다. Background 속성은 대응 API가 없다(스크롤로 자동).
import figma from 'figma';

import { renderIosModalNav } from '../shared/e-modal';

const code = renderIosModalNav(figma.selectedInstance);

export default { id: 'ModalNavigation', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
