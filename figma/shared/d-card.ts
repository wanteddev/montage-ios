// Card·ListCard 공통 처리 (2026-11-16, 그룹 d)
// 슬롯(Top/Bottom/Leading/Trailing Content) 안의 Card/Resource/* 래퍼에는 Code Connect가 없어서,
// 래퍼 안에 든 Montage 컴포넌트(배지·체크박스·아이콘)를 찾아 그 템플릿 결과를 쓴다.
import {
  androidIconOf,
  composeIcon,
  findFirst,
  I,
  iosIconOf,
  run,
  safe,
} from './d-util';

const INNER = [
  'Badge',
  'Badge 2',
  'Badge 3',
  'Content Badge/Content Badge',
  'Checkbox',
  'Chip',
  'Icon Button',
  'Text Button',
  'Button',
];
const ICONS = ['Icon/Normal/Chevron Right', 'Icon/Normal/Bookmark', 'Icon', 'Icons'];

/** 래퍼 안 컴포넌트 코드 목록. 아무것도 못 찾으면 빈 배열. */
export const wrapperContents = (layer: string, platform: 'ios' | 'android'): string[] => {
  const wrapper = findFirst(I, [layer]);
  if (!wrapper) return [];
  const out: string[] = [];
  for (const name of INNER) {
    const r = run(safe(() => wrapper.findInstance(name)));
    if (r && !out.includes(r.code)) out.push(r.code);
  }
  if (out.length) return out;
  const icon = findFirst(wrapper, ICONS);
  if (icon) {
    out.push(
      platform === 'ios'
        ? `Image.icon(${iosIconOf(icon)})`
        : composeIcon(androidIconOf(icon)),
    );
  }
  return out;
};

/** 썸네일: 안쪽 Thumbnail 인스턴스의 템플릿(있으면). */
export const thumbnailCode = (): string | undefined => run(findFirst(I, ['Thumbnail']))?.code;
