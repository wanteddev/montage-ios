**EXTENSION**

# `UIColor`
```swift
extension UIColor
```

## Methods
<details><summary markdown="span"><code>atomic(_:)</code></summary>

```swift
public static func atomic(_ type: Color.Atomic) -> UIColor
```

Atomic 색상 타입에 해당하는 UIColor를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 생성할 Atomic 색상 타입 |

#### Returns

동적으로 생성된 UIColor 인스턴스



</details>

<details><summary markdown="span"><code>semantic(_:)</code></summary>

```swift
public static func semantic(_ type: Color.Semantic) -> UIColor
```

Semantic 색상 타입에 해당하는 UIColor를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 생성할 Semantic 색상 타입 |

#### Returns

동적으로 생성된 UIColor 인스턴스



</details>

<details><summary markdown="span"><code>montage(_:)</code></summary>

```swift
public static func montage(_ type: ColorResolvable) -> UIColor
```

ColorResolvable 프로토콜을 준수하는 타입에 해당하는 UIColor를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 생성할 색상 타입 |

#### Returns

동적으로 생성된 UIColor 인스턴스



</details>
