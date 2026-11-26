// url=<FIGMA_PAGE_COUNTER>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/PageCounter.swift
// component=PageCounter

// [2026-11-16] PageCounter.swift init selectedPage·totalPages(1부터), .size(기본 .medium), .alternative.
// 표시 전용이라 Figma 값을 .constant로 보여 준다(실사용은 페이지 상태 바인딩).
import figma from 'figma';

import { intFrom } from '../shared/b-items';

const I = figma.selectedInstance;
const current = intFrom(I.getString('Current Page'), 1);
const total = intFrom(I.getString('Total Page'), 10);
const size = I.getEnum('Size', { Small: '.small', Medium: '' });

let code = `Montage.PageCounter(selectedPage: .constant(${current}), totalPages: ${total})`;
if (size) code += `\n.size(${size})`;
if (I.getEnum('Alternative', { True: true, False: false }) === true) code += '\n.alternative()';

export default { id: 'PageCounter', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
