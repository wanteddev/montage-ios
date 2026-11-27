// 그룹 d(콘텐츠 컨테이너: List Cell·Card·Accordion·Section Header·Action Area·Fallback View) 공통 처리 (2026-11-16)
// - 하위 파트·슬롯 안 컴포넌트의 템플릿을 실행해 문자열로 받아 상위 템플릿에 끼워 넣는다.
import figma from 'figma';

import { iosIcon } from './icon-name';
import { iconFromInstance, iconFromLayer } from './resolve-icon';

/* eslint-disable @typescript-eslint/no-explicit-any */
export type Handle = any;

export const I: Handle = figma.selectedInstance;

export const safe = <T>(fn: () => T): T | undefined => {
  try {
    return fn();
  } catch {
    return undefined;
  }
};

const ok = (h: Handle): boolean => !!h && h.type !== 'ERROR';

/** BOOLEAN(true) 또는 True/False VARIANT('True')를 참으로 읽는다. 없는 속성은 false. */
export const flagOf = (h: Handle, name: string): boolean => {
  if (!ok(h)) return false;
  const v = safe(() => h.getPropertyValue(name));
  return v === true || v === 'True' || v === 'true';
};
export const flag = (name: string): boolean => flagOf(I, name);

/** VARIANT 값 문자열. 없으면 undefined. */
export const variantOf = (h: Handle, name: string): string | undefined => {
  if (!ok(h)) return undefined;
  const v = safe(() => h.getPropertyValue(name));
  return typeof v === 'string' ? v : undefined;
};

/** 문자열 리터럴 안에 넣을 수 있게 따옴표·역슬래시·줄바꿈을 이스케이프한다. */
export const esc = (s: string): string =>
  s.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\r?\n/g, '\\n');

/** TEXT 속성 값(이스케이프됨). 없으면 fallback. */
export const textOf = (h: Handle, name: string, fallback = ''): string => {
  if (!ok(h)) return fallback;
  const v = safe(() => h.getString(name));
  return esc(typeof v === 'string' ? v : fallback);
};
export const text = (name: string, fallback = ''): string => textOf(I, name, fallback);

/** 첫 번째로 찾은 레이어(인스턴스). */
export const findFirst = (h: Handle, names: string[]): Handle | undefined => {
  if (!ok(h)) return undefined;
  for (const n of names) {
    const found = safe(() => h.findInstance(n));
    if (ok(found)) return found;
  }
  return undefined;
};

/** ResultSection[] 중 CODE만 이어 붙인다. 중첩 INSTANCE가 섞이면 undefined. */
const sectionsText = (sections: unknown): string | undefined => {
  if (typeof sections === 'string') return sections;
  if (!Array.isArray(sections)) return undefined;
  let out = '';
  for (const s of sections as Array<{ type?: string; code?: string }>) {
    if (Array.isArray(s)) {
      const inner = sectionsText(s);
      if (inner === undefined) return undefined;
      out += inner;
    } else if (s && s.type === 'CODE' && typeof s.code === 'string') out += s.code;
    else return undefined;
  }
  return out;
};

export type Rendered = { code: string; props: Record<string, unknown> };

/** Code Connect가 붙은 인스턴스의 템플릿을 실행해 코드 문자열과 metadata.props를 받는다. */
export const run = (h: Handle): Rendered | undefined => {
  if (!ok(h) || !safe(() => h.hasCodeConnect())) return undefined;
  const r = safe(() => h.executeTemplate());
  if (!r) return undefined;
  const props = ((r.metadata && r.metadata.props) || {}) as Record<string, unknown>;
  const code = typeof props.code === 'string' ? props.code : sectionsText(r.example);
  return code ? { code, props } : undefined;
};

/** SLOT에 직접 들어 있는 연결된 인스턴스(하위 파트)들의 metadata.props. */
export const slotParts = (slotName: string): Array<Record<string, unknown>> => {
  const slot = safe(() => I.getSlot(slotName));
  const items = (slot && (slot as Handle).connectedInstances) || [];
  const out: Array<Record<string, unknown>> = [];
  for (const it of items as Handle[]) {
    const r = safe(() => it.executeTemplate());
    const props = r && r.metadata && r.metadata.props;
    if (props && typeof props === 'object') out.push(props as Record<string, unknown>);
  }
  return out;
};

/** 슬롯 요소가 여러 개면 Figma 배치대로 HStack(spacing:)으로 감싼다(2026-11-16 김삼열 님 검수: 슬롯 컨테이너가 VStack/spacing 0이라 그냥 나열하면 배치가 달라짐). */
export const iosHStack = (items: string[], spacing: string): string =>
  items.length > 1 ? `HStack(spacing: ${spacing}) ${block(items.join('\n'))}` : (items[0] ?? '// 콘텐츠');

/** 두 번째 줄부터 n칸 들여쓴다. */
export const indent = (code: string, n: number): string =>
  code.split('\n').join(`\n${' '.repeat(n)}`);

/** 클로저/람다 본문: `{\n<pad+4>body\n<pad>}` */
export const block = (body: string, pad = 0, head = ''): string =>
  `{${head}\n${' '.repeat(pad + 4)}${indent(body, pad + 4)}\n${' '.repeat(pad)}}`;

// ---------- 아이콘 ----------
export const iosIconOf = (h: Handle): string =>
  iconFromInstance(h, (n) => ({ ref: iosIcon(n) }))?.ref ?? '.blank';
export const iosIconAt = (layer: string): string =>
  iconFromLayer(layer, (n) => ({ ref: iosIcon(n) }))?.ref ?? '.blank';
