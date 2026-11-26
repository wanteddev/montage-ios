// url=<FIGMA_FRAMED_STYLE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/FramedStyle.swift
// component=framedStyle

// [2026-11-16] 근거: FramedStyle.swift Status normal/selected/negative, framedStyle(status:borderRadius:shadowLevel:),
// Shadow.swift Level .none/.xsmall…. Figma Frame 반경은 14(변수 바인딩), 코드 기본값은 0이라 .radius14를 넘긴다.
// Figma Shadow(기본 false)=꺼짐 → .none, 켜짐 → 코드 기본 .xsmall(Figma 효과 스타일 Shadow styles/Normal/XSmall)이라 생략.
import figma from 'figma';

import { on, prop } from '../shared/c-input';

const I = figma.selectedInstance;
const negative = prop(I, 'Status') === 'Negative';
const selected = on(I, 'Selected');
const args: string[] = [];
let note = '';
if (negative) {
  args.push('status: .negative');
  if (selected) note = '// Status는 하나만 지정할 수 있어 Negative를 우선합니다.\n';
} else if (selected) args.push('status: .selected');
args.push('borderRadius: .radius14');
if (!on(I, 'Shadow')) args.push('shadowLevel: .none');

let code = `${note}<#콘텐츠 뷰#>\n.framedStyle(${args.join(', ')})`;
if (on(I, 'Disabled')) code += '\n.disabled(true)';

export default { id: 'framedStyle', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
