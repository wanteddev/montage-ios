**ENUM**

# `Color.Semantic`

```swift
public enum Semantic: String, CaseIterable, ColorResolvable
```

디자인 시스템에서 정의된 Semantic 컬러 값

Semantic 색상은 Atomic 색상을 참조하여 의미적 맥락에 따라 
적절한 색상을 제공합니다. 다크 모드와 라이트 모드에서 
자동으로 적절한 색상으로 변환됩니다.

각 컬러 모드별 색상은 Figma의 [Color - Semantic](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-32983) 를 참고하세요.

**사용 예시**:
```swift
// UIKit에서 사용
label.textColor = UIColor.semantic(.labelNormal)

// SwiftUI에서 사용
Button("버튼") { }
    .foregroundColor(.semantic(.primaryNormal))
    .background(Color.semantic(.backgroundNormal))
```

- Note: 컴포넌트 개발 시 Atomic 색상보다 Semantic 색상을 
  우선적으로 사용하는 것이 권장됩니다.

## Cases
### `staticWhite`

```swift
case staticWhite
```

Figma상의 `.color-semantic-static-white` 토큰과 대응되는 값입니다.

### `staticBlack`

```swift
case staticBlack
```

Figma상의 `.color-semantic-static-black` 토큰과 대응되는 값입니다.

### `primaryNormal`

```swift
case primaryNormal
```

Figma상의 `.color-semantic-primary-normal` 토큰과 대응되는 값입니다.

### `primaryStrong`

```swift
case primaryStrong
```

Figma상의 `.color-semantic-primary-strong` 토큰과 대응되는 값입니다.

### `primaryHeavy`

```swift
case primaryHeavy
```

Figma상의 `.color-semantic-primary-heavy` 토큰과 대응되는 값입니다.

### `labelNormal`

```swift
case labelNormal
```

Figma상의 `.color-semantic-label-normal` 토큰과 대응되는 값입니다.

### `labelStrong`

```swift
case labelStrong
```

Figma상의 `.color-semantic-label-strong` 토큰과 대응되는 값입니다.

### `labelNeutral`

```swift
case labelNeutral
```

Figma상의 `.color-semantic-label-neutral` 토큰과 대응되는 값입니다.

### `labelAlternative`

```swift
case labelAlternative
```

Figma상의 `.color-semantic-label-alternative` 토큰과 대응되는 값입니다.

### `labelAssistive`

```swift
case labelAssistive
```

Figma상의 `.color-semantic-label-assistive` 토큰과 대응되는 값입니다.

### `labelDisable`

```swift
case labelDisable
```

Figma상의 `.color-semantic-label-disable` 토큰과 대응되는 값입니다.

### `backgroundNormal`

```swift
case backgroundNormal
```

Figma상의 `.color-semantic-background-normal-normal` 토큰과 대응되는 값입니다.

### `backgroundNormalAlternative`

```swift
case backgroundNormalAlternative
```

Figma상의 `.color-semantic-background-normal-alternative` 토큰과 대응되는 값입니다.

### `backgroundElevated`

```swift
case backgroundElevated
```

Figma상의 `.color-semantic-background-elevated-normal` 토큰과 대응되는 값입니다.

### `backgroundElevatedAlternative`

```swift
case backgroundElevatedAlternative
```

Figma상의 `.color-semantic-background-elevated-alternative` 토큰과 대응되는 값입니다.

### `interactionInactive`

```swift
case interactionInactive
```

Figma상의 `.color-semantic-interaction-inactive` 토큰과 대응되는 값입니다.

### `interactionDisable`

```swift
case interactionDisable
```

Figma상의 `.color-semantic-interaction-disable` 토큰과 대응되는 값입니다.

### `lineNormal`

```swift
case lineNormal
```

Figma상의 `.color-semantic-line-normal` 토큰과 대응되는 값입니다.

### `lineNeutral`

```swift
case lineNeutral
```

Figma상의 `.color-semantic-line-neutral` 토큰과 대응되는 값입니다.

### `lineAlternative`

```swift
case lineAlternative
```

Figma상의 `.color-semantic-line-alternative` 토큰과 대응되는 값입니다.

### `lineSolidNormal`

```swift
case lineSolidNormal
```

Figma상의 `.color-semantic-line-solid-normal` 토큰과 대응되는 값입니다.

### `lineSolidNeutral`

```swift
case lineSolidNeutral
```

Figma상의 `.color-semantic-line-solid-neutral` 토큰과 대응되는 값입니다.

### `lineSolidAlternative`

```swift
case lineSolidAlternative
```

Figma상의 `.color-semantic-line-solid-alternative` 토큰과 대응되는 값입니다.

### `statusPositive`

```swift
case statusPositive
```

Figma상의 `.color-semantic-status-positive` 토큰과 대응되는 값입니다.

### `statusCautionary`

```swift
case statusCautionary
```

