// url=<FIGMA_ICON_BUTTON_BACKGROUND>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/IconButton.swift
// component=IconButton

// [2026-11-16] .background(size: Int = 32, isAlternative:) — Figma에 크기 속성이 없어 기본 32를 쓴다.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const alt = I.getBoolean('Alternative') === true;
const variant = alt ? '.background(isAlternative: true)' : '.background()';
let code = `Montage.IconButton(variant: ${variant}, icon: ${iconRef('Icon')})${action}`;
if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';

export default { id: 'IconButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
