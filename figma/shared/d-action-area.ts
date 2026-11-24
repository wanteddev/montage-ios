// Action Area 읽기 (2026-11-16, 그룹 d)
// 버튼 구성은 안쪽 'Actions'(Action Area/Resource/Actions) 인스턴스에 있다.
// 속성명 주의: 캡션 아이콘은 '┗  Icon'(┗ 뒤 공백 2개).
import { findFirst, flag, flagOf, I, textOf, variantOf, type Handle } from './d-util';

export type ActionAreaSpec = {
  variant: string; // Strong | Neutral | Compact (Web Only) | Cancel
  main: { label: string; disabled: boolean; loading: boolean };
  alternative?: string;
  sub?: string;
  caption?: string;
  captionIcon?: Handle;
  extra: boolean;
  divider: boolean;
};

export const readActionArea = (): ActionAreaSpec => {
  const actions = findFirst(I, ['Actions']);
  const main = findFirst(actions, ['┗ Main Action']);
  const spec: ActionAreaSpec = {
    variant: variantOf(actions, 'Variant') ?? 'Strong',
    main: {
      label: textOf(main, 'Label', '메인 액션'),
      disabled: flagOf(main, 'Disable'),
      loading: flagOf(main, 'Loading'),
    },
    extra: flag('Extra'),
    divider: flag('Divider'),
  };
  if (flagOf(actions, 'Alternative Action'))
    spec.alternative = textOf(findFirst(actions, ['┗ Alternative Action']), 'Label', '대체 액션');
  if (flagOf(actions, 'Sub Action'))
    spec.sub = textOf(findFirst(actions, ['┗ Sub Action']), 'Label', '보조 액션');
  if (flagOf(actions, 'Caption')) {
    spec.caption = textOf(actions, '┗ Text', '캡션');
    if (flagOf(actions, '┗  Icon')) spec.captionIcon = findFirst(actions, ['Icons/Icons']) ?? null;
  }
  return spec;
};
