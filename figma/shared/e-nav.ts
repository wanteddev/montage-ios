// 그룹 e(Presentation·Top Navigation) 공통 처리 (2026-11-16)
// Top Navigation·Modal Navigation의 Bar 인스턴스에서 제목·leading·trailing·검색·툴바를 읽어 온다.
// 속성명은 Code Connect 런타임 기준(앞뒤 공백은 잘리고 제로폭 문자는 남는다).
import figma from 'figma';

import { iconFromInstance, type IconRef } from './resolve-icon';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type H = any;

export const safe = <T>(fn: () => T): T | undefined => {
  try {
    return fn();
  } catch {
    return undefined;
  }
};

export const ok = (h: H): boolean => !!h && h.type !== 'ERROR';

/** 이름 후보 중 처음 읽히는 Boolean 속성 값 */
export const bool = (h: H, ...names: string[]): boolean | undefined => {
  if (!ok(h)) return undefined;
  for (const n of names) {
    const v = safe(() => h.getBoolean(n));
    if (typeof v === 'boolean') return v;
  }
  return undefined;
};

export const str = (h: H, ...names: string[]): string | undefined => {
  if (!ok(h)) return undefined;
  for (const n of names) {
    const v = safe(() => h.getString(n));
    if (typeof v === 'string') return v;
  }
  return undefined;
};

export const prop = (h: H, name: string): unknown =>
  ok(h) ? safe(() => h.getPropertyValue(name)) : undefined;

export const find = (h: H, ...names: string[]): H | undefined => {
  if (!ok(h)) return undefined;
  for (const n of names) {
    const v = safe(() => h.findInstance(n));
    if (ok(v)) return v;
  }
  return undefined;
};

export const sel = (...names: string[]): H | undefined => find(figma.selectedInstance, ...names);

/** 큰따옴표 문자열 이스케이프 */
export const q = (s: string | undefined): string =>
  `"${(s ?? '').replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n')}"`;

/** 둘째 줄부터 들여쓰기 */
export const indent = (text: string, pad = '    '): string =>
  text.split('\n').map((l, i) => (i === 0 || l === '' ? l : pad + l)).join('\n');

// ── Bar 읽기 ─────────────────────────────────────────────

export type Leading = { kind: 'back' | 'icon' | 'text'; icon?: IconRef; text?: string };
export type Trailing = {
  kind: 'close' | 'icon' | 'text';
  icon?: IconRef;
  text?: string;
  badge?: boolean;
  background?: boolean;
};
export type Convert = (name: string) => IconRef;

const iconOf = (h: H, convert: Convert): IconRef | undefined =>
  ok(h) ? iconFromInstance(h, convert) : undefined;

/** Leading 리소스(Type 또는 Variant = Back / Icon Button / Text Button) */
export const readLeading = (h: H, convert: Convert): Leading | undefined => {
  if (!ok(h)) return undefined;
  const t = String(prop(h, 'Type') ?? prop(h, 'Variant') ?? '');
  if (/^Back/.test(t)) return { kind: 'back' };
  if (/^Text/.test(t)) return { kind: 'text', text: str(find(h, 'Text'), 'Label') ?? '' };
  if (/^Icon/.test(t)) {
    const btn = find(h, 'Icon');
    return { kind: 'icon', icon: iconOf(btn, convert) };
  }
  return undefined;
};

/** Action 리소스(Variant = Icon / Text / Close Button) */
export const readAction = (h: H, convert: Convert): Trailing | undefined => {
  if (!ok(h)) return undefined;
  const v = String(prop(h, 'Variant') ?? '');
  if (v === 'Close Button') {
    const inner = find(h, 'Close Button', 'Icon');
    return { kind: 'close', background: prop(inner, 'Background') === 'True' };
  }
  if (v === 'Text') return { kind: 'text', text: str(find(h, 'Text'), 'Label') ?? '' };
  if (v === 'Icon') {
    const btn = find(h, 'Icon');
    return {
      kind: 'icon',
      icon: iconOf(btn, convert),
      badge: bool(btn, 'Badge') === true,
      background: prop(btn, 'Background') === 'True',
    };
  }
  return undefined;
};

