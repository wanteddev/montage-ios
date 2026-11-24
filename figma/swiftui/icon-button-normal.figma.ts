// url=<FIGMA_ICON_BUTTON_NORMAL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/IconButton.swift
// component=IconButton

// [2026-11-16] IconButton.swift L58-62(init), L371(Variant), L95/L162/L123(modifier). normal 전용 modifier만 여기서 붙인다.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const size = I.getEnum('Size', { Xlarge: '.xlarge', Large: '.large', Medium: '.medium', Small: '.small' });
const args: string[] = [];
if (size !== '.xlarge') args.push(`variant: .normal(size: ${size})`);
args.push(`icon: ${iconRef('Icon')}`);

let code = `Montage.IconButton(${args.join(', ')})${action}`;
const effect = I.getEnum('Interaction Effect', { Highlight: '', Dim: '.dim', None: '.none' });
if (effect) code += `\n.interactionEffect(${effect})`;
if (I.getBoolean('Interaction Overflow') === true) code += '\n.interactionOverflow()';
if (I.getPropertyValue('Badge') === true) code += '\n.showPushBadge()';
if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';

export default { id: 'IconButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
