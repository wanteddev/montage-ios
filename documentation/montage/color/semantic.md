---
title: Color.Semantic
description: 디자인 시스템에서 정의된 Semantic 컬러 값
---

```swift
enum Semantic
```

## Overview

Semantic 색상은 Atomic 색상을 참조하여 의미적 맥락에 따라 적절한 색상을 제공합니다. 다크 모드와 라이트 모드에서 자동으로 적절한 색상으로 변환됩니다.

각 컬러 모드별 색상은 Figma의 [Color - Semantic](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-32983.md) 를 참고하세요.

```swift
// UIKit에서 사용
label.textColor = UIColor.semantic(.labelNormal)

// SwiftUI에서 사용
Button("버튼") { }
    .foregroundColor(.semantic(.primaryNormal))
    .background(Color.semantic(.backgroundNormal))
```

>  Note
>
> 컴포넌트 개발 시 Atomic 색상보다 Semantic 색상을 우선적으로 사용하는 것이 권장됩니다.

## Topics

### Enumeration Cases


``case accentBackgroundCyan``

시안색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-cyan` 토큰과 대응되는 값입니다.

``case accentBackgroundLightBlue``

하늘색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-lightBlue` 토큰과 대응되는 값입니다.

``case accentBackgroundLime``

라임색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-lime` 토큰과 대응되는 값입니다.

``case accentBackgroundPink``

분홍색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-pink` 토큰과 대응되는 값입니다.

``case accentBackgroundPurple``

자주색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-purple` 토큰과 대응되는 값입니다.

``case accentBackgroundRedOrange``

붉은 주황색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-redOrange` 토큰과 대응되는 값입니다.

``case accentBackgroundViolet``

보라색 강조 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-background-violet` 토큰과 대응되는 값입니다.

``case accentForegroundBlue``

파란색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-blue` 토큰과 대응되는 값입니다.

``case accentForegroundCyan``

시안색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-cyan` 토큰과 대응되는 값입니다.

``case accentForegroundGreen``

초록색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-green` 토큰과 대응되는 값입니다.

``case accentForegroundLightBlue``

하늘색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-lightBlue` 토큰과 대응되는 값입니다.

``case accentForegroundLime``

라임색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-lime` 토큰과 대응되는 값입니다.

``case accentForegroundOrange``

주황색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-orange` 토큰과 대응되는 값입니다.

``case accentForegroundPink``

분홍색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-pink` 토큰과 대응되는 값입니다.

``case accentForegroundPurple``

자주색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-purple` 토큰과 대응되는 값입니다.

``case accentForegroundRed``

빨간색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-red` 토큰과 대응되는 값입니다.

``case accentForegroundRedOrange``

붉은 주황색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-redOrange` 토큰과 대응되는 값입니다.

``case accentForegroundViolet``

보라색 강조 전경 색상
- **Discussion**

  Figma상의 `.color-semantic-accent-foreground-violet` 토큰과 대응되는 값입니다.

``case backgroundElevated``

상승된 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-background-elevated-normal` 토큰과 대응되는 값입니다.

``case backgroundElevatedAlternative``

상승된 대체 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-background-elevated-alternative` 토큰과 대응되는 값입니다.

``case backgroundNormal``

기본 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-background-normal-normal` 토큰과 대응되는 값입니다.

``case backgroundNormalAlternative``

대체 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-background-normal-alternative` 토큰과 대응되는 값입니다.

``case fillAlternative``

대체 채우기 색상
- **Discussion**

  Figma상의 `.color-semantic-fill-alternative` 토큰과 대응되는 값입니다.

``case fillNormal``

기본 채우기 색상
- **Discussion**

  Figma상의 `.color-semantic-fill-normal` 토큰과 대응되는 값입니다.

``case fillStrong``

강조된 채우기 색상
- **Discussion**

  Figma상의 `.color-semantic-fill-strong` 토큰과 대응되는 값입니다.

``case interactionDisable``

비활성화된 상호작용 색상
- **Discussion**

  Figma상의 `.color-semantic-interaction-disable` 토큰과 대응되는 값입니다.

``case interactionInactive``

비활성화된 상호작용 색상
- **Discussion**

  Figma상의 `.color-semantic-interaction-inactive` 토큰과 대응되는 값입니다.

``case inverseBackground``

역전된 배경 색상
- **Discussion**

  Figma상의 `.color-semantic-inverse-background` 토큰과 대응되는 값입니다.

``case inverseLabel``

역전된 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-inverse-label` 토큰과 대응되는 값입니다.

