// url=<FIGMA_LIST_CELL_TRAILING_SWITCH>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Trailing.switch

// [2026-11-16] 근거: ListCell.swift L845(Trailing.switch(checked:onSelect:)). onSelect는 기본 nil이라 생략.
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, flagOf, I } from '../shared/d-util';

const on = flagOf(findFirst(I, ['Switch']), 'Active');
export default iosPart('ListCell.Resource.Trailing.switch', 'trailing', `.switch(checked: ${on})`);
