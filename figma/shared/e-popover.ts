// 그룹 e: Popover 공통 읽기 (2026-11-16)
// Figma Popover/Popover: Variant(Normal·Custom), Position(Top and Bottom·Left and Right), Heading(True·False),
// Description(TEXT), Close Button, Action, ┗ Sub Action. 행동 버튼은 Text Button 두 개(Primary=행동, Assistive=보조 행동).
import figma from 'figma';

import { bool, ok, prop, safe, str, type H } from './e-nav';

export type PopoverModel = {
  custom: boolean;
  horizontal: boolean;
  heading?: string;
  text: string;
  closeButton: boolean;
  action?: string;
  subAction?: string;
};

export const readPopover = (): PopoverModel => {
  const I = figma.selectedInstance;
  const custom = prop(I, 'Variant') === 'Custom';
  const horizontal = prop(I, 'Position') === 'Left and Right';
  const m: PopoverModel = {
    custom,
    horizontal,
    text: str(I, 'Description') ?? '',
    closeButton: bool(I, 'Close Button') === true,
  };
  if (custom) return m;
  if (prop(I, 'Heading') === 'True') {
    const h = safe(() => I.findText('Heading')) as H;
    m.heading = ok(h) ? String(h.textContent ?? '') : '';
  }
  if (bool(I, 'Action') === true) {
    const buttons = (safe(() =>
      I.findLayers((l: H) => l.type === 'INSTANCE' && l.name === 'Text Button/Text Button'),
    ) ?? []) as H[];
    for (const b of buttons) {
      if (!ok(b)) continue;
      const label = str(b, 'Label') ?? '';
      if (prop(b, 'Color') === 'Assistive') m.subAction = label;
      else m.action = label;
    }
    if (bool(I, '┗ Sub Action') !== true) m.subAction = undefined;
    if (m.action === undefined) m.action = '';
  }
  return m;
};
