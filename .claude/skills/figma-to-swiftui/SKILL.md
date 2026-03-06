---
name: figma-to-swiftui
description: Figma 디자인을 Montage 디자인 시스템의 SwiftUI 코드로 변환
---

# Figma to SwiftUI (Montage Design System)

피그마 디자인을 Montage 디자인 시스템의 SwiftUI 코드로 변환합니다.

## 입력

$ARGUMENTS

## 절차

### 1단계: 피그마 디자인 분석

피그마 URL에서 fileKey와 nodeId를 추출합니다.
- URL 형식: `https://figma.com/design/:fileKey/:fileName?node-id=:int1-:int2`
- fileKey: URL path의 `:fileKey` 부분
- nodeId: `node-id` 쿼리 파라미터의 값 (하이픈을 콜론으로 변환, 예: `1-2` → `1:2`)

`mcp__figma__get_design_context` 도구를 사용하여 디자인 컨텍스트를 가져옵니다.
- clientLanguages: "swift"
- clientFrameworks: "swiftui"

필요하다면 `mcp__figma__get_screenshot` 도구로 스크린샷도 확인합니다.

### 2단계: Montage 컴포넌트 매핑

디자인에서 사용되는 UI 요소를 분석하고, 아래 Montage 컴포넌트 목록에서 매칭되는 컴포넌트를 식별합니다.

**Actions (액션)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| ActionArea | 화면 하단 액션 버튼 영역 | `Projects/Views/Montage/documentation/components/actions/actionarea/ios.md` |
| Button | 버튼 (solid, outlined) | `Projects/Views/Montage/documentation/components/actions/button/ios.md` |
| Chip | 칩 | `Projects/Views/Montage/documentation/components/actions/chip/ios.md` |
| IconButton | 아이콘 버튼 | `Projects/Views/Montage/documentation/components/actions/iconbutton/ios.md` |
| TextButton | 텍스트 버튼 | `Projects/Views/Montage/documentation/components/actions/textbutton/ios.md` |

**Contents (콘텐츠)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| Accordion | 접을 수 있는 콘텐츠 | `Projects/Views/Montage/documentation/components/contents/accordion/ios.md` |
| Avatar | 프로필 이미지 | `Projects/Views/Montage/documentation/components/contents/avatar/ios.md` |
| AvatarGroup | 그룹 아바타 | `Projects/Views/Montage/documentation/components/contents/avatargroup/ios.md` |
| Card | 썸네일+콘텐츠 카드 | `Projects/Views/Montage/documentation/components/contents/card/ios.md` |
| ContentBadge | 텍스트/아이콘 뱃지 | `Projects/Views/Montage/documentation/components/contents/contentbadge/ios.md` |
| ListCard | 수평 리스트 카드 | `Projects/Views/Montage/documentation/components/contents/listcard/ios.md` |
| ListCell | 리스트 아이템 | `Projects/Views/Montage/documentation/components/contents/listcell/ios.md` |
| PlayBadge | 재생 버튼 뱃지 | `Projects/Views/Montage/documentation/components/contents/playbadge/ios.md` |
| SectionHeader | 섹션 헤더 | `Projects/Views/Montage/documentation/components/contents/sectionheader/ios.md` |
| Thumbnail | 이미지 썸네일 | `Projects/Views/Montage/documentation/components/contents/thumbnail/ios.md` |

**Feedback (피드백)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| FallbackView | 빈 화면/에러 대체 | `Projects/Views/Montage/documentation/components/feedback/fallbackview/ios.md` |
| PushBadge | 알림 뱃지 | `Projects/Views/Montage/documentation/components/feedback/pushbadge/ios.md` |
| SnackBar | 알림 메시지 | `Projects/Views/Montage/documentation/components/feedback/snackbar/ios.md` |
| Toast | 짧은 알림 | `Projects/Views/Montage/documentation/components/feedback/toast/ios.md` |

**Loading (로딩)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| Loading | 로딩 애니메이션 | `Projects/Views/Montage/documentation/components/loading/loading/ios.md` |
| Skeleton | 스켈레톤 UI | `Projects/Views/Montage/documentation/components/loading/skeleton/ios.md` |

