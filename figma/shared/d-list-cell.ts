// List Cell 하위 파트(Leading/Trailing/Label Trailing/Extra) 템플릿 공통 처리 (2026-11-16, 그룹 d)
// 파트는 스스로 스니펫을 보여 주고, metadata.props로 상위 List Cell 템플릿에 요소 코드를 넘긴다.
// - iOS: ListCell.Resource.<슬롯> case 표기(예: `.icon(.heart)`) → 상위가 `.leadingResources([...])`로 묶는다.
// - Android: 슬롯 람다 안에 들어갈 컴포저블 → 상위가 `leadingContent = { ... }`로 묶는다.
import figma from 'figma';

import { composeImportsOf, I, run, safe } from './d-util';

export type Slot = 'leading' | 'trailing' | 'labelTrailing' | 'extra';

const IOS_MODIFIER: Record<Slot, string> = {
  leading: 'leadingResources',
  trailing: 'trailingResources',
  labelTrailing: 'labelTrailingResources',
  extra: 'extraResources',
};
const ANDROID_PARAM: Record<Slot, string> = {
  leading: 'leadingContent',
  trailing: 'trailingContent',
  labelTrailing: 'labelTrailingContent',
  extra: 'extraContent',
};

/** iOS 파트. code는 Resource case 표기. */
export const iosPart = (id: string, slot: Slot, code: string, note?: string) => {
  const head = `// ListCell .${IOS_MODIFIER[slot]}([...])에 넣는 요소`;
  const body = [head, ...(note ? [note] : []), code].join('\n');
  return {
    id,
    imports: ['import Montage'],
    example: figma.code`${body}`,
    metadata: { nestable: true, props: { code, note, slot } },
  };
};

/** Android 파트. code는 슬롯 람다 안의 컴포저블. interactive면 상위가 enabledInnerTouch를 켠다. */
export const composePart = (id: string, slot: Slot, code: string, interactive = false) => {
  const imports = composeImportsOf(code);
  const head = `// WantedListCell ${ANDROID_PARAM[slot]} = { ... } 안에 넣는 콘텐츠`;
  return {
    id,
    imports,
    example: figma.code`${`${head}\n${code}`}`,
    metadata: { nestable: true, props: { code, imports, interactive, slot } },
  };
};

/** 선택 표시(Check) 파트: 요소가 아니라 selected 상태로 표현한다. */
export const checkPart = (id: string, platform: 'ios' | 'android') => {
  const code =
    platform === 'ios'
      ? '// 선택 표시(Check)는 trailing 요소가 아니라 선택 상태로 그립니다(trailing이 비어 있을 때만 표시).\n.selected(true)'
      : '// 선택 표시(Check)는 trailingContent가 아니라 selected로 그립니다(trailingContent가 비어 있을 때만 표시).\nselected = true';
  return {
    id,
    imports: platform === 'ios' ? ['import Montage'] : [],
    example: figma.code`${code}`,
    metadata: { nestable: true, props: { selectedCheck: true } },
  };
};

/** 파트 안 Montage 컴포넌트(이미 Code Connect가 있는 것)의 코드를 그대로 쓴다. */
export const innerCode = (layers: string[], fallback: string): string => {
  for (const l of layers) {
    const r = run(safe(() => I.findInstance(l)));
    if (r) return r.code;
  }
  return fallback;
};
