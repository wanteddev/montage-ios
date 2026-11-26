// url=<FIGMA_LIST_CELL_LEADING_AVATAR>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ListCell.swift
// component=ListCell.Resource.Leading.avatar

// [2026-11-16] 근거: ListCell.swift Leading.avatar(_ imageUrl:variant:) (40×40 고정 — Figma Avatar Size는 반영하지 않는다).
import figma from 'figma';

import { iosPart } from '../shared/d-list-cell';
import { findFirst, I, variantOf } from '../shared/d-util';

const VARIANT: Record<string, string> = { Person: '.person', Company: '.company', Academy: '.academy' };
const variant = VARIANT[variantOf(findFirst(I, ['Avatar']), 'Variant') ?? ''] ?? '.person';
export default iosPart('ListCell.Resource.Leading.avatar', 'leading', `.avatar(imageUrl, variant: ${variant})`);
