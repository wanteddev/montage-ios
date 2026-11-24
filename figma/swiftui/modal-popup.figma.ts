// url=<FIGMA_MODAL_POPUP>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/8%20Presentation/Popup.swift
// component=Popup

// [2026-11-16] 근거: Popup.swift L39-45(Resize .hug/.fixed), L422-441(View.popup(isPresented:resize:…:navigation:actionArea:_:)).
// Modal/Popup은 딤·safe area만 더하고 본체는 'Modal'(Modal/Resource/Modal) 레이어다. 본체의 Navigation·Action을 읽는다.
// Action Area의 버튼 문구는 Action Area 인스턴스 쪽 Code Connect를 따른다(여기선 자리만 표시).
import figma from 'figma';

import { find } from '../shared/e-nav';
import { renderIosPopup } from '../shared/e-popup';

const code = renderIosPopup(find(figma.selectedInstance, 'Modal') ?? figma.selectedInstance);

export default { id: 'Popup', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
