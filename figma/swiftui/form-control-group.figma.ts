// url=<FIGMA_FORM_CONTROL_GROUP>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/FormControlGroup.swift
// component=FormControlGroup

// [2026-11-16] 근거: FormControlGroup.swift init(labelWidth: CGFloat? = nil, spacing: = .spacing16, content:).
// Label Width=Longest는 자동 측정(labelWidth 생략), Fixed는 labelWidth 지정(값은 Figma에서 읽지 않아 플레이스홀더).
// 안의 Form Control은 슬롯('Slot')에 연결된 인스턴스의 템플릿 결과를 그대로 쌓는다.
import figma from 'figma';

import { block, I, run, safe } from '../shared/d-util';

const fixed = I.getPropertyValue('Label Width') === 'Fixed';
const slot = safe(() => I.getSlot('Slot')) as { connectedInstances?: unknown[] } | undefined;
const items = (slot && slot.connectedInstances) || [];
const rows = items
  .map((it) => run(it as Parameters<typeof run>[0]))
  .filter((r): r is NonNullable<typeof r> => !!r)
  .map((r) => r.code);

const head = fixed ? 'Montage.FormControlGroup(labelWidth: <#라벨 폭#>) ' : 'Montage.FormControlGroup ';
const body = rows.length ? rows.join('\n\n') : '// FormControl 또는 입력 컴포넌트';
const code = (head + block(body)).replace(/\n +\n/g, '\n\n');

export default {
  id: 'FormControlGroup',
  imports: ['import Montage'],
  example: figma.code`${code}`,
  metadata: { nestable: true },
};
