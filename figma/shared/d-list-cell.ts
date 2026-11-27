// List Cell 하위 파트(Leading/Trailing/Label Trailing/Extra) 템플릿 공통 처리 (2026-11-16, 그룹 d)
// 파트는 스스로 스니펫을 보여 주고, metadata.props로 상위 List Cell 템플릿에 요소 코드를 넘긴다.
// ListCell.Resource.<슬롯> case 표기(예: `.icon(.heart)`) → 상위가 `.leadingResources([...])`로 묶는다.
import figma from 'figma';

export type Slot = 'leading' | 'trailing' | 'labelTrailing' | 'extra';

const IOS_MODIFIER: Record<Slot, string> = {
  leading: 'leadingResources',
  trailing: 'trailingResources',
  labelTrailing: 'labelTrailingResources',
  extra: 'extraResources',
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

/** 선택 표시(Check) 파트: 요소가 아니라 selected 상태로 표현한다. */
export const checkPart = (id: string) => {
  const code =
    '// 선택 표시(Check)는 trailing 요소가 아니라 선택 상태로 그립니다(trailing이 비어 있을 때만 표시).\n.selected(true)';
  return {
    id,
    imports: ['import Montage'],
    example: figma.code`${code}`,
    metadata: { nestable: true, props: { selectedCheck: true } },
  };
};
