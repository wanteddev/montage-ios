// url=<FIGMA_RADIO>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Radio.swift
// component=Radio

// [2026-11-16] Radio.swift L41-45(init checked:), L65(.label), L103(.tight). controlled.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const checked = I.getPropertyValue('State') === 'Checked';
const size = I.getEnum('Size', { Medium: '.medium', Small: '.small' });
const args = [`checked: ${checked}`];
if (size !== '.medium') args.push(`size: ${size}`);

let code = `Montage.Radio(${args.join(', ')}) { isChecked in\n    // checked = isChecked\n}`;
if (safeBool('Label')) code += `\n.label("${I.getString('┗ Text​')}")`;
if (I.getBoolean('Tight') === true) code += '\n.tight()';
if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';

function safeBool(name: string): boolean {
  try { return I.getBoolean(name) === true; } catch { return false; }
}

export default { id: 'Radio', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
