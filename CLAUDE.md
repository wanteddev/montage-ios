# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Montage는 Wanted Lab의 iOS 디자인 시스템으로, SwiftUI 기반의 SPM(Swift Package Manager) 패키지이다. iOS 16.0+을 지원하며 Swift 5로 작성되어 있다. 상위 프로젝트(Wanted iOS 앱)의 Views 프레임워크에서 의존성으로 사용된다.

## Build & Development Commands

```bash
# Xcode workspace 열기
open Montage.xcworkspace

# 문서 생성 미리보기 (DocC -> Markdown -> 라이선스 -> MCP 데이터, 현재 선택된 Xcode 사용)
make generate

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

`documentation/`, `packages/montage-mcp/data/`, `THIRD_PARTY_LICENSES.md`는 CI가 빌드머신 Xcode로 생성해 커밋한다. 로컬에서 `make`를 돌려 커밋할 필요는 없다(미리보기 용도로만 사용).

- `verify-docs`: PR 코드로 문서를 생성해 patch를 artifact로 올린다(읽기 권한만).
- `apply-docs`: 같은 레포 브랜치 PR이면 patch를 검증한 뒤 PR 브랜치에 `docs: 문서 업데이트` 커밋을 추가한다.
- `sync-docs`: 머지 후 문서가 최신이 아니면(포크 PR 등) `docs/sync-<브랜치>` 문서 업데이트 PR을 만든다.

Xcode 버전에 따라 생성 결과가 달라지므로 로컬 `make` 결과를 커밋하면 봇이 빌드머신 기준으로 다시 덮어쓸 수 있다.

## Commit Convention

[Conventional Commits](https://www.conventionalcommits.org/) 사용: `<type>(<scope>): <description>`

타입: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

커밋 메시지 요약(`<description>`)은 **한국어로 작성**한다(코드 용어·식별자는 영어 허용).

## Versioning

시맨틱 버저닝(SemVer) 준수. Breaking change는 메이저 업데이트 시에만 반영. 메이저 업데이트 기간이 아닌 경우 `@available(*, deprecated)` 처리 후 메이저 업데이트 때 제거한다.

## Git Workflow

- 브랜치: `main`에서 분기하여 `main`으로 PR, 두 개 이상의 버전을 한 번에 작업할 때는 `release/x.x.x`에서 분기하여 `release/x.x.x`로 PR
- 문서 생성물은 CI가 PR에 자동으로 커밋한다
- GitHub Actions 워크플로우 yml 파일 수정 PR은 거부될 수 있음
