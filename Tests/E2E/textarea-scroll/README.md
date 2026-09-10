# TextArea 중첩 스크롤 E2E

`TextArea`를 `SwiftUI.ScrollView` 안에서 `.resize(.fixed(min:max:))`로 쓸 때, 코드로 주입된 긴 텍스트가
TextArea 내부에서 스크롤되는지(바깥 ScrollView가 제스처를 가로채지 않는지) 검증한다. WRP-2846 회귀 방지용.

## 요구사항

- Xcode, 부팅된 iPhone 시뮬레이터
- [Maestro](https://maestro.dev) (`~/.maestro/bin` 또는 PATH)
- Java 17+ (`brew install openjdk@21`이면 자동 탐지)

## 실행

```bash
Tests/E2E/textarea-scroll/run.sh              # Blueprint 빌드 → 설치 → 검증
Tests/E2E/textarea-scroll/run.sh --skip-build # 직전 빌드 재사용
Tests/E2E/textarea-scroll/run.sh --udid <UDID>
```

## 판정

1. `setup.yaml`: Blueprint > TextArea 프리뷰 이동 → Resize `Fixed` → `inject` 버튼으로 18줄 텍스트 주입
2. 스크린샷 A 촬영
3. `swipe-up.yaml`: 포커스 없는 TextArea 내부를 위로 스와이프
4. 스크린샷 B 촬영
5. 비교
   - TextArea 영역(세로 19~43%)이 A ≠ B → 내부 스크롤 정상
   - Options 영역(세로 46~62%)이 A = B → 바깥 ScrollView 미동작

두 조건을 모두 만족하면 `PASS`. 스크린샷은 `$TMPDIR/montage-e2e-textarea-scroll/`에 남는다.

## 참고

- 좌표는 iPhone 시뮬레이터의 프리뷰 레이아웃 기준이다. 프리뷰 상단 구조가 바뀌면 `swipe-up.yaml`과 `run.sh`의 비율을 조정한다.
- 결함 상태에서는 "TextArea 내부 텍스트가 스크롤되지 않았습니다"가 출력된다(음성 대조로 확인됨).
  Blueprint 프리뷰의 바깥 ScrollView는 콘텐츠가 화면보다 짧아 결함 상태에서도 거의 움직이지 않으므로,
  바깥 스크롤 판정은 회귀 감지보다 부수 효과 방지 목적이다. 핵심 판정은 내부 스크롤 여부다.
