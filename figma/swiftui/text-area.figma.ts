// url=<FIGMA_TEXT_AREA>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/TextArea.swift
// component=TextArea

// [2026-11-16] 근거: TextArea.swift L238(init), L270 .size, L280 .resize(L59 Resize), L350 .negative,
// L366 .bottomResources(L87-226 Resource.Leading/Trailing), L385 .placeholder. Bottom의 Leading/Trailing Content Type을 Resource case로 옮긴다.
import figma from 'figma';

import { iosTextArea } from '../shared/c-input';

const code = iosTextArea(figma.selectedInstance);

export default { id: 'TextArea', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
