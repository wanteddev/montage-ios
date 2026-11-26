// url=<FIGMA_PROGRESS_TRACKER_VERTICAL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/ProgressTracker.swift
// component=ProgressTracker

// [2026-11-16] ProgressTracker.swift .vertical(stepContents:), init progress 1부터, VerticalStepContent label·labelAccessoryView·contentView.
// Figma 슬롯(Label Content·Content)의 내용은 읽지 않고 Xcode 자리표시로 둔다. 진행 단계는 .constant로 보여 준다.
import figma from 'figma';

import { swiftStr } from '../shared/b-items';

const I = figma.selectedInstance;
const total = I.getEnum('Total Count', { '3': 3, '4': 4, '5': 5 }) ?? 3;
const step = I.getEnum('Current Step', { '1': 1, '2': 2, '3': 3, '4': 4, '5': 5 }) ?? 1;
const showLabel = I.getBoolean('Label') === true;
const showAccessory = showLabel && I.getBoolean('┗ Show Label Content') === true;
const showContent = I.getBoolean('Show Content') === true;

const pad = '        ';
const contents = Array.from({ length: total }, (_, n) => {
  const args: string[] = [];
  if (showLabel) args.push(`label: ${swiftStr(I.getString(`Label ${n + 1}`))}`);
  if (showAccessory) args.push(`labelAccessoryView: {\n${pad}        <#라벨 보조 뷰#>\n${pad}    }`);
  if (showContent) args.push(`contentView: {\n${pad}        <#콘텐츠#>\n${pad}    }`);
  if (args.length === 0) return '.init()';
  if (args.length === 1 && !args[0].includes('\n')) return `.init(${args[0]})`;
  return `.init(\n${pad}    ${args.join(`,\n${pad}    `)}\n${pad})`;
});

const code = `Montage.ProgressTracker(\n    progress: .constant(${step}),\n    variant: .vertical(stepContents: [\n${pad}${contents.join(`,\n${pad}`)}\n    ])\n)`;

export default { id: 'ProgressTracker', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
