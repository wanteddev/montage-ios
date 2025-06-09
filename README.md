# ``Montage``

Wanted One Design System

## Overview

Montage는 원티드랩 내부에서 UI를 작성할 때 사용할 수 있는 디자인시스템 모듈입니다. 이 모듈은 미리 만들어진 여러 엘리먼트들과 시스템 UI 프레임워크의 Extension 등을 제공하여, 조직에서 요구되는 UI 결과물을 빠르고 일관성 있게 제작할 수 있도록 돕습니다.

Montage가 제공하는 여러 구성 요소와 사용 예시들을 한눈에 볼 수 있도록 샘플 앱 프로젝트를 제공하고 있습니다. [Sources/Blueprint](https://github.com/wanteddev/montage-ios/tree/develop/Sources/Blueprint) 폴더를 참고해 주세요.

## Contribution

Montage는 원티드랩의 내부 디자인시스템으로, 회사의 디자인 가이드라인과 제품 요구사항에 맞춰 개발되고 있습니다. 현재 외부 기여는 받고 있지 않으며, 프로젝트 기여는 원티드랩 내부 개발자 및 디자이너로 제한됩니다.

### 내부 개발자 기여 절차

프로젝트에 기여하려면 다음 절차를 따라주시기 바랍니다:

1. 프로젝트 저장소 클론: `git clone https://github.com/wanteddev/montage-ios.git`
2. 작업 브랜치 생성: `git checkout -b [브랜치명]`
3. 개발 작업 수행 및 커밋: `git commit -m '[작업 내용 설명]'`
4. 원본 저장소에 푸시: `git push origin [브랜치명]`
5. GitHub에서 Pull Request 생성 및 코드 리뷰 요청
6. 리뷰 승인 후 머지

### 코드 스타일

- 원티드랩의 Swift 스타일 가이드를 준수해주세요.
- public 함수, 구조체, 클래스, 프로토콜 등에 문서화 주석(Documentation Comments)을 추가해주세요. API 문서 작성 자동화 스크립트의 구현상 아래와 같은 규칙을 지켜주셔야 합니다.
  - 파일 이름과 파일에 선언된 대표 컴포넌트(UIView, View, ViewModifier, Layout 등) 이름이 동일해야 합니다.
  - 대표 컴포넌트와 연관된 타입이나 extension, protocol 등은 같은 파일에 정의하는 것을 원칙으로 합니다.
  - public 인 View 구조체는 Inner Type으로 정의하지 않습니다.

모든 기여는 동료 개발자의 검토와 승인이 필요합니다. 기여해 주셔서 감사합니다.