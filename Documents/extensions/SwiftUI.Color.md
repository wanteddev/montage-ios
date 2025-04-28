**EXTENSION**

# `SwiftUI.Color`
```swift
extension SwiftUI.Color
```

## Properties
<details><summary markdown="span"><code>uiColor</code></summary>

```swift
public var uiColor: UIColor
```

SwiftUI.Color를 UIColor로 변환합니다.

#### Returns

변환된 UIColor 인스턴스

</details>

## Methods
<details><summary markdown="span"><code>atomic(_:)</code></summary>

```swift
public static func atomic(_ type: Color.Atomic) -> SwiftUI.Color
```

Atomic 색상 타입에 해당하는 SwiftUI.Color를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 생성할 Atomic 색상 타입 |

#### Returns

동적으로 생성된 SwiftUI.Color 인스턴스



</details>

<details><summary markdown="span"><code>semantic(_:)</code></summary>

```swift
public static func semantic(_ type: Color.Semantic) -> SwiftUI.Color
```

Semantic 색상 타입에 해당하는 SwiftUI.Color를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 생성할 Semantic 색상 타입 |

#### Returns

동적으로 생성된 SwiftUI.Color 인스턴스



</details>

<details><summary markdown="span"><code>montage(_:)</code></summary>

```swift
public static func montage(_ type: ColorResolvable) -> SwiftUI.Color
```

ColorResolvable 프로토콜을 준수하는 타입에 해당하는 SwiftUI.Color를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 생성할 색상 타입 |

#### Returns

동적으로 생성된 SwiftUI.Color 인스턴스



</details>
