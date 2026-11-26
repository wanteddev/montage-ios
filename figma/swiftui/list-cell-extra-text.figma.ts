// url=<FIGMA_LIST_CELL_EXTRA_CONTENT_TEXT>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Extra.text

// [2026-11-16] 근거: ListCell.swift Extra.text(_ text:). Figma 파트에 TEXT 속성이 없어 안쪽 텍스트 레이어 내용을 읽는다.
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { esc, I, safe } from '../shared/d-util';

const layers = (safe(() => I.findLayers((n: { type: string }) => n.type === 'TEXT')) ?? []) as Array<{ textContent?: string }>;
const value = esc(layers[0]?.textContent ?? '설명');
export default iosPart('ListCell.Resource.Extra.text', 'extra', `.text("${value}")`);
