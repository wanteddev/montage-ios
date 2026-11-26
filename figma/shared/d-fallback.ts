// Fallback View(구 Empty State) 버튼 영역 읽기 (2026-11-16, 그룹 d)
// 'Action Area' 인스턴스(Fallback View/Resource/Action Area/Desktop|Mobile)의 Variant=Single|Horizontal|Vertical,
// 버튼 라벨은 '┗ Button'(주)·'┗ Alternative Button'(대체) 안 Button/Button의 Label.
import { block, findFirst, textOf, variantOf, type Handle } from './d-util';

export type FallbackButtons = { variant: string; main: string; alternative?: string };

const label = (wrapper: Handle): string =>
  textOf(findFirst(wrapper, ['Button/Button', 'Button']), 'Label', '액션');

export const readButtons = (area: Handle): FallbackButtons | undefined => {
  if (!area) return undefined;
  const variant = variantOf(area, 'Variant') ?? 'Single';
  const out: FallbackButtons = { variant, main: label(findFirst(area, ['┗ Button'])) };
  if (variant !== 'Single') out.alternative = label(findFirst(area, ['┗ Alternative Button']));
  return out;
};

/** iOS FallbackView.ButtonActionArea 표기 */
export const iosButtonActionArea = (b: FallbackButtons): string => {
  const info = (t: string) => `.init(text: "${t}", action: ${block('// action', 4)})`;
  if (b.variant === 'Single') return `.single(${info(b.main).replace(/\n {4}/g, '\n')})`;
  const kind = b.variant === 'Horizontal' ? 'horizontal' : 'vertical';
  return `.${kind}(\n    main: ${info(b.main)},\n    alternative: ${info(b.alternative ?? '')}\n)`;
};
