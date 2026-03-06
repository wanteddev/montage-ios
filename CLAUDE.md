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

## Documentation Workflow

Swift 소스 파일(`Sources/Montage/`)을 수정한 후에는 반드시 `make`를 실행하여 `documentation/` 폴더와 `THIRD_PARTY_LICENSES.md`를 갱신해야 한다. CI의 `verify-docs` 워크플로우가 이를 검증한다.

`make` 실행 시 `Makefile`의 `XCODE_VERSION` 변수에 지정된 Xcode 버전이 필요하다 (현재 26.2).

## Commit Convention

[Conventional Commits](https://www.conventionalcommits.org/) 사용: `<type>(<scope>): <description>`

타입: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Versioning

시맨틱 버저닝(SemVer) 준수. Breaking change는 메이저 업데이트 시에만 반영. 메이저 업데이트 기간이 아닌 경우 `@available(*, deprecated)` 처리 후 메이저 업데이트 때 제거한다.

## Git Workflow

- 브랜치: `main`에서 분기하여 `main`으로 PR, 두 개 이상의 버전을 한 번에 작업할 때는 `release/x.x.x`에서 분기하여 `release/x.x.x`로 PR
- PR 제출 전 `make` 실행하여 문서 변경사항 포함
- GitHub Actions 워크플로우 yml 파일 수정 PR은 거부될 수 있음
