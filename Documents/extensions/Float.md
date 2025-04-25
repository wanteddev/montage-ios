**EXTENSION**

# `Float`
```swift
public extension Float
```

## Methods
<details><summary markdown="span"><code>opacity(_:)</code></summary>

```swift
static func opacity(_ opacityComponent: Opacity) -> Float
```

Opacity 열거형 값에 해당하는 Float 불투명도 값을 반환합니다.

디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.

**사용 예시**:
```swift
let alpha = Float.opacity(.p050) // 0.5
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| opacityComponent | 사용할 불투명도 열거형 값 |

#### Returns

지정된 불투명도에 해당하는 Float 값 (0.0 ~ 1.0 범위)



</details>

<details><summary markdown="span"><code>spacing(_:)</code></summary>

```swift
static func spacing(_ spacingComponent: Spacing) -> Float
```

Spacing 열거형 값에 해당하는 Float 값을 반환합니다.

디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.

**사용 예시**:
```swift
let padding = Float.spacing(.pt16) // 16.0
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| spacingComponent | 사용할 간격 열거형 값 |

#### Returns

지정된 간격에 해당하는 Float 값



</details>
