// url=<FIGMA_ICON_BUTTON_SOLID>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/IconButton.swift
// component=IconButton

// [2026-11-16] .solid(size: Size) — Size .small/.medium (IconButton.swift IconButton.Size).
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const size = I.getEnum('Size', { Medium: '.medium', Small: '.small' });
let code = `Montage.IconButton(variant: .solid(size: ${size}), icon: ${iconRef('Icon')})${action}`;
if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';

export default { id: 'IconButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
