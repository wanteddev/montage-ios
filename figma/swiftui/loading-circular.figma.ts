// url=<FIGMA_LOADING_CIRCULAR>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/5%20Loading/Loading.swift
// component=Loading

// [2026-11-16] 근거: Loading.swift Kind .wanted / .circular(color:), init(kind:size:).
// Figma 'Animate'는 미리보기용 variant라 코드에 대응값이 없다.
import figma from 'figma';

const code = 'Montage.Loading(kind: .circular())';

export default { id: 'Loading', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
