// url=<FIGMA_ACCORDION_TRAILING_ICON_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/Accordion.swift
// component=Accordion.trailingContent

// [2026-11-16] 근거: Accordion.swift L287(trailingContent { isExpanded in }). 안쪽 Icon Button의 IconButton 템플릿 결과를 그대로 쓴다.
import figma from 'figma';

import { block, I, run, safe } from '../shared/d-util';

const inner = run(safe(() => I.findInstance('Icon Button')));
const code = inner?.code ?? '// 콘텐츠';

export default {
  id: 'Accordion.trailingContent',
  imports: ['import Montage'],
  example: figma.code`${`.trailingContent ${block(code, 0, ' isExpanded in')}`}`,
  metadata: { nestable: true, props: { code } },
};
