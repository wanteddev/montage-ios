// url=<FIGMA_TEXT_FIELD>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/TextField.swift
// component=TextField

// [2026-11-16] 근거: TextField.swift init text:/autoCompletionDataSource:, .size, .status, .placeholder,
// .icon, .trailingButton(TrailingButtonInfo), .trailingContent. 비활성은 표준 .disabled.
// 본문은 shared/c-input.ts (Form Control 템플릿과 공유)
import figma from 'figma';

import { iosTextField } from '../shared/c-input';

const code = iosTextField(figma.selectedInstance);

export default { id: 'TextField', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
