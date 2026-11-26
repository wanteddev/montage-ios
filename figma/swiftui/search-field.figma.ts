// url=<FIGMA_SEARCH_FIELD>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/SearchField.swift
// component=SearchField

// [2026-11-16] 근거: SearchField.swift init text:, .variant(기본 .solid), .size(기본 .large), .placeholder.
import figma from 'figma';

import { on, prop, str, sw } from '../shared/c-input';

const I = figma.selectedInstance;
let code = 'Montage.SearchField(text: $text)';
if (prop(I, 'Variant') === 'Outlined') code += '\n.variant(.outlined)';
if (prop(I, 'Size') === 'Medium') code += '\n.size(.medium)';
code += `\n.placeholder("${sw(str(I, 'Placeholder'))}")`;
if (on(I, 'Disable')) code += '\n.disabled(true)';

export default { id: 'SearchField', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
