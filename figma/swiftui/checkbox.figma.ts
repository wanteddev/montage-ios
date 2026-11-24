// url=<FIGMA_CHECKBOX>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Checkbox.swift
// component=Checkbox

// [2026-11-16] Checkbox.swift L57-61(init state:), L124(.label), L152(.bold), L162(.tight). controlled: onSelect로 받은 값을 다시 넣는다.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const state = I.getEnum('State', { Checked: '.checked', Unchecked: '.unchecked', Indeterminate: '.indeterminate' });
const size = I.getEnum('Size', { Medium: '.medium', Small: '.small' });
const args = [`state: ${state}`];
if (size !== '.medium') args.push(`size: ${size}`);

let code = `Montage.Checkbox(${args.join(', ')}) { newState in\n    // state = newState\n}`;
const hasLabel = safeBool('Label');
if (hasLabel) code += `\n.label("${I.getString('┗ Text​')}")`;
if (safeBool('Bold')) code += '\n.bold()';
if (I.getBoolean('Tight') === true) code += '\n.tight()';
if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';

function safeBool(name: string): boolean {
  try { return I.getBoolean(name) === true; } catch { return false; }
}

export default { id: 'Checkbox', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
