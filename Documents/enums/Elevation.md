**ENUM**

# `Elevation`

```swift
public enum Elevation: Equatable
```

높낮이의 차이를 표현하기 위한 그림자 효과

Elevation은 UI 요소의 시각적 깊이와 높이를 표현하기 위한 
그림자 효과를 정의합니다. 여러 단계의 그림자를 통해 
요소 간의 계층 구조와 중요도를 시각적으로 나타냅니다.

**사용 예시**:
```swift
// UIKit에서 사용
let cardView = UIView()
cardView.setElevation(.shadowNormal)

// 그림자 변경
cardView.setElevation(.shadowEmphasize)
```

- Note: `UIView.setElevation(_:)`을 사용하여 레이어에 그림자를 적용할 수 있습니다.
중첩된 뷰에 그림자를 적용할 경우 성능에 영향을 줄 수 있으므로 주의해야 합니다.

## Cases
### `none`

```swift
case none
```

그림자 없음

### `shadowNormal`

```swift
case shadowNormal
```

일반적인 수준의 그림자 (1pt 높이)

### `shadowEmphasize`

```swift
case shadowEmphasize
```

강조된 수준의 그림자 (2pt 높이)

### `shadowStrong`

```swift
case shadowStrong
```

강한 수준의 그림자 (4pt 높이)

### `shadowHeavy`

```swift
case shadowHeavy
```

가장 강한 수준의 그림자 (8pt 높이)
