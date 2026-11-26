// url=<FIGMA_PAGINATION_DOTS>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/PaginationDots.swift
// component=PaginationDots

// [2026-11-16] PaginationDots.swift init selectedPage 1부터·totalPages, .variant, .size: .normal 기본·.small.
// totalPages는 Figma에서 켠 점 개수, selectedPage는 Active 점 위치. 표시 전용이라 .constant로 보여 준다.
import figma from 'figma';

import { readDots } from '../shared/b-dots';

const I = figma.selectedInstance;
const { total, index } = readDots();
const variant = I.getEnum('Variant', { Normal: '', White: '.white' });
const size = I.getEnum('Size', { Small: '.small', Medium: '' });

let code = `Montage.PaginationDots(selectedPage: .constant(${index + 1}), totalPages: ${total})`;
if (variant) code += `\n.variant(${variant})`;
if (size) code += `\n.size(${size})`;

export default { id: 'PaginationDots', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
