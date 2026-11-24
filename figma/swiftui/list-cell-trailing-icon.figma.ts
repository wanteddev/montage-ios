// url=<FIGMA_LIST_CELL_TRAILING_ICON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Trailing.icon

// [2026-11-16] 근거: ListCell.swift L802-805(Trailing.icon, 기본 색 foregroundNeutralSecondary)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { iosIconAt } from '../shared/d-util';

export default iosPart('ListCell.Resource.Trailing.icon', 'trailing', `.icon(${iosIconAt('Icons')})`);
