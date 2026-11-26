// url=<FIGMA_LIST_CELL_TRAILING_ICON_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Trailing.iconButton

// [2026-11-16] 근거: ListCell.swift Trailing.iconButton(_ icon:handler:). handler는 기본 nil이라 생략.
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, iosIconOf, safe } from '../shared/d-util';

const button = findFirst(I, ['Icon Button']);
const icon = iosIconOf(safe(() => button.findInstance('Icon')));
export default iosPart('ListCell.Resource.Trailing.iconButton', 'trailing', `.iconButton(${icon})`);
