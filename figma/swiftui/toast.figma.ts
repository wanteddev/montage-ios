// url=<FIGMA_TOAST>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/7%20Feedback/Toast.swift
// component=Toast

// [2026-11-16] 근거: Toast.swift L60-63(Model(_ variant:message:)), L70-84(Variant .normal(Icon?)/.positive/.cautionary/.negative), L321(View.toast).
// Toast는 모델 바인딩으로 띄운다. Positive·Cautionary·Negative는 아이콘이 항상 표시된다(L207-212).
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';
import { flag, textOf } from '../shared/a-util';

const I = figma.selectedInstance;
const variant = I.getEnum('Variant', { Normal: 'normal', Positive: '.positive', Cautionary: '.cautionary', Negative: '.negative' });
const leading = flag('Leading Icon');
const message = textOf('Text');

let v = '';
if (variant === 'normal') {
  if (leading) v = `.normal(${iconFromLayer('Icon', (n) => ({ ref: iosIcon(n) }))?.ref ?? '.blank'})`;
} else {
  v = variant;
}
const note = variant !== 'normal' && !leading
  ? '// 이 상태는 아이콘을 숨길 수 없어 아이콘이 함께 표시됩니다.\n'
  : '';
const model = `Montage.Toast.Model(${v ? `${v}, ` : ''}message: "${message}")`;

const code = `ContentView()\n    .toast($toastModel)\n\n// 모델을 넣으면 표시됩니다.\n${note}toastModel = ${model}`;

export default { id: 'Toast', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
