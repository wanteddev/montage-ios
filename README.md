# Montage

Wanted Lab Design System for iOS

## Overview

Montage는 원티드랩에서 만든 iOS 앱 개발을 위한 디자인시스템 모듈입니다. 미리 만들어진 UI 컴포넌트와 SwiftUI/UIKit Extension을 제공하여, 일관성 있고 빠른 UI 개발을 지원합니다. 디자인 시스템에 대한 자세한 내용은 https://montage.wanted.co.kr 에서 확인할 수 있습니다.

Montage가 제공하는 여러 구성 요소와 사용 예시들을 한눈에 볼 수 있도록 샘플 앱 프로젝트를 제공하고 있습니다. [Sources/Blueprint](https://github.com/wanteddev/montage-ios/tree/main/Sources/Blueprint) 폴더를 참고해 주세요.

## Requirements

- iOS 16.0+
- Swift 5.7+
- Xcode 16.0+

## Installation

### Swift Package Manager

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

## Usage

```swift
import Montage

Button(variant: .solid, color: .primary, size: .small) {
  // some action
}
.loading(true)
```

## Documentation

자세한 API 문서는 [Components](https://montage.wanted.co.kr/docs/components), [Utilities](https://montage.wanted.co.kr/docs/utilities)에서 확인할 수 있습니다.

로컬에서 문서 사이트를 호스팅하려면 [scripts/generate_docc.sh](https://github.com/wanteddev/montage-ios/blob/main/scripts/generate_docc.sh) 스크립트를 실행 후 지시사항을 따르세요:

```bash
./scripts/generate_docc.sh
```

## Contributing

Montage는 오픈소스 프로젝트이고 모든 기여를 환영하지만, 주로 원티드 디자인시스템 팀에서 정의한 디자인 스펙에 따라 수정, 배포되므로, 그 디자인 스펙에 어긋나는 기여는 거절될 수 있습니다.

### Contribution Process

1. 프로젝트 저장소 포크: GitHub에서 저장소를 포크하세요
2. 프로젝트 클론: `git clone https://github.com/[your-username]/montage-ios.git`
3. 작업 브랜치 생성: `git checkout -b [브랜치명]`
4. 개발 작업 수행 및 커밋: `git commit -m '[작업 내용 설명]'`
5. 문서/라이선스 스크립트 실행: `./scripts/generate_docc.sh`, `node scripts/docc_to_md.js`, `node scripts/generate_third_party_licenses.mjs`
6. 포크한 저장소에 푸시: `git push origin [브랜치명]`
7. GitHub에서 Pull Request 생성 및 코드 리뷰 요청
8. 리뷰 승인 후 머지

모든 기여는 프로젝트 메인테이너의 검토와 승인이 필요합니다. 기여해 주셔서 감사합니다!

> ⚠️ **PR을 올리기 전에 꼭 확인하세요**
>
> - `./scripts/generate_docc.sh && node scripts/docc_to_md.js`를 실행해 문서 산출물이 최신 상태인지 확인하고 변경 사항이 있다면 커밋해야 합니다.
> - `node scripts/generate_third_party_licenses.mjs`도 실행해 `THIRD_PARTY_LICENSES.md`를 업데이트하세요.
> - 위 스크립트가 만든 diff를 커밋하지 않으면 PR용 워크플로(`verify-docs`, `third-party-licenses`)가 실패해 머지할 수 없습니다.

### Code Style

- Swift 스타일 가이드를 준수해주세요.
- public 함수, 구조체, 클래스, 프로토콜 등에 문서화 주석(Documentation Comments)을 추가해주세요. API 문서 작성 자동화 스크립트의 구현상 아래와 같은 규칙을 지켜주셔야 합니다.
  - 파일 이름과 파일에 선언된 대표 컴포넌트(UIView, View, ViewModifier, Layout 등) 이름이 동일해야 합니다.
  - 대표 컴포넌트와 연관된 타입이나 extension, protocol 등은 같은 파일에 정의하는 것을 원칙으로 합니다.
  - public 인 View 구조체는 Inner Type으로 정의하지 않습니다.
  - 더 자세한 사항은 [DOCUMENTATION_GUIDELINES.md](https://github.com/wanteddev/montage-ios/tree/main/DOCUMENTATION_GUIDELINES.md) 파일을 참고하세요.

## License

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고해 주세요.

## Contact

문의사항이나 제안사항이 있으시면 [이슈](https://github.com/wanteddev/montage-ios/issues)를 생성해 주세요.
