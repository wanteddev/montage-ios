**EXTENSION**

# `Text`
```swift
public extension Text
```

## Methods
<details><summary markdown="span"><code>montage(variant:weight:color:)</code></summary>

```swift
func montage(
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    color: SwiftUI.Color
) -> Text
```

Montage 디자인 시스템의 스타일을 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| color | 색상 |

#### Returns

스타일이 적용된 Text 인스턴스



</details>

<details><summary markdown="span"><code>montage(variant:weight:colorResolver:)</code></summary>

```swift
func montage(
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    colorResolver: ColorResolvable
) -> Text
```

Montage 디자인 시스템의 스타일을 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| colorResolver | 색상 해석기 |

#### Returns

스타일이 적용된 Text 인스턴스



</details>

<details><summary markdown="span"><code>montage(variant:weight:semantic:)</code></summary>

```swift
func montage(
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    semantic: Color.Semantic = .labelNormal
) -> Text
```

Montage 디자인 시스템의 스타일을 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| semantic | 시맨틱 색상 |

#### Returns

스타일이 적용된 Text 인스턴스



</details>

<details><summary markdown="span"><code>montage(variant:weight:atomic:)</code></summary>

```swift
func montage(
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    atomic: Color.Atomic
) -> Text
```

Montage 디자인 시스템의 스타일을 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |
| atomic | 아토믹 색상 |

#### Returns

스타일이 적용된 Text 인스턴스



</details>
