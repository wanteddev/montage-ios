// Compose 템플릿 공통 처리 (2026-11-16, 성명윤 님 검수 규칙)
// - onClick 등 콜백은 필수일 때만 넣는다
// - 여러 줄, 마지막 인자 뒤 쉼표 없음
// - import는 실제로 쓴 것만, R은 R.drawable.* 만 표기
import { androidIcon } from './icon-name';
import { iconFromLayer } from './resolve-icon';

export const P = 'com.wanted.android.wanted.design';

export const composeBuilder = () => {
  const notes: string[] = [];
  const imports = new Set<string>();
  const args: string[] = [];

  const icon = (layer: string): string => {
    const found = iconFromLayer(layer, androidIcon) ?? {
      ref: 'R.drawable.icon_normal_blank',
    };
    if (found.note && !notes.includes(found.note)) notes.push(found.note);
    return found.ref;
  };

  /** 인자를 넣고, 값에 쓰인 타입의 import를 함께 등록한다. */
  const arg = (text: string, ...importPaths: string[]) => {
    args.push(text);
    importPaths.forEach((p) => imports.add(`import ${p}`));
  };

  const render = (fn: string) => {
    const call = args.length
      ? `${fn}(\n    ${args.join(',\n    ')}\n)`
      : `${fn}()`;
    return [...notes, call].join('\n');
  };

  return { icon, arg, render, imports, notes };
};
