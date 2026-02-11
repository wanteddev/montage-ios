# Montage

Wanted Lab iOS 디자인 시스템

[English](./README.md) | [한국어](./README.ko.md)

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/wanteddev/montage-ios/blob/HEAD/LICENSE)
[![iOS](https://img.shields.io/badge/Platform-iOS-black.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS16-007ACC.svg)](https://developer.apple.com/swiftui/)

## 문서

[https://montage.wanted.co.kr](https://montage.wanted.co.kr)에서 문서를 확인할 수 있습니다.

## 설치

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

## 사용법

```swift
import Montage

Button(variant: .solid, color: .primary, size: .small) {
  // some action
}
.loading(true)
```

Montage가 제공하는 여러 구성 요소와 사용 예시들을 한눈에 볼 수 있도록 샘플 앱 프로젝트를 제공하고 있습니다. [Sources/Blueprint](https://github.com/wanteddev/montage-ios/tree/main/Sources/Blueprint) 폴더를 참고해 주세요.

## 시작하기

개발 환경 설정 및 로컬 문서 호스팅 방법은 [시작하기 가이드](./GETTINGSTARTED.md)를 참고해 주세요.

## 기여하기

기여를 환영합니다! Pull Request를 제출하기 전에 [기여 가이드](./CONTRIBUTING.md)를 읽어주세요.

## 라이선스

이 프로젝트는 [MIT 라이선스](./LICENSE)에 따라 라이선스가 부여됩니다. 서드파티 라이선스는 [THIRD_PARTY_LICENSES.md](./THIRD_PARTY_LICENSES.md)를 참고해 주세요.
