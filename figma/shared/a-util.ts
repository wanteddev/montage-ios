// 그룹 a(배지·미디어·로딩·피드백) 공통 처리 (2026-11-16)
import figma from 'figma';

type Handle = { getPropertyValue: (name: string) => unknown };

/** BOOLEAN 속성(true) 또는 True/False VARIANT('True')를 모두 참으로 읽는다. 없는 속성은 false. */
export const flagOf = (inst: Handle | undefined, name: string): boolean => {
  if (!inst) return false;
  try {
    const v = inst.getPropertyValue(name);
    return v === true || v === 'True' || v === 'true';
  } catch {
    return false;
  }
};

export const flag = (name: string): boolean =>
  flagOf(figma.selectedInstance as unknown as Handle, name);

/** 문자열 속성. 없으면 fallback. 큰따옴표는 이스케이프한다. */
export const textOf = (name: string, fallback = ''): string => {
  try {
    const v = figma.selectedInstance.getString(name);
    return (typeof v === 'string' ? v : fallback).replace(/"/g, '\\"');
  } catch {
    return fallback;
  }
};

/** VARIANT 값 문자열. 없으면 undefined. */
export const variantOf = (inst: Handle | undefined, name: string): string | undefined => {
  if (!inst) return undefined;
  try {
    const v = inst.getPropertyValue(name);
    return typeof v === 'string' ? v : undefined;
  } catch {
    return undefined;
  }
};
