// url=<FIGMA_PULL_TO_REFRESH>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/9%20Utilities/PullToRefresh.swift
// component=PullToRefresh

// [2026-11-16] 근거: PullToRefresh.swift `.pullToRefresh(refresh: () async -> Void)` docstring 예시.
// 2026-11-16 김삼열 님 검수: Montage.ScrollView { }.onRefresh { }(ScrollView.swift onRefresh(_:))를 기본으로 쓴다.
// Figma 세트는 variant가 없는 로고 모션 에셋 하나다.
import figma from 'figma';

const code = 'Montage.ScrollView {\n    // 콘텐츠\n}\n.onRefresh {\n    // await loadData()\n}';

export default {
  id: 'PullToRefresh',
  imports: ['import Montage'],
  example: figma.code`${code}`,
  metadata: { nestable: true },
};
