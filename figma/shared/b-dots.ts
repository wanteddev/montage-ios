// Pagination Dots(그룹 b) 공통: Figma 점 불리언에서 전체 페이지 수와 현재 페이지(0부터)를 읽는다. (2026-11-16)
// 점 순서(실물 8350:35512): ⟸ ← ●○○○○ ○●○○○ ○○●○○ ○○○●○ ○○○○● → ⟹
// 'Dot ●○○○○' 같은 하위 인스턴스의 Active로 현재 점을 찾는다.
import figma from 'figma';

const ORDER = ['⟸', '←', '●○○○○', '○●○○○', '○○●○○', '○○○●○', '○○○○●', '→', '⟹'];

const safe = <T>(fn: () => T): T | undefined => {
  try {
    return fn();
  } catch {
    return undefined;
  }
};

export const readDots = (): { total: number; index: number } => {
  const I = figma.selectedInstance;
  const shown = ORDER.filter((d) => safe(() => I.getBoolean(`💎 Dot ${d}`)) === true);
  const index = shown.findIndex((d) => {
    const node = safe(() => I.findInstance(`Dot ${d}`));
    const v = node && node.type !== 'ERROR' ? safe(() => node.getPropertyValue('Active')) : undefined;
    return v === 'True' || v === true;
  });
  return { total: Math.max(shown.length, 1), index: Math.max(index, 0) };
};