``case inversePrimary``

역전된 주요 색상
- **Discussion**

  Figma상의 `.color-semantic-inverse-primary` 토큰과 대응되는 값입니다.

``case labelAlternative``

대체 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-label-alternative` 토큰과 대응되는 값입니다.

``case labelAssistive``

보조 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-label-assistive` 토큰과 대응되는 값입니다.

``case labelDisable``

비활성화된 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-label-disable` 토큰과 대응되는 값입니다.

``case labelNeutral``

중립적인 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-label-neutral` 토큰과 대응되는 값입니다.

``case labelNormal``

기본 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-label-normal` 토큰과 대응되는 값입니다.

``case labelStrong``

강조된 라벨 색상
- **Discussion**

  Figma상의 `.color-semantic-label-strong` 토큰과 대응되는 값입니다.

``case lineAlternative``

대체 선 색상
- **Discussion**

  Figma상의 `.color-semantic-line-alternative` 토큰과 대응되는 값입니다.

``case lineNeutral``

중립적인 선 색상
- **Discussion**

  Figma상의 `.color-semantic-line-neutral` 토큰과 대응되는 값입니다.

``case lineNormal``

기본 선 색상
- **Discussion**

  Figma상의 `.color-semantic-line-normal` 토큰과 대응되는 값입니다.

``case lineSolidAlternative``

대체 실선 색상
- **Discussion**

  Figma상의 `.color-semantic-line-solid-alternative` 토큰과 대응되는 값입니다.

``case lineSolidNeutral``

중립적인 실선 색상
- **Discussion**

  Figma상의 `.color-semantic-line-solid-neutral` 토큰과 대응되는 값입니다.

``case lineSolidNormal``

기본 실선 색상
- **Discussion**

  Figma상의 `.color-semantic-line-solid-normal` 토큰과 대응되는 값입니다.

``case materialDimmer``

어두운 재질 색상
- **Discussion**

  Figma상의 `.color-semantic-material-dimmer` 토큰과 대응되는 값입니다.

``case primaryHeavy``

매우 강조된 주요 색상
- **Discussion**

  Figma상의 `.color-semantic-primary-heavy` 토큰과 대응되는 값입니다.

``case primaryNormal``

기본 주요 색상
- **Discussion**

  Figma상의 `.color-semantic-primary-normal` 토큰과 대응되는 값입니다.

``case primaryStrong``

강조된 주요 색상
- **Discussion**

  Figma상의 `.color-semantic-primary-strong` 토큰과 대응되는 값입니다.

``case staticBlack``

정적 검은색 색상
- **Discussion**

  Figma상의 `.color-semantic-static-black` 토큰과 대응되는 값입니다.

``case staticWhite``

정적 흰색 색상
- **Discussion**

  Figma상의 `.color-semantic-static-white` 토큰과 대응되는 값입니다.

``case statusCautionary``

주의 상태 색상
- **Discussion**

  Figma상의 `.color-semantic-status-cautionary` 토큰과 대응되는 값입니다.

``case statusNegative``

부정적인 상태 색상
- **Discussion**

  Figma상의 `.color-semantic-status-negative` 토큰과 대응되는 값입니다.

``case statusPositive``

긍정적인 상태 색상
- **Discussion**

  Figma상의 `.color-semantic-status-positive` 토큰과 대응되는 값입니다.

### Initializers


``init?(rawValue: String)``

### Instance Properties


``var name: String``

Semantic 색상의 이름을 반환합니다.
- **Return Value**

  색상의 이름 문자열

### Instance Methods


``func resolve(UITraitCollection) -> UIColor``

주어진 UITraitCollection에 따라 UIColor를 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `traitCollection` | 색상을 해석할 UITraitCollection |
- **Return Value**

  해석된 UIColor 인스턴스

### Default Implementations


[Equatable Implementations](/documentation/montage/color/semantic/equatable-implementations.md)

[RawRepresentable Implementations](/documentation/montage/color/semantic/rawrepresentable-implementations.md)

## Relationships

Conforms To

`ColorResolvable`

`Swift.CaseIterable`

`Swift.Equatable`

`Swift.Hashable`

`Swift.RawRepresentable`



