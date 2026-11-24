// url=<FIGMA_MODAL_POPUP_CONTAINER>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/8%20Presentation/Popup.swift
// component=Popup

// [2026-11-16] 근거: Popup.swift L39-45(Resize), L422-441(View.popup). Modal/Resource/Modal(Popup 본체)를 단독으로 쓴 경우.
// Size(Medium·Large·XLarge)는 iOS에 대응 축이 없다.
import figma from 'figma';

import { renderIosPopup } from '../shared/e-popup';

const code = renderIosPopup(figma.selectedInstance);

export default { id: 'Popup', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
