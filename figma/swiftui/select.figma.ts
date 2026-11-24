// url=<FIGMA_SELECT>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Select.swift
// component=Select

// [2026-11-16] 근거: Select.swift L37(Variant .single/.multiple), L141(init), L169 .size, L178 .status, L187 .placeholder,
// L202 .leading(L723 Resource.Leading icon/iconButton/slot). Render=Chip은 .multiple(render: .chip)로만 표현된다.
import figma from 'figma';

import { iosSelect } from '../shared/c-input';

const code = iosSelect(figma.selectedInstance);

export default { id: 'Select', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
