// url=<FIGMA_CONTENT_BADGE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/ContentBadge.swift
// component=ContentBadge

// [2026-11-16] ContentBadge.swift init, .size, .colorStyle, 아이콘.
// Accent 색은 Figma 변수 모드라 읽을 수 없어 Xcode 플레이스홀더로 둔다.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const I = figma.selectedInstance;
const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';
const action = ' {\n    // action\n}';

const variant = I.getEnum('Variant', { Solid: '.solid', Outlined: '.outlined' });
const size = I.getEnum('Size', { XSmall: '.xsmall', Small: '.small', Medium: '.medium' });
const args: string[] = [];
if (variant !== '.solid') args.push(`variant: ${variant}`);
args.push(`text: "${I.getString('Text')}"`);

let code = `Montage.ContentBadge(${args.join(', ')})`;
if (size !== '.small') code += `\n.size(${size})`;
if (I.getPropertyValue('Color') === 'Accent') code += '\n.colorStyle(.accent(<#accent 색상#>))';
if (I.getBoolean('Leading Icon') === true) code += `\n.leadingIcon(${iconRef('Leading Icon')})`;
if (I.getBoolean('Trailing Icon') === true) code += `\n.trailingIcon(${iconRef('Trailing Icon')})`;

export default { id: 'ContentBadge', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
