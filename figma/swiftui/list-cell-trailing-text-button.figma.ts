// url=<FIGMA_LIST_CELL_TRAILING_TEXT_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Trailing.textButton

// [2026-11-16] 근거: ListCell.swift Trailing.textButton(title:color:handler:) (color 기본 .assistive)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, textOf, variantOf } from '../shared/d-util';

const button = findFirst(I, ['Text Button/Text Button', 'Text Button']);
const args = [`title: "${textOf(button, 'Label', '텍스트')}"`];
if (variantOf(button, 'Color') === 'Primary') args.push('color: .primary');
export default iosPart('ListCell.Resource.Trailing.textButton', 'trailing', `.textButton(${args.join(', ')})`);
