**EXTENSION**

# `Font`
```swift
public extension Font
```

## Methods
<details><summary markdown="span"><code>montage(size:weight:)</code></summary>

```swift
static func montage(size: CGFloat, weight: Typography.Weight) -> Font
```

Montage 디자인 시스템의 폰트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 폰트 크기 |
| weight | 폰트 두께 |

#### Returns

생성된 Font 인스턴스



</details>

<details><summary markdown="span"><code>montage(variant:weight:)</code></summary>

```swift
static func montage(
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular
) -> Font?
```

Montage 디자인 시스템의 폰트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 |
| weight | 폰트 두께 |

#### Returns

생성된 Font 인스턴스



</details>