**Navigations (네비게이션)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| Category | 카테고리 선택 | `Projects/Views/Montage/documentation/components/navigations/category/ios.md` |
| PageCounter | 숫자 페이지 표시기 | `Projects/Views/Montage/documentation/components/navigations/pagecounter/ios.md` |
| PaginationDots | 점 페이지 표시기 | `Projects/Views/Montage/documentation/components/navigations/paginationdots/ios.md` |
| ProgressIndicator | 진행 인디케이터 | `Projects/Views/Montage/documentation/components/navigations/progressindicator/ios.md` |
| ProgressTracker | 단계별 진행 표시 | `Projects/Views/Montage/documentation/components/navigations/progresstracker/ios.md` |
| Tab | 탭 메뉴 | `Projects/Views/Montage/documentation/components/navigations/tab/ios.md` |
| TopNavigation | 상단 내비게이션 바 | `Projects/Views/Montage/documentation/components/navigations/topnavigation/ios.md` |

**Presentation (프레젠테이션)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| BottomSheet | 바텀 시트 모달 | `Projects/Views/Montage/documentation/components/presentation/bottomsheet/ios.md` |
| Popover | 팝오버 | `Projects/Views/Montage/documentation/components/presentation/popover/ios.md` |
| Popup | 팝업 모달 | `Projects/Views/Montage/documentation/components/presentation/popup/ios.md` |
| Tooltip | 툴팁 | `Projects/Views/Montage/documentation/components/presentation/tooltip/ios.md` |

**Selection & Input (선택/입력)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| Checkbox | 체크박스 | `Projects/Views/Montage/documentation/components/selection and input/checkbox/ios.md` |
| Checkmark | 체크마크 | `Projects/Views/Montage/documentation/components/selection and input/checkmark/ios.md` |
| FilterButton | 필터 버튼 | `Projects/Views/Montage/documentation/components/selection and input/filterbutton/ios.md` |
| FramedStyle | 프레임 스타일 | `Projects/Views/Montage/documentation/components/selection and input/framedstyle/ios.md` |
| Radio | 라디오 버튼 | `Projects/Views/Montage/documentation/components/selection and input/radio/ios.md` |
| SegmentedControl | 세그먼트 컨트롤 | `Projects/Views/Montage/documentation/components/selection and input/segmentedcontrol/ios.md` |
| Select | 드롭다운 선택 | `Projects/Views/Montage/documentation/components/selection and input/select/ios.md` |
| Slider | 슬라이더 | `Projects/Views/Montage/documentation/components/selection and input/slider/ios.md` |
| Switch | 스위치 | `Projects/Views/Montage/documentation/components/selection and input/switch/ios.md` |
| TextArea | 여러 줄 텍스트 입력 | `Projects/Views/Montage/documentation/components/selection and input/textarea/ios.md` |
| TextField | 단일 줄 텍스트 입력 | `Projects/Views/Montage/documentation/components/selection and input/textfield/ios.md` |

**Utilities (유틸리티)**
| 컴포넌트 | 설명 | 문서 경로 |
|---|---|---|
| Color | 디자인 시스템 컬러 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/color.md` |
| FlowLayout | 흐름 레이아웃 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/flowlayout.md` |
| Icon | 아이콘 세트 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/icon.md` |
| Interaction | 상호작용 장식 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/interaction.md` |
| ModalNavigation | 모달 내비게이션 바 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/modalnavigation.md` |
| Opacity | 투명도 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/opacity.md` |
| PullToRefresh | 당겨서 새로고침 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/pulltorefresh.md` |
| ScrollView | 커스텀 스크롤뷰 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/scrollview.md` |
| Shadow | 그림자 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/shadow.md` |
| Spacing | 간격 시스템 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/spacing.md` |
| Typography | 타이포그래피 | `Projects/Views/Montage/documentation/utilities/ios-utility-components/typography.md` |

### 3단계: API 문서 참조

식별된 각 컴포넌트와 유틸리티 토큰의 API 문서를 **반드시** 읽습니다. 문서 소스 우선순위:

