// 그룹 e: Tooltip 공통 읽기 (2026-11-16)
// Figma Tooltip/Tooltip: Size(Small·Medium), Position(Top·Bottom·Left·Right), Label / Label(Only Desktop)(Small),
// Shortcut + ┗ Text, 'Arrow' 레이어의 Align(Leading·Center·Trailing / Top·Center·Bottom).
import figma from 'figma';

import { bool, find, prop, str } from './e-nav';

export type TooltipModel = {
  size: 'Small' | 'Medium';
  position: 'Top' | 'Bottom' | 'Left' | 'Right';
  align: string;
  label: string;
  shortcut: boolean;
};

export const readTooltip = (): TooltipModel => {
  const I = figma.selectedInstance;
  const size = (prop(I, 'Size') === 'Small' ? 'Small' : 'Medium') as TooltipModel['size'];
  const position = String(prop(I, 'Position') ?? 'Bottom') as TooltipModel['position'];
  // Small은 텍스트가 Label(Only Desktop)에 연결돼 있다(웹 템플릿과 동일).
  const label = (size === 'Small' ? str(I, 'Label(Only Desktop)', 'Label') : str(I, 'Label')) ?? '';
  return {
    size,
    position,
    align: String(prop(find(I, 'Arrow'), 'Align') ?? 'Center'),
    label,
    shortcut: bool(I, 'Shortcut') === true,
  };
};
