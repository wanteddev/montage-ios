// url=<FIGMA_LIST_CELL_LABEL_TRAILING_CONTENT_BADGE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.LabelTrailing.contentBadge

// [2026-11-16] 근거: ListCell.swift LabelTrailing.contentBadge(_ variant:title:) (variant 기본 .solid). 색·크기는 요소가 정한다(Figma Color 미반영).
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, textOf, variantOf } from '../shared/d-util';

const badge = findFirst(I, ['Content Badge/Content Badge', 'Content Badge']);
const args = [`title: "${textOf(badge, 'Text', '텍스트')}"`];
if (variantOf(badge, 'Variant') === 'Outlined') args.unshift('.outlined');
export default iosPart('ListCell.Resource.LabelTrailing.contentBadge', 'labelTrailing', `.contentBadge(${args.join(', ')})`);