**1순위: doccarchive JSON** (소스 코드에서 자동 생성된 정확한 API 스펙)
```
# 컴포넌트 개요 — initializers, methods, enums, 코드 예시 포함
Projects/Views/Montage/.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data/documentation/montage/{컴포넌트명 lowercase}.json

# 중첩 타입 세부 정보 — enum case, nested struct 등
Projects/Views/Montage/.build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive/data/documentation/montage/{컴포넌트명 lowercase}/{중첩타입 lowercase}.json
```
- 2단계에서 식별된 **모든 컴포넌트**의 doccarchive JSON을 읽을 것
- 컴포넌트에서 사용하는 enum/nested type도 함께 읽을 것 (예: Button이면 `button/variant.json`, `button/size.json`, `button/color.json`도 확인)

**2순위: markdown 문서** (doccarchive에 해당 컴포넌트가 없는 경우 fallback)
- 2단계 테이블의 문서 경로를 프로젝트 루트에서 참조

**유틸리티 토큰 문서** (항상 읽을 것):

| 토큰 | doccarchive (1순위) | markdown (2순위) |
|------|---------------------|------------------|
| Color | `montage/color.json` + `montage/color/{semantic,atomic}.json` | `Projects/Views/Montage/documentation/utilities/ios-utility-components/color.md` |
| Typography | `montage/typography.json` + `montage/typography/{variant,weight}.json` | `Projects/Views/Montage/documentation/utilities/ios-utility-components/typography.md` |
| Spacing | `montage/spacing.json` | `Projects/Views/Montage/documentation/utilities/ios-utility-components/spacing.md` |
| Icon | `montage/icon.json` | `Projects/Views/Montage/documentation/utilities/ios-utility-components/icon.md` |

> **중요**: 이 단계에서 읽은 문서가 코드 생성의 유일한 진실의 원천(single source of truth)입니다. 사전 지식이나 추측으로 API를 사용하지 마세요.

### 4단계: SwiftUI 코드 생성

다음 규칙을 따라 코드를 생성합니다:

1. **import**: `import Montage` 사용
2. **컴포넌트 우선**: 표준 SwiftUI 뷰보다 Montage 컴포넌트를 우선 사용 (예: `SwiftUI.Button` 대신 `Montage.Button`)
3. **디자인 토큰 사용**: 하드코딩된 값 대신, **3단계에서 읽은 문서에 명시된** Montage 토큰 API를 그대로 사용. 색상/타이포그래피/간격 모두 문서에서 확인한 정확한 시그니처를 따를 것
4. **피그마 속성 매핑**:
   - 피그마의 variant/property → 3단계에서 확인한 Montage enum 값으로 매핑
   - 피그마의 색상 토큰 → 3단계에서 확인한 Color 토큰으로 매핑
   - 피그마의 텍스트 스타일 → 3단계에서 확인한 Typography variant로 매핑
5. **코드 스타일**: CLAUDE.md의 Swift 문법 규칙을 따름

### 5단계: API 검증

생성한 코드에서 사용한 Montage API가 실제로 존재하는지 검증합니다.

1. 코드에서 사용한 모든 Montage 타입, initializer, modifier, enum case를 목록으로 추출
2. 각 항목이 3단계에서 읽은 doccarchive/문서에 **실제로 존재하는지** 대조
3. 문서에서 확인할 수 없는 API가 있다면, Swift 소스 파일에서 직접 확인:
   ```
   Projects/Views/Montage/Sources/Montage/{컴포넌트명}.swift
   ```
4. 존재하지 않는 API를 사용한 경우, 문서에서 확인된 올바른 API로 교체

### 6단계: 결과 출력

생성된 코드와 함께 다음을 출력합니다:
- 사용된 Montage 컴포넌트 목록
- 5단계 검증 결과 (수정된 API가 있다면 무엇을 왜 바꿨는지)
- 피그마 디자인과 1:1 매핑이 되지 않는 부분이 있다면 설명
- Montage에 없는 커스텀 UI가 필요한 부분이 있다면 안내
