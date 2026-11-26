// url=<FIGMA_LIST_CELL_TRAILING_VALUE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Trailing.value

// [2026-11-16] 근거: ListCell.swift Trailing.value(_ text:)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { text } from '../shared/d-util';

export default iosPart('ListCell.Resource.Trailing.value', 'trailing', `.value("${text('Text', '값')}")`);
