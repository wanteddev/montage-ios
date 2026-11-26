// url=<FIGMA_FALLBACK_VIEW_ACTION_AREA_DESKTOP>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/7%20Feedback/FallbackView.swift
// component=FallbackView.ButtonActionArea

// [2026-11-16] 근거: FallbackView.swift ButtonActionArea single·horizontal·vertical(버튼은 항상 Outlined·Assistive), buttonActionArea.
// Fallback View 안 'Action Area' 파트. Desktop/Mobile 구분은 iOS에 없다(같은 표기).
import figma from 'figma';

import { iosButtonActionArea, readButtons } from '../shared/d-fallback';
import { I, indent } from '../shared/d-util';

const buttons = readButtons(I);
const code = buttons ? iosButtonActionArea(buttons) : '.single(.init(text: "액션", action: {\n    // action\n}))';

export default {
  id: 'FallbackView.ButtonActionArea',
  imports: ['import Montage'],
  example: figma.code`${`.buttonActionArea(\n    ${indent(code, 4)}\n)`}`,
  metadata: { nestable: true, props: { code } },
};
