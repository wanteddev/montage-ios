// url=<FIGMA_PROGRESS_INDICATOR>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/ProgressIndicator.swift
// component=ProgressIndicator

// [2026-11-16] ProgressIndicator.swift L30(init percentage: Binding<CGFloat>, 0.0~1.0). 표시 전용이라 .constant로 보여 준다.
import figma from 'figma';

const I = figma.selectedInstance;
const value = I.getEnum('Percent', { '0%': '0', '50%': '0.5', '100%': '1' });

const code = `Montage.ProgressIndicator(percentage: .constant(${value}))`;

export default { id: 'ProgressIndicator', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
