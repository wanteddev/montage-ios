// url=<FIGMA_LIST_CELL_TRAILING_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Trailing.button

// [2026-11-16] 근거: ListCell.swift Trailing.button(title:color:handler:) (Solid·Small 고정, color 기본 .assistive)
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, textOf, variantOf } from '../shared/d-util';

const button = findFirst(I, ['Button/Button', 'Button']);
const COLOR: Record<string, string> = { Primary: '.primary', Negative: '.negative' };
const color = COLOR[variantOf(button, 'Color') ?? ''];
const args = [`title: "${textOf(button, 'Label', '행동')}"`];
if (color) args.push(`color: ${color}`);
const note = variantOf(button, 'Variant') === 'Outlined'
  ? '// ListCell 버튼 요소는 Solid로 고정이라 Outlined는 Solid로 표시됩니다.'
  : undefined;
export default iosPart('ListCell.Resource.Trailing.button', 'trailing', `.button(${args.join(', ')})`, note);
