# Montage

Wanted Lab Design System for iOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![iOS](https://img.shields.io/badge/Platform-iOS-black.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS16-007ACC.svg)](https://developer.apple.com/swiftui/)

[한국어](#한국어) | [English](#english)

## 한국어

### 개요

Montage는 원티드랩에서 만든 iOS 앱 개발을 위한 디자인시스템 모듈입니다. 미리 만들어진 UI 컴포넌트와 SwiftUI/UIKit Extension을 제공하여, 일관성 있고 빠른 UI 개발을 지원합니다. 디자인 시스템에 대한 자세한 내용은 [Montage](https://montage.wanted.co.kr) 에서 확인할 수 있습니다.

Montage가 제공하는 여러 구성 요소와 사용 예시들을 한눈에 볼 수 있도록 샘플 앱 프로젝트를 제공하고 있습니다. [Sources/Blueprint](https://github.com/wanteddev/montage-ios/tree/main/Sources/Blueprint) 폴더를 참고해 주세요.

### 개발 환경

- iOS 16.0+
- Swift 5
- Xcode 16.2+

### 설치

#### Swift Package Manager

Xcode에서 File > Add Packages... 메뉴를 선택하고 다음 URL을 입력하세요:

```
https://github.com/wanteddev/montage-ios.git
```

또는 `Package.swift` 파일에 다음을 추가하세요:

```swift
dependencies: [
    .package(url: "https://github.com/wanteddev/montage-ios.git", from: "3.0.0")
]
```

### 사용법

```swift
import Montage

Button(variant: .solid, color: .primary, size: .small) {
  // some action
}
.loading(true)
```

### 문서

디자인 및 API 가이드는 [Montage](https://montage.wanted.co.kr) 사이트의 [컴포넌트](https://montage.wanted.co.kr/docs/components), [유틸리티](https://montage.wanted.co.kr/docs/utilities) 페이지에서 확인할 수 있습니다.

로컬에서 문서 사이트를 호스팅하려면 다음과 같이 실행 후 지시사항을 따르세요:

```bash
make docc
```

### 기여

Montage는 오픈소스 프로젝트이고 모든 기여를 환영하지만, 주로 원티드 디자인시스템 팀에서 정의한 디자인 스펙에 따라 수정, 배포되므로, 그 디자인 스펙에 어긋나는 기여는 거절될 수 있습니다.

#### 기여 절차

1. 프로젝트 저장소 포크: GitHub에서 저장소를 포크하세요
2. 프로젝트 클론: `git clone https://github.com/[your-username]/montage-ios.git`
3. 작업 브랜치 생성: `git checkout -b [브랜치명]`
4. 개발 작업 수행 및 커밋: `git commit -m '[작업 내용 설명]'`
5. API 문서/라이선스 업데이트 스크립트 실행: `make`
6. 포크한 저장소에 푸시: `git push origin [브랜치명]`
7. GitHub에서 Pull Request 생성 및 코드 리뷰 요청
8. 리뷰어가 검토 후 적용할 버전에 따라 필요하면 타겟 변경 요청
9. 리뷰 승인 후 머지

모든 기여는 프로젝트 메인테이너의 검토와 승인이 필요합니다. 기여해 주셔서 감사합니다!

> ⚠️ **PR을 올리기 전에 꼭 확인하세요**
>
> - 원티드 디자인시스템 팀에서 정의한 디자인 스펙에 어긋날 경우 승인이 거절될 수 있습니다.
> - PR에서 워크플로 yml 파일을 임의로 수정할 경우 승인이 거절될 수 있습니다.
> - PR을 올리기 전에 `make`를 실행해 문서 산출물이 최신 상태인지 확인하고 `documentation/` 폴더와 `THIRD_PARTY_LICENSES.md`에 변경 사항이 있다면 PR에 포함해야 합니다. 그렇지 않으면 위 7번 단계에서 PR용 워크플로(`verify-docs`)가 실패해 머지할 수 없습니다.
> - `make`에 의해 실행되는 `./generate_docc.sh` 스크립트는 Xcode 버전에 따라 생성결과가 달라지므로 정해진 버전을 사용해야 하며 이에 따라 `make` 스크립트에 의해 해당 버전이 설치될 수 있습니다.

#### 외부 기여 리뷰 가이드 (내부 개발자용)

외부 기여자의 Pull Request를 리뷰할 때 다음 사항을 확인해주세요:

##### Label 관리
- 외부 기여자는 label 변경 권한이 없어서 labeler 워크플로가 실행되지 않습니다.
- **리뷰어가 직접 label을 달아줘야** 합니다.

##### 워크플로 승인
- 외부 기여 PR에서 워크플로를 실행하기 위해서는 보안상 리뷰어의 승인이 필요합니다.
- **워크플로 실행을 승인하기 전에 워크플로 yml 파일에 수정사항이 없는지 확인**이 필요합니다.
- yml 수정을 통해 secret이나 variable이 유출될 수 있기 때문입니다.

##### 워크플로 실행 조건
- `verify-docs` 워크플로는 Swift 파일이 수정되었을 때만 실행됩니다.

##### 타겟 브랜치 변경
- 내부 작업 진행상황에 따라 필요할 경우, 외부 기여의 포함 버전에 맞는 적절한 브랜치로 타겟 변경을 요청할 수 있습니다.

#### 코드 스타일

- Swift 스타일 가이드를 준수해주세요.
- public 함수, 구조체, 클래스, 프로토콜 등에 문서화 주석(Documentation Comments)을 추가해주세요. API 문서 작성 자동화 스크립트의 구현상 아래와 같은 규칙을 지켜주셔야 합니다. 더 자세한 사항은 [DOCUMENTATION_GUIDELINES.md](https://github.com/wanteddev/montage-ios/tree/main/DOCUMENTATION_GUIDELINES.md) 파일을 참고하세요.
  - 파일 이름과 파일에 선언된 대표 컴포넌트(UIView, View, ViewModifier, Layout 등) 이름이 동일해야 합니다.
  - 대표 컴포넌트와 연관된 타입이나 extension, protocol 등은 같은 파일에 정의하는 것을 원칙으로 합니다.
  - public 인 View 구조체는 Inner Type으로 정의하지 않습니다.

### 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고해 주세요.

### 문의

문의사항이나 제안사항이 있으시면 [이슈](https://github.com/wanteddev/montage-ios/issues)를 생성해 주세요.

## English

### Overview

Montage is a design system module for iOS app development created by Wanted Lab. It provides pre-built UI components and SwiftUI/UIKit Extensions to support consistent and fast UI development. For more details about the design system, please visit [Montage](https://montage.wanted.co.kr).

We provide a sample app project to showcase the various components and usage examples offered by Montage. Please refer to the [Sources/Blueprint](https://github.com/wanteddev/montage-ios/tree/main/Sources/Blueprint) folder.

### Development Environment

- iOS 16.0+
- Swift 5
- Xcode 16.2+

### Installation

#### Swift Package Manager

In Xcode, select File > Add Packages... and enter the following URL:

```
https://github.com/wanteddev/montage-ios.git
```

Or add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/wanteddev/montage-ios.git", from: "3.0.0")
]
```

### Usage

```swift
import Montage

Button(variant: .solid, color: .primary, size: .small) {
  // some action
}
.loading(true)
```

### Documentation

Design and API guides are available on the [Montage](https://montage.wanted.co.kr) site's [Components](https://montage.wanted.co.kr/docs/components) and [Utilities](https://montage.wanted.co.kr/docs/utilities) pages.

To host the documentation site locally, run the following and follow the instructions:

```bash
make docc
```

### Contributing

Montage is an open source project and welcomes all contributions. However, it is primarily maintained and distributed according to the design specifications defined by the Wanted Design System team. Contributions that deviate from these design specifications may be rejected.

#### Contribution Process

1. Fork the repository: Fork the repository on GitHub
2. Clone the project: `git clone https://github.com/[your-username]/montage-ios.git`
3. Create a branch: `git checkout -b [branch-name]`
4. Make changes and commit: `git commit -m '[description of changes]'`
5. Run API documentation/license update script: `make`
6. Push to your fork: `git push origin [branch-name]`
7. Create a Pull Request on GitHub and request code review
8. Reviewer may request target branch change based on the version for which the changes are intended
9. Merge after review approval

All contributions require review and approval by the project maintainers. Thank you for contributing!

> ⚠️ **Please check before submitting a PR**
>
> - Contributions that deviate from the design specifications defined by the Wanted Design System team may be rejected.
> - PRs that arbitrarily modify workflow yml files may be rejected.
> - Before submitting a PR, run `make` to ensure documentation outputs are up to date. If there are changes in the `documentation/` folder or `THIRD_PARTY_LICENSES.md`, they must be included in the PR. Otherwise, the PR workflow (`verify-docs`) at step 7 above will fail and the PR cannot be merged.
> - The `./generate_docc.sh` script executed by `make` produces different results depending on the Xcode version, so a specific version must be used. The `make` script may install that version accordingly.

#### External Contributor Review Guide (For Internal Developers)

When reviewing Pull Requests from external contributors, please check the following:

##### Label Management
- External contributors do not have permission to change labels, so the labeler workflow will not run.
- **Reviewers must manually add labels**.

##### Workflow Approval
- Workflow execution for external contributor PRs requires reviewer approval for security reasons.
- **Before approving workflow execution, verify that there are no modifications to workflow yml files**.
- This is because secrets or variables could be leaked through yml modifications.

##### Workflow Execution Conditions
- The `verify-docs` workflow runs only when Swift files are modified.

##### Target Branch Change
- Depending on internal work progress, you may request a target branch change to an appropriate branch matching the version for which the external contribution is intended.

#### Code Style

- Please follow the Swift style guide.
- Please add documentation comments to public functions, structs, classes, protocols, etc. Due to the implementation of the API documentation automation script, please follow these rules. For more details, please refer to the [DOCUMENTATION_GUIDELINES.md](https://github.com/wanteddev/montage-ios/tree/main/DOCUMENTATION_GUIDELINES.md) file.
  - The file name must match the name of the main component (UIView, View, ViewModifier, Layout, etc.) declared in the file.
  - Types, extensions, protocols, etc. related to the main component should be defined in the same file as a general rule.
  - Public View structs should not be defined as Inner Types.

### License

This project is licensed under the MIT License. For details, please refer to the [LICENSE](LICENSE) file.

### Contact

If you have any questions or suggestions, please create an [issue](https://github.com/wanteddev/montage-ios/issues).
