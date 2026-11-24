// url=<FIGMA_LIST_CELL_LEADING_LARGE_ICON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Leading.largeIcon

// [2026-11-16] 근거: ListCell.swift L753-756(Leading.largeIcon, 컨테이너 36 / 아이콘 20)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { iosIconAt } from '../shared/d-util';

export default iosPart('ListCell.Resource.Leading.largeIcon', 'leading', `.largeIcon(${iosIconAt('Icon')})`);
