// url=<FIGMA_LIST_CELL_LEADING_RADIO>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Leading.radio

// [2026-11-16] 근거: ListCell.swift L768(Leading.radio(checked:onSelect:)). onSelect는 기본 nil이라 생략.
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, variantOf } from '../shared/d-util';

const state = variantOf(findFirst(I, ['Radio']), 'State');
export default iosPart('ListCell.Resource.Leading.radio', 'leading', `.radio(checked: ${state === 'Checked'})`);