/** 버튼 그룹(┗ Button / ┗ Button 2 / ┗ Button 3) 안의 보이는 Action들 */
export const readActionGroup = (group: H, convert: Convert): Trailing[] => {
  const out: Trailing[] = [];
  const slots: [string, string[]][] = [
    ['┗ Button', ['Button 1', 'Button']],
    ['┗ Button 2', ['Button 2']],
    ['┗ Button 3', ['Button 3']],
  ];
  for (const [flag, layers] of slots) {
    if (bool(group, flag) !== true) continue;
    const a = readAction(find(group, ...layers), convert);
    if (a) out.push(a);
  }
  return out;
};

/** Trailing Button 인스턴스: 그룹이면 그룹, 단일 Action이면 하나 */
export const readTrailing = (h: H, convert: Convert): Trailing[] => {
  if (!ok(h)) return [];
  if (prop(h, 'Variant') !== undefined) {
    const a = readAction(h, convert);
    return a ? [a] : [];
  }
  return readActionGroup(h, convert);
};

export const searchPlaceholder = (bar: H): string | undefined => {
  const field = find(find(bar, 'Search field'), 'Searchfield/Searchfield', 'Searchfield');
  return str(field, 'Placeholder');
};

/** 툴바 리소스 종류와 항목 수 */
export type Tool = { kind: 'tab' | 'segmentedControl' | 'category' | 'slot'; count: number };
export const readTool = (h: H): Tool | undefined => {
  if (!ok(h)) return undefined;
  const tab = find(h, 'Tab');
  if (tab) {
    let n = 0;
    for (let i = 1; i <= 8; i++) if (bool(tab, `Tab ${i}`) === true) n++;
    return { kind: 'tab', count: n || 3 };
  }
  const seg = find(h, 'Segmented Control');
  if (seg) {
    let n = 2;
    for (let i = 3; i <= 6; i++) if (bool(seg, `Segment ${i}`) === true) n++;
    return { kind: 'segmentedControl', count: n };
  }
  if (find(h, 'Category')) return { kind: 'category', count: 3 };
  return { kind: 'slot', count: 0 };
};

export const placeholders = (prefix: string, n: number): string =>
  `[${Array.from({ length: n }, (_, i) => q(`${prefix} ${i + 1}`)).join(', ')}]`;

// ── iOS 공통 조각 ────────────────────────────────────────

export const IOS_ACTION = ' {\n    // action\n}';

// enum 케이스 액션은 trailing closure로 쓴다(2026-11-16 김삼열 님 검수: `.back { }` 표준).

/** ModalNavigation.Resource.Leading / TopNavigation.Resource.Leading 케이스 */
export const iosLeadingCase = (l: Leading): string => {
  if (l.kind === 'back') return `.back${IOS_ACTION}`;
  if (l.kind === 'text') return `.text(${q(l.text)})${IOS_ACTION}`;
  return `.icon(${l.icon?.ref ?? '.blank'})${IOS_ACTION}`;
};

/** ModalNavigation.Resource.Trailing 케이스 */
export const iosModalTrailingCase = (t: Trailing): string => {
  if (t.kind === 'close') return `.close${IOS_ACTION}`;
  if (t.kind === 'text') return `.text(${q(t.text)})${IOS_ACTION}`;
  return `.icon(${t.icon?.ref ?? '.blank'})${IOS_ACTION}`;
};

/** ActionArea 자리(내용은 Action Area 인스턴스 쪽 Code Connect를 따른다) */
export const iosActionAreaPlaceholder = (variant: unknown): string => {
  const v = String(variant ?? 'Strong');
  const kind = v === 'Neutral' ? 'neutral' : v === 'Cancel' ? 'cancel' : 'strong';
  return `Montage.ActionArea(variant: .${kind}(main: .init(text: "확인")${IOS_ACTION}))`;
};
