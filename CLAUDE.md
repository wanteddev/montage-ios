# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Montage는 Wanted Lab의 iOS 디자인 시스템으로, SwiftUI 기반의 SPM(Swift Package Manager) 패키지이다. iOS 16.0+을 지원하며 Swift 5로 작성되어 있다. 상위 프로젝트(Wanted iOS 앱)의 Views 프레임워크에서 의존성으로 사용된다.

## Build & Development Commands

```bash
# Xcode workspace 열기
open Montage.xcworkspace

# 문서 생성 (DocC -> Markdown -> 라이선스, Xcode 버전 확인 포함)
make

# DocC 문서만 생성
make docc

# 로컬 문서 서버 실행 (make docc 이후)
make server
```

## Architecture

### Source Structure

```
Sources/
  Montage/
    1 Components/       # UI 컴포넌트 (번호 접두사로 카테고리 정렬)
      2 Actions/        # Button, IconButton, TextButton, FilterButton 등
      3 Selection And Input/  # Checkbox, Radio, Select, TextField, TextArea, Switch 등
      4 Contents/       # Avatar, Card, ListCell, Thumbnail, Typography 등
      5 Loading/        # Loading, Skeleton, ProgressIndicator 등
      6 Navigations/    # Tab, TopNavigation, SegmentedControl 등
      7 Feedback/       # Toast, SnackBar, Tooltip 등
      8 Presentation/   # BottomSheet, Popup, Popover 등
      9 Utilities/      # Color, Icon, Spacing, Shadow, Opacity 등
    2 Utilities/        # 확장(Extension), 모디파이어(Modifiers), 프로토콜(Protocols)
    Asset/              # Color.xcassets, Icon.xcassets, Image.xcassets, Lottie
  Blueprint/            # 컴포넌트 쇼케이스 샘플 앱 (Xcode 프로젝트)
```

### Dependencies

- **Pretendard** (pretendard-ios): 폰트
- **Lottie** (lottie-ios 4.5.0): 애니메이션
- **SDWebImageSwiftUI** (3.0.0+): 원격 이미지 로딩
- **swift-docc-plugin**: 문서 생성용 (런타임 의존성 아님)

## Code Conventions

### 파일명 = 타입명

파일명(`.swift` 제거)이 DocC 문서의 컴포넌트 제목으로 사용된다. 파일 내 주요 `public struct`/`enum` 이름과 파일명을 반드시 일치시켜야 한다. 예: `Button.swift` -> `public struct Button`.

### public 키워드 필수

`docc_to_md.js` 스크립트가 `public` 키워드를 정규식으로 파싱하여 문서화한다. `public`이 없으면 문서에 나타나지 않는다.

### 관련 타입은 같은 파일에

메인 컴포넌트와 관련된 extension, protocol 등은 같은 파일에 정의한다. Public View struct는 Inner Type으로 정의하지 않는다.

### 슬롯 프리셋은 `컴포넌트.Resource.슬롯명`

컴포넌트가 슬롯(leading, trailing 등)에 넣을 요소의 프리셋을 제공할 때는 `Resource`를 네임스페이스로 두고 슬롯별 enum을 정의한다.

```swift
extension ListCell {
    public enum Resource {
        public enum Leading {
            case icon(_ icon: Icon, tintColor: SwiftUI.Color = ...)
            case slotView(() -> AnyView)

            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Leading {
                .slotView { AnyView(content()) }
            }
        }

        public enum Trailing { /* ... */ }
    }
}
```

규칙:

- 슬롯 제약은 타입 분리로 컴파일 단계에서 막는다. 런타임 필터로 걸러내면 잘못 넘긴 요소가 아무 신호 없이 사라져 알아챌 수 없다.
- 슬롯 enum 이름은 슬롯 이름을 그대로 쓴다(`Leading`, `Trailing`, `LabelTrailing`, `Extra`). `Info` 같은 접미사는 붙이지 않는다.
- 프리셋에 없는 구성은 `slot(_:)` 하나로만 연다. `case slotView(() -> AnyView)`를 두고 `@ViewBuilder` 팩토리로 감싸 사용처가 `AnyView`를 직접 만들지 않게 한다.
- 렌더링은 `extension 컴포넌트.Resource.슬롯명`의 `view`(크기 등 컨텍스트가 필요하면 `view(size:)`)에 두고, 슬롯이 공유하는 렌더링은 `extension 컴포넌트.Resource`의 `fileprivate static` 헬퍼로 뽑는다.

모디파이어 형태와 개수 제한은 컴포넌트 사정에 맞춘다. `TextArea`는 좁은 입력 필드 안이라 `bottomResources(leading:trailing:)` 하나로 받고 슬롯당 3개로 제한하며, `ListCell`은 슬롯 4개가 셀 안 서로 다른 위치에 있어 슬롯별 모디파이어를 따로 둔다.

적용 컴포넌트: `TextArea`, `TopNavigation`, `ListCell`.

### docstring 마크다운 서식 (틸드 이스케이프 필수)

DocC는 docstring을 Markdown으로 파싱하며 **단일 `~`도 취소선으로 해석**한다. `~`를 숫자 범위 구분자로 쓰면(예: `65~90%`) 한 문단의 두 `~`가 짝지어져 텍스트가 취소선 처리되어 문서가 깨진다. **범위 표기의 `~`는 반드시 `\~`로 이스케이프**한다(예: `65\~90%, 40\~55%`). 볼드·이탤릭·심볼 링크는 그대로 보존되므로 의도적으로 사용해도 된다. 상세는 [DOCUMENTATION_GUIDELINES.ko.md](./DOCUMENTATION_GUIDELINES.ko.md) §9 참고. (`make` 실행 시 취소선이 감지되면 변환기가 경고를 출력한다.)

## Documentation Workflow

Swift 소스 파일(`Sources/Montage/`)을 수정한 후에는 반드시 `make`를 실행하여 `documentation/` 폴더와 `THIRD_PARTY_LICENSES.md`를 갱신해야 한다. CI의 `verify-docs` 워크플로우가 이를 검증한다.

`make` 실행 시 `Makefile`의 `XCODE_VERSION` 변수에 지정된 Xcode 버전이 필요하다 (현재 26.2).

## Commit Convention

[Conventional Commits](https://www.conventionalcommits.org/) 사용: `<type>(<scope>): <description>`

타입: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

커밋 메시지 요약(`<description>`)은 **한국어로 작성**한다(코드 용어·식별자는 영어 허용).

## Versioning

시맨틱 버저닝(SemVer) 준수. Breaking change는 메이저 업데이트 시에만 반영. 메이저 업데이트 기간이 아닌 경우 `@available(*, deprecated)` 처리 후 메이저 업데이트 때 제거한다.

## Git Workflow

- 브랜치: `main`에서 분기하여 `main`으로 PR, 두 개 이상의 버전을 한 번에 작업할 때는 `release/x.x.x`에서 분기하여 `release/x.x.x`로 PR
- PR 제출 전 `make` 실행하여 문서 변경사항 포함
- GitHub Actions 워크플로우 yml 파일 수정 PR은 거부될 수 있음
