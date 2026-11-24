// url=<FIGMA_BUTTON>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/2%20Actions/Button.swift
// component=Button

// [2026-11-16] iOS 검수(김삼열 님) 반영. 아이콘은 Leading/Trailing/Icon 레이어의 실제 아이콘을 읽는다(없으면 .blank).
// 근거: Button.swift L104-112(텍스트형 init), L140-146(아이콘 전용 init), L281 .loading, L308 .disabled
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';

const iconRef = (layer: string): string =>
  iconFromLayer(layer, (name) => ({ ref: iosIcon(name) }))?.ref ?? '.blank';

const variant = figma.selectedInstance.getEnum('Variant', {
  Solid: '.solid',
  Outlined: '.outlined',
});
const color = figma.selectedInstance.getEnum('Color', {
  Primary: '.primary',
  Assistive: '.assistive',
  Negative: '.negative',
});
const size = figma.selectedInstance.getEnum('Size', {
  Xsmall: '.xsmall',
  Small: '.small',
  Medium: '.medium',
  Large: '.large',
});
const iconOnly = figma.selectedInstance.getBoolean('Icon Only') === true;
const label = figma.selectedInstance.getString('Label');
const leading = !iconOnly && figma.selectedInstance.getBoolean('Leading Icon') === true;
const trailing = !iconOnly && figma.selectedInstance.getBoolean('Trailing Icon') === true;
const loading = figma.selectedInstance.getBoolean('Loading') === true;
const disabled = figma.selectedInstance.getBoolean('Disable') === true;

// 2026-11-16 김삼열 님 검수: Montage.Button 표기, 클로저는 여러 줄 `// action`,
// 코드가 지원하지 않는 조합은 실제 렌더 값으로 바꾸고 주석으로 이유를 남긴다.
// Outlined + Negative → 코드에서 .primary로 렌더(Button.swift L61-62, L378-386)
const outlinedNegative = variant === '.outlined' && color === '.negative';
const effectiveColor = outlinedNegative ? '.primary' : color;

// 기본값(.solid/.primary/.large)은 생략
const args: string[] = [];
if (variant !== '.solid') args.push(`variant: ${variant}`);
if (effectiveColor !== '.primary') args.push(`color: ${effectiveColor}`);
if (size !== '.large') args.push(`size: ${size}`);
if (iconOnly) {
  args.push(`icon: ${iconRef('Icon')}`);
} else {
  args.push(`text: "${label}"`);
  if (leading) args.push(`leadingIcon: ${iconRef('Leading Icon')}`);
  if (trailing) args.push(`trailingIcon: ${iconRef('Trailing Icon')}`);
}

let code = outlinedNegative
  ? '// Outlined는 Negative 색상을 지원하지 않아 .primary로 표시됩니다.\n'
  : '';
code += `Montage.Button(${args.join(', ')}) {\n    // action\n}`;
if (loading) code += '\n.loading(true)';
if (disabled) code += '\n.disabled(true)';

export default {
  id: 'Button',
  imports: ['import Montage'],
  example: figma.code`${code}`,
};
