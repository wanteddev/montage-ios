// url=<FIGMA_LIST_CELL_LEADING_CHECKBOX>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Leading.checkbox

// [2026-11-16] 근거: ListCell.swift L762(Leading.checkbox(checked:onSelect:)). onSelect는 기본 nil이라 생략. Indeterminate case는 없어 slot으로 쓴다.
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, variantOf } from '../shared/d-util';

const state = variantOf(findFirst(I, ['Checkbox']), 'State');
// Indeterminate는 .checkbox case가 없어 .slot { Montage.Checkbox(state: .indeterminate) }로 쓴다(ListCell.swift L787, 2026-11-16 김삼열 님 검수).
export default iosPart(
  'ListCell.Resource.Leading.checkbox',
  'leading',
  state === 'Indeterminate'
    ? '.slot {\n    Montage.Checkbox(state: .indeterminate)\n}'
    : `.checkbox(checked: ${state === 'Checked'})`,
);
