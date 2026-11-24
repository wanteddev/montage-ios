// url=<FIGMA_CONTROL_SWITCH>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/Switch.swift
// component=Switch

// [2026-11-16] Switch.swift L36-40(init checked:, 기본 size .small). Platform=Normal만 Montage Switch.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

let code: string;
const platform = I.getPropertyValue('Platform');
if (platform === 'Normal') {
  const size = I.getEnum('Size', { Medium: '.medium', Small: '.small' });
  const args = [`checked: ${I.getBoolean('Active') === true}`];
  if (size !== '.small') args.push(`size: ${size}`);
  code = `Montage.Switch(${args.join(', ')}) { isChecked in\n    // checked = isChecked\n}`;
  if (I.getBoolean('Disable') === true) code += '\n.disabled(true)';
} else {
  code = `// Platform=${platform}는 OS 기본 스위치입니다. Montage 컴포넌트는 Platform=Normal을 쓰세요.`;
}

export default { id: 'Switch', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
