// url=<FIGMA_TEXT_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/TextButton.swift
// component=TextButton

// [2026-11-16] TextButton.swift L55-62(init), L145(.loading). Button 검수 규칙 적용.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const color = I.getEnum('Color', { Primary: '.primary', Assistive: '.assistive' });
const size = I.getEnum('Size', { Small: '.small', Medium: '.medium' });
const args: string[] = [];
if (color !== '.primary') args.push(`color: ${color}`);
if (size !== '.medium') args.push(`size: ${size}`);
args.push(`text: "${I.getString('Label')}"`);
if (I.getBoolean('Leading Icon') === true) args.push(`leadingIcon: ${iconRef('Leading Icon')}`);
if (I.getBoolean('Trailing Icon') === true) args.push(`trailingIcon: ${iconRef('Trailing Icon')}`);

let code = `Montage.TextButton(${args.join(', ')})${action}`;
if (I.getBoolean('Loading') === true) code += '\n.loading(true)';
if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';

export default { id: 'TextButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