Figma상의 `.color-semantic-status-cautionary` 토큰과 대응되는 값입니다.

### `statusNegative`

```swift
case statusNegative
```

Figma상의 `.color-semantic-status-negative` 토큰과 대응되는 값입니다.

### `accentForegroundRed`

```swift
case accentForegroundRed
```

Figma상의 `.color-semantic-accent-foreground-red` 토큰과 대응되는 값입니다.

### `accentForegroundRedOrange`

```swift
case accentForegroundRedOrange
```

Figma상의 `.color-semantic-accent-foreground-redOrange` 토큰과 대응되는 값입니다.

### `accentForegroundOrange`

```swift
case accentForegroundOrange
```

Figma상의 `.color-semantic-accent-foreground-orange` 토큰과 대응되는 값입니다.

### `accentForegroundLime`

```swift
case accentForegroundLime
```

Figma상의 `.color-semantic-accent-foreground-lime` 토큰과 대응되는 값입니다.

### `accentForegroundGreen`

```swift
case accentForegroundGreen
```

Figma상의 `.color-semantic-accent-foreground-green` 토큰과 대응되는 값입니다.

### `accentForegroundCyan`

```swift
case accentForegroundCyan
```

Figma상의 `.color-semantic-accent-foreground-cyan` 토큰과 대응되는 값입니다.

### `accentForegroundLightBlue`

```swift
case accentForegroundLightBlue
```

Figma상의 `.color-semantic-accent-foreground-lightBlue` 토큰과 대응되는 값입니다.

### `accentForegroundBlue`

```swift
case accentForegroundBlue
```

Figma상의 `.color-semantic-accent-foreground-blue` 토큰과 대응되는 값입니다.

### `accentForegroundViolet`

```swift
case accentForegroundViolet
```

Figma상의 `.color-semantic-accent-foreground-violet` 토큰과 대응되는 값입니다.

### `accentForegroundPurple`

```swift
case accentForegroundPurple
```

Figma상의 `.color-semantic-accent-foreground-purple` 토큰과 대응되는 값입니다.

### `accentForegroundPink`

```swift
case accentForegroundPink
```

Figma상의 `.color-semantic-accent-foreground-pink` 토큰과 대응되는 값입니다.

### `accentBackgroundRedOrange`

```swift
case accentBackgroundRedOrange
```

Figma상의 `.color-semantic-accent-background-redOrange` 토큰과 대응되는 값입니다.

### `accentBackgroundLime`

```swift
case accentBackgroundLime
```

Figma상의 `.color-semantic-accent-background-lime` 토큰과 대응되는 값입니다.

### `accentBackgroundCyan`

```swift
case accentBackgroundCyan
```

Figma상의 `.color-semantic-accent-background-cyan` 토큰과 대응되는 값입니다.

### `accentBackgroundLightBlue`

```swift
case accentBackgroundLightBlue
```

Figma상의 `.color-semantic-accent-background-lightBlue` 토큰과 대응되는 값입니다.

### `accentBackgroundViolet`

```swift
case accentBackgroundViolet
```

Figma상의 `.color-semantic-accent-background-violet` 토큰과 대응되는 값입니다.

### `accentBackgroundPurple`

```swift
case accentBackgroundPurple
```

Figma상의 `.color-semantic-accent-background-purple` 토큰과 대응되는 값입니다.

### `accentBackgroundPink`

```swift
case accentBackgroundPink
```

Figma상의 `.color-semantic-accent-background-pink` 토큰과 대응되는 값입니다.

### `inversePrimary`

```swift
case inversePrimary
```

Figma상의 `.color-semantic-inverse-primary` 토큰과 대응되는 값입니다.

### `inverseBackground`

```swift
case inverseBackground
```

Figma상의 `.color-semantic-inverse-background` 토큰과 대응되는 값입니다.

### `inverseLabel`

```swift
case inverseLabel
```

Figma상의 `.color-semantic-inverse-label` 토큰과 대응되는 값입니다.

### `fillNormal`

```swift
case fillNormal
```

Figma상의 `.color-semantic-fill-normal` 토큰과 대응되는 값입니다.

### `fillStrong`

```swift
case fillStrong
```

Figma상의 `.color-semantic-fill-strong` 토큰과 대응되는 값입니다.

### `fillAlternative`

```swift
case fillAlternative
```

Figma상의 `.color-semantic-fill-alternative` 토큰과 대응되는 값입니다.

### `materialDimmer`

```swift
case materialDimmer
```

Figma상의 `.color-semantic-material-dimmer` 토큰과 대응되는 값입니다.

## Properties
<details><summary markdown="span"><code>name</code></summary>

```swift
public var name: String
```

</details>

## Methods
<details><summary markdown="span"><code>resolve(_:)</code></summary>

```swift
public func resolve(_ traitCollection: UITraitCollection) -> UIColor
```

</details>
