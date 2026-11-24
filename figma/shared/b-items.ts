// 그룹 b(내비게이션·선택 컨트롤) 공통 처리 (2026-11-16)
// - Tab·Category·Segmented Control처럼 항목을 하위 인스턴스로 그리는 세트에서 항목 목록을 읽는다.
// - 문자열 배열을 Swift/Kotlin 리터럴로 바꾼다.
import figma from 'figma';

type Handle = ReturnType<typeof figma.selectedInstance.findInstance>;

export type Item = { label: string; active: boolean; disabled: boolean; node?: Handle };

const safe = <T>(fn: () => T): T | undefined => {
  try {
    return fn();
  } catch {
    return undefined;
  }
};

const isTrue = (v: unknown): boolean => v === true || v === 'True' || v === 'true';

/** 하위 인스턴스(예: 'Tab 1') 하나에서 라벨·Active·Disabled를 읽는다. */
export const readItem = (node: Handle | undefined, textProp: string): Item => {
  if (!node || node.type === 'ERROR') return { label: '', active: false, disabled: false };
  return {
    label: safe(() => node.getString(textProp)) ?? '',
    active: isTrue(safe(() => node.getPropertyValue('Active'))),
    disabled: isTrue(safe(() => node.getPropertyValue('Disabled'))),
    node,
  };
};

/** 이름이 정규식에 맞는 하위 인스턴스를 모두 읽는다(슬롯 안 항목용). */
export const readItemsByName = (pattern: RegExp, textProp: string): Item[] => {
  const layers = (safe(() =>
    figma.selectedInstance.findLayers((l) => l.type === 'INSTANCE' && pattern.test(l.name)),
  ) ?? []) as unknown as Handle[];
  return layers.filter((l) => l && l.type === 'INSTANCE').map((l) => readItem(l, textProp));
};

/** 선택된 항목의 0부터 세는 인덱스(없으면 0). */
export const activeIndex = (items: Item[]): number => Math.max(0, items.findIndex((i) => i.active));

/** 비활성 항목 인덱스 목록. */
export const disabledIndices = (items: Item[]): number[] =>
  items.map((i, n) => (i.disabled ? n : -1)).filter((n) => n >= 0);

const esc = (s: string): string => s.replace(/\\/g, '\\\\').replace(/"/g, '\\"');

/** Swift 문자열 리터럴 */
export const swiftStr = (s: string): string => `"${esc(s)}"`;
/** Kotlin 문자열 리터럴 ($는 이스케이프) */
export const kotlinStr = (s: string): string => `"${esc(s).replace(/\$/g, '\\$')}"`;

export const swiftList = (xs: string[]): string => `[${xs.map(swiftStr).join(', ')}]`;
export const kotlinList = (xs: string[]): string => `listOf(${xs.map(kotlinStr).join(', ')})`;

/** Figma 텍스트 속성의 숫자(예: Total Page '10'). 숫자가 아니면 fallback. */
export const intFrom = (s: string | undefined, fallback: number): number => {
  const n = parseInt(String(s ?? '').trim(), 10);
  return Number.isFinite(n) ? n : fallback;
};
