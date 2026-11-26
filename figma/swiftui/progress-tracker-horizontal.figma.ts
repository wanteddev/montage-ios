// url=<FIGMA_PROGRESS_TRACKER_HORIZONTAL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/ProgressTracker.swift
// component=ProgressTracker

// [2026-11-16] ProgressTracker.swift .horizontal(labels:), init progress 1부터·variant. 빈 라벨은 그리지 않는다(body의 labels[index].isEmpty 분기).
// 표시 전용이라 진행 단계를 .constant로 보여 준다.
import figma from 'figma';

import { swiftList } from '../shared/b-items';

const I = figma.selectedInstance;
const total = I.getEnum('Total Count', { '3': 3, '4': 4, '5': 5 }) ?? 3;
const step = I.getEnum('Current Step', { '1': 1, '2': 2, '3': 3, '4': 4, '5': 5 }) ?? 1;
const showLabel = I.getBoolean('Label') === true;

const labels = Array.from({ length: total }, (_, n) => (showLabel ? I.getString(`Label ${n + 1}`) : ''));
const labelCode = showLabel ? swiftList(labels) : `Array(repeating: "", count: ${total})`;

const code = `Montage.ProgressTracker(\n    progress: .constant(${step}),\n    variant: .horizontal(labels: ${labelCode})\n)`;

export default { id: 'ProgressTracker', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
