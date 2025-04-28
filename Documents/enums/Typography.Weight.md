**ENUM**

# `Typography.Weight`

```swift
public enum Weight: CaseIterable
```

폰트 두께를 정의하는 열거형

Weight는 텍스트의 시각적 강조를 위한 세 가지 기본 두께를 제공합니다.
텍스트의 중요도나 계층 구조에 따라 적절한 두께를 선택하여 사용합니다.

- regular: 일반적인 본문 텍스트에 사용 (400)
- medium: 중간 강조가 필요한 텍스트에 사용 (500)
- bold: 강한 강조가 필요한 제목이나 중요 정보에 사용 (600/700)

## Cases
### `regular`

```swift
case regular
```

일반 두께 (Regular, 400)

### `medium`

```swift
case medium
```

중간 두께 (Medium, 500)

### `bold`

```swift
case bold
```

굵은 두께 (SemiBold/Bold, 600/700)
