import figma from 'figma';

type InstanceHandle = ReturnType<typeof figma.selectedInstance.findInstance>;
export type IconRef = { ref: string; note?: string };

const safe = <T>(fn: () => T): T | undefined => {
  try {
    return fn();
  } catch {
    return undefined;
  }
};

/** 아이콘 인스턴스(또는 아이콘을 품은 Icons 래퍼)에서 플랫폼 아이콘 표기를 꺼낸다. */
export const iconFromInstance = (
  inst: InstanceHandle | undefined,
  convert: (name: string) => IconRef,
): IconRef | undefined => {
  if (!inst || inst.type === 'ERROR') return undefined;

  // 1) 이 라벨의 Code Connect가 붙어 있으면(아이콘·래퍼) 그 결과를 쓴다.
  if (safe(() => inst.hasCodeConnect())) {
    const props = safe(() => inst.executeTemplate().metadata?.props) as
      | { icon?: string; note?: string }
      | undefined;
    if (props?.icon) return { ref: props.icon, note: props.note };
  }

  // 2) 아이콘 자체면 Name variant(문자열)로 변환한다.
  //    2026-11-16 실측: Icon Button Normal Dim variant의 'Icon' 래퍼는 Name이 인스턴스 교체 속성이라
  //    객체가 돌아온다(`.[object Object]` 노출). 문자열일 때만 이름으로 쓰고, 객체면 그 인스턴스로 들어간다.
  const raw = safe(() => inst.getPropertyValue('Name')) as unknown;
  //    재게시 후에도 `[object Object]`가 문자열로 들어와서(런타임이 문자열로 바꿔 줌), 아이콘 이름 형태(영문·숫자)일 때만 인정한다.
  if (typeof raw === 'string') {
    const name = raw.trim();
    if (/^[A-Za-z][A-Za-z0-9]*$/.test(name) && name !== 'Null' && name !== 'undefined') return convert(name);
  } else if (raw && typeof raw === 'object' && raw !== inst) {
    const found = iconFromInstance(raw as InstanceHandle, convert);
    if (found) return found;
  }

  // 3) Icons 래퍼면 안에 교체된 아이콘으로 한 단계 더 들어간다.
  const swapped = safe(() => inst.getInstanceSwap('Icon')) as
    | InstanceHandle
    | undefined;
  if (swapped && swapped !== inst) {
    const found = iconFromInstance(swapped, convert);
    if (found) return found;
  }

  // 4) 교체 속성이 없는 래퍼면 안쪽 'Icon' 레이어를 직접 찾는다.
  const child = safe(() =>
    (inst as unknown as { findInstance: (n: string) => InstanceHandle }).findInstance('Icon'),
  );
  if (child && child !== inst && child !== swapped) return iconFromInstance(child, convert);

  return undefined;
};

/** 선택한 컴포넌트 안의 레이어(예: 'Leading Icon')에서 아이콘 표기를 꺼낸다. */
export const iconFromLayer = (
  layer: string,
  convert: (name: string) => IconRef,
): IconRef | undefined =>
  iconFromInstance(
    safe(() => figma.selectedInstance.findInstance(layer)),
    convert,
  );
