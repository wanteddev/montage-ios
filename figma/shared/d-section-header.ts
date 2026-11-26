// Section Header 슬롯 콘텐츠 (2026-11-16, 그룹 d)
// 슬롯 안 Section Header/Resource/* 래퍼에는 Code Connect가 없어, 래퍼 안의 Chip(Filter Button)·Icon Button·Text Button·Button 템플릿을 쓴다.
// Pagination Button(Leading/Trailing Button)은 iOS·Android에 대응 컴포넌트가 없어 주석으로 둔다.
import { findFirst, I, iosHStack, run, safe } from './d-util';

export const headerSlot = (layer: string, platform: 'ios' | 'android' = 'android'): string => {
  const wrapper = findFirst(I, [layer]);
  if (!wrapper) return '// 콘텐츠';
  if (findFirst(wrapper, ['Leading Button'])) return '// 페이지 이동 버튼(Pagination Button)은 네이티브 컴포넌트가 없습니다.';
  // 요소가 여러 개면 HStack(spacing: .spacing20)으로 감싼다(Figma 슬롯 간격 20, iOS trailing 컨테이너는 spacing 0 — 2026-11-16 김삼열 님 검수).
  // Android도 이 함수를 쓰므로 platform으로 감싸기 여부를 정한다.
  const codes: string[] = [];
  for (const n of ['Chip', 'Icon Button', 'Text Button', 'Button']) {
    const r = run(safe(() => wrapper.findInstance(n)));
    if (r && !codes.includes(r.code)) codes.push(r.code);
  }
  if (!codes.length) return '// 콘텐츠';
  return platform === 'ios' ? iosHStack(codes, '.spacing20') : codes[0];
};
