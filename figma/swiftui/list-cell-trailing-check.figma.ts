// url=<FIGMA_LIST_CELL_TRAILING_CHECK>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.selected

// [2026-11-16] 근거: ListCell.swift selected: trailing 요소가 없을 때만 체크 아이콘. 요소 case는 없다.
import figma from 'figma';

import { checkPart } from '../shared/d-list-cell';

export default checkPart('ListCell.selected', 'ios');
