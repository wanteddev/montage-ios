**EXTENSION**

# `UILabel`
```swift
public extension UILabel
```

## Methods
<details><summary markdown="span"><code>montage(_:variant:weight:colorResolver:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    colorResolver: ColorResolvable
) -> UILabel
```

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 표시할 문자열 |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| colorResolver | 색상 해석기 |

#### Returns

생성된 UILabel 인스턴스



</details>

<details><summary markdown="span"><code>montage(_:variant:weight:semantic:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    semantic: Color.Semantic = .labelNormal
) -> UILabel
```

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 표시할 문자열 |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| semantic | 시맨틱 색상 |

#### Returns

생성된 UILabel 인스턴스



</details>

<details><summary markdown="span"><code>montage(_:variant:weight:atomic:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    atomic: Color.Atomic = .red0
) -> UILabel
```

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 표시할 문자열 |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| atomic | 아토믹 색상 |

#### Returns

생성된 UILabel 인스턴스



</details>

<details><summary markdown="span"><code>montage(_:variant:weight:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular
) -> UILabel
```

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 표시할 문자열 |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |

#### Returns

생성된 UILabel 인스턴스



</details>

<details><summary markdown="span"><code>montage(_:)</code></summary>

```swift
static func montage(
    _ string: String
) -> UILabel
```

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 표시할 문자열 |

#### Returns

생성된 UILabel 인스턴스



</details>
