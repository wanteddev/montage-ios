// url=<FIGMA_LIST_CELL_LEADING_ICON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Leading.icon

// [2026-11-16] 근거: ListCell.swift L744-747(Leading.icon, 기본 색 foregroundNeutralTertiary)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { iosIconAt } from '../shared/d-util';

export default iosPart('ListCell.Resource.Leading.icon', 'leading', `.icon(${iosIconAt('Icon')})`);
