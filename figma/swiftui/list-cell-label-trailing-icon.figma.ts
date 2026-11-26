// url=<FIGMA_LIST_CELL_LABEL_TRAILING_VERIFIED_CHECK>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.LabelTrailing.icon

// [2026-11-16] 근거: ListCell.swift LabelTrailing.icon(기본 색 surfaceBrandPrimary)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { iosIconAt } from '../shared/d-util';

export default iosPart('ListCell.Resource.LabelTrailing.icon', 'labelTrailing', `.icon(${iosIconAt('Icon/Normal/Verified Check')})`);
