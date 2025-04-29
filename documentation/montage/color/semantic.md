Enumeration

# Color.Semantic 

디자인 시스템에서 정의된 Semantic 컬러 값

```swift
enum Semantic
```

## Overview 

Semantic 색상은 Atomic 색상을 참조하여 의미적 맥락에 따라 적절한 색상을 제공합니다. 다크 모드와 라이트 모드에서 자동으로 적절한 색상으로 변환됩니다.

각 컬러 모드별 색상은 Figma의 [Color - Semantic](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-32983)

 를 참고하세요.

**사용 예시**:

```swift
// UIKit에서 사용
label.textColor = UIColor.semantic(.labelNormal)

// SwiftUI에서 사용
Button("버튼") { }
    .foregroundColor(.semantic(.primaryNormal))
    .background(Color.semantic(.backgroundNormal))
```

> **Note**
>
> 컴포넌트 개발 시 Atomic 색상보다 Semantic 색상을 우선적으로 사용하는 것이 권장됩니다.

## Topics 

### Enumeration Cases 

- [case accentBackgroundCyan](/documentation/montage/color/semantic/accentbackgroundcyan.md)

  Figma상의 .color-semantic-accent-background-cyan 토큰과 대응되는 값입니다.

- [case accentBackgroundLightBlue](/documentation/montage/color/semantic/accentbackgroundlightblue.md)

  Figma상의 .color-semantic-accent-background-lightBlue 토큰과 대응되는 값입니다.

- [case accentBackgroundLime](/documentation/montage/color/semantic/accentbackgroundlime.md)

  Figma상의 .color-semantic-accent-background-lime 토큰과 대응되는 값입니다.

- [case accentBackgroundPink](/documentation/montage/color/semantic/accentbackgroundpink.md)

  Figma상의 .color-semantic-accent-background-pink 토큰과 대응되는 값입니다.

- [case accentBackgroundPurple](/documentation/montage/color/semantic/accentbackgroundpurple.md)

  Figma상의 .color-semantic-accent-background-purple 토큰과 대응되는 값입니다.

- [case accentBackgroundRedOrange](/documentation/montage/color/semantic/accentbackgroundredorange.md)

  Figma상의 .color-semantic-accent-background-redOrange 토큰과 대응되는 값입니다.

- [case accentBackgroundViolet](/documentation/montage/color/semantic/accentbackgroundviolet.md)

  Figma상의 .color-semantic-accent-background-violet 토큰과 대응되는 값입니다.

- [case accentForegroundBlue](/documentation/montage/color/semantic/accentforegroundblue.md)

  Figma상의 .color-semantic-accent-foreground-blue 토큰과 대응되는 값입니다.

- [case accentForegroundCyan](/documentation/montage/color/semantic/accentforegroundcyan.md)

  Figma상의 .color-semantic-accent-foreground-cyan 토큰과 대응되는 값입니다.

- [case accentForegroundGreen](/documentation/montage/color/semantic/accentforegroundgreen.md)

  Figma상의 .color-semantic-accent-foreground-green 토큰과 대응되는 값입니다.

- [case accentForegroundLightBlue](/documentation/montage/color/semantic/accentforegroundlightblue.md)

  Figma상의 .color-semantic-accent-foreground-lightBlue 토큰과 대응되는 값입니다.

- [case accentForegroundLime](/documentation/montage/color/semantic/accentforegroundlime.md)

  Figma상의 .color-semantic-accent-foreground-lime 토큰과 대응되는 값입니다.

- [case accentForegroundOrange](/documentation/montage/color/semantic/accentforegroundorange.md)

  Figma상의 .color-semantic-accent-foreground-orange 토큰과 대응되는 값입니다.

- [case accentForegroundPink](/documentation/montage/color/semantic/accentforegroundpink.md)

  Figma상의 .color-semantic-accent-foreground-pink 토큰과 대응되는 값입니다.

- [case accentForegroundPurple](/documentation/montage/color/semantic/accentforegroundpurple.md)

  Figma상의 .color-semantic-accent-foreground-purple 토큰과 대응되는 값입니다.

- [case accentForegroundRed](/documentation/montage/color/semantic/accentforegroundred.md)

  Figma상의 .color-semantic-accent-foreground-red 토큰과 대응되는 값입니다.

- [case accentForegroundRedOrange](/documentation/montage/color/semantic/accentforegroundredorange.md)

  Figma상의 .color-semantic-accent-foreground-redOrange 토큰과 대응되는 값입니다.

- [case accentForegroundViolet](/documentation/montage/color/semantic/accentforegroundviolet.md)

  Figma상의 .color-semantic-accent-foreground-violet 토큰과 대응되는 값입니다.

- [case backgroundElevated](/documentation/montage/color/semantic/backgroundelevated.md)

  Figma상의 .color-semantic-background-elevated-normal 토큰과 대응되는 값입니다.

- [case backgroundElevatedAlternative](/documentation/montage/color/semantic/backgroundelevatedalternative.md)

  Figma상의 .color-semantic-background-elevated-alternative 토큰과 대응되는 값입니다.

- [case backgroundNormal](/documentation/montage/color/semantic/backgroundnormal.md)

  Figma상의 .color-semantic-background-normal-normal 토큰과 대응되는 값입니다.

- [case backgroundNormalAlternative](/documentation/montage/color/semantic/backgroundnormalalternative.md)

  Figma상의 .color-semantic-background-normal-alternative 토큰과 대응되는 값입니다.

- [case fillAlternative](/documentation/montage/color/semantic/fillalternative.md)

  Figma상의 .color-semantic-fill-alternative 토큰과 대응되는 값입니다.

