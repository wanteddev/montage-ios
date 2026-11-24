// url=<FIGMA_SLIDER>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Slider.swift
// component=Slider

// [2026-11-16] Slider.swift L53-58(init isRangeSlider·valueRange·labelFormatter·onChanged), L254(.heading), L264(.label).
// iOS는 제목·노브 라벨을 값에서 만든다(labelFormatter) — Figma 텍스트(┗ Label 등)는 코드에 대응 인자가 없다.
// 초기 노브 위치(Percent)를 지정하는 공개 API도 없다. 비활성은 SwiftUI .disabled.
import figma from 'figma';

const I = figma.selectedInstance;
const on = (prop: string): boolean => I.getEnum(prop, { True: true, False: false }) === true;

const range = on('Range');
const percent = I.getEnum('Percent', { '25%': '25%', '50%': '50%', '75%': '75%', '100%': '100%' });

// onChanged는 labelFormatter도 클로저라 trailing closure 대신 레이블로 쓴다.
const args = range ? ['isRangeSlider: true'] : [];
args.push('onChanged: { low, high in\n        // value = low...high\n    }');
let code = `// 초기 위치(Figma Percent=${percent})는 지정할 수 없습니다.\nMontage.Slider(\n    ${args.join(',\n    ')}\n)`;
if (I.getBoolean('Heading') === true) code += '\n.heading()';
if (I.getBoolean('Label') === true) code += '\n.label()';
if (on('Disable')) code += '\n.disabled(true)';

export default { id: 'Slider', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