- [case fillNormal](/documentation/montage/color/semantic/fillnormal.md)

  Figma상의 .color-semantic-fill-normal 토큰과 대응되는 값입니다.

- [case fillStrong](/documentation/montage/color/semantic/fillstrong.md)

  Figma상의 .color-semantic-fill-strong 토큰과 대응되는 값입니다.

- [case interactionDisable](/documentation/montage/color/semantic/interactiondisable.md)

  Figma상의 .color-semantic-interaction-disable 토큰과 대응되는 값입니다.

- [case interactionInactive](/documentation/montage/color/semantic/interactioninactive.md)

  Figma상의 .color-semantic-interaction-inactive 토큰과 대응되는 값입니다.

- [case inverseBackground](/documentation/montage/color/semantic/inversebackground.md)

  Figma상의 .color-semantic-inverse-background 토큰과 대응되는 값입니다.

- [case inverseLabel](/documentation/montage/color/semantic/inverselabel.md)

  Figma상의 .color-semantic-inverse-label 토큰과 대응되는 값입니다.

- [case inversePrimary](/documentation/montage/color/semantic/inverseprimary.md)

  Figma상의 .color-semantic-inverse-primary 토큰과 대응되는 값입니다.

- [case labelAlternative](/documentation/montage/color/semantic/labelalternative.md)

  Figma상의 .color-semantic-label-alternative 토큰과 대응되는 값입니다.

- [case labelAssistive](/documentation/montage/color/semantic/labelassistive.md)

  Figma상의 .color-semantic-label-assistive 토큰과 대응되는 값입니다.

- [case labelDisable](/documentation/montage/color/semantic/labeldisable.md)

  Figma상의 .color-semantic-label-disable 토큰과 대응되는 값입니다.

- [case labelNeutral](/documentation/montage/color/semantic/labelneutral.md)

  Figma상의 .color-semantic-label-neutral 토큰과 대응되는 값입니다.

- [case labelNormal](/documentation/montage/color/semantic/labelnormal.md)

  Figma상의 .color-semantic-label-normal 토큰과 대응되는 값입니다.

- [case labelStrong](/documentation/montage/color/semantic/labelstrong.md)

  Figma상의 .color-semantic-label-strong 토큰과 대응되는 값입니다.

- [case lineAlternative](/documentation/montage/color/semantic/linealternative.md)

  Figma상의 .color-semantic-line-alternative 토큰과 대응되는 값입니다.

- [case lineNeutral](/documentation/montage/color/semantic/lineneutral.md)

  Figma상의 .color-semantic-line-neutral 토큰과 대응되는 값입니다.

- [case lineNormal](/documentation/montage/color/semantic/linenormal.md)

  Figma상의 .color-semantic-line-normal 토큰과 대응되는 값입니다.

- [case lineSolidAlternative](/documentation/montage/color/semantic/linesolidalternative.md)

  Figma상의 .color-semantic-line-solid-alternative 토큰과 대응되는 값입니다.

- [case lineSolidNeutral](/documentation/montage/color/semantic/linesolidneutral.md)

  Figma상의 .color-semantic-line-solid-neutral 토큰과 대응되는 값입니다.

- [case lineSolidNormal](/documentation/montage/color/semantic/linesolidnormal.md)

  Figma상의 .color-semantic-line-solid-normal 토큰과 대응되는 값입니다.

- [case materialDimmer](/documentation/montage/color/semantic/materialdimmer.md)

  Figma상의 .color-semantic-material-dimmer 토큰과 대응되는 값입니다.

- [case primaryHeavy](/documentation/montage/color/semantic/primaryheavy.md)

  Figma상의 .color-semantic-primary-heavy 토큰과 대응되는 값입니다.

- [case primaryNormal](/documentation/montage/color/semantic/primarynormal.md)

  Figma상의 .color-semantic-primary-normal 토큰과 대응되는 값입니다.

- [case primaryStrong](/documentation/montage/color/semantic/primarystrong.md)

  Figma상의 .color-semantic-primary-strong 토큰과 대응되는 값입니다.

- [case staticBlack](/documentation/montage/color/semantic/staticblack.md)

  Figma상의 .color-semantic-static-black 토큰과 대응되는 값입니다.

- [case staticWhite](/documentation/montage/color/semantic/staticwhite.md)

  Figma상의 .color-semantic-static-white 토큰과 대응되는 값입니다.

- [case statusCautionary](/documentation/montage/color/semantic/statuscautionary.md)

  Figma상의 .color-semantic-status-cautionary 토큰과 대응되는 값입니다.

- [case statusNegative](/documentation/montage/color/semantic/statusnegative.md)

  Figma상의 .color-semantic-status-negative 토큰과 대응되는 값입니다.

- [case statusPositive](/documentation/montage/color/semantic/statuspositive.md)

  Figma상의 .color-semantic-status-positive 토큰과 대응되는 값입니다.

### Initializers 

- [init?(rawValue: String)](/documentation/montage/color/semantic/init(rawvalue:).md)

### Instance Properties 

- [var name: String](/documentation/montage/color/semantic/name.md)

### Instance Methods 

- [func resolve(UITraitCollection) -> UIColor](/documentation/montage/color/semantic/resolve(_:).md)

  주어진 UITraitCollection에 따라 UIColor를 반환합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/color/semantic/equatable-implementations.md)

- [API ReferenceRawRepresentable Implementations](/documentation/montage/color/semantic/rawrepresentable-implementations.md)

## Relationships 

### Conforms To 

- [ColorResolvable](/documentation/montage/colorresolvable.md)
- Swift.CaseIterable
- Swift.Equatable
- Swift.Hashable
- Swift.RawRepresentable

