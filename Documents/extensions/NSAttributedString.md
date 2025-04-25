**EXTENSION**

# `NSAttributedString`
```swift
public extension NSAttributedString
```

## Methods
<details><summary markdown="span"><code>montage(_:variant:weight:colorResolver:lineBreakMode:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    colorResolver: ColorResolvable,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 변환할 문자열 |
| variant | 타이포그래피 변형 (기본값: .body1) |
| weight | 폰트 두께 (기본값: .regular) |
| colorResolver | 색상 해석기 |
| lineBreakMode | 줄바꿈 모드 (기본값: .byWordWrapping) |

#### Returns

Montage 스타일이 적용된 NSAttributedString



</details>

<details><summary markdown="span"><code>montage(_:variant:weight:semantic:lineBreakMode:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    semantic: Color.Semantic,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 변환할 문자열 |
| variant | 타이포그래피 변형 (기본값: .body1) |
| weight | 폰트 두께 (기본값: .regular) |
| semantic | 의미론적 색상 |
| lineBreakMode | 줄바꿈 모드 (기본값: .byWordWrapping) |

#### Returns

Montage 스타일이 적용된 NSAttributedString



</details>

<details><summary markdown="span"><code>montage(_:variant:weight:atomic:lineBreakMode:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    atomic: Color.Atomic,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 변환할 문자열 |
| variant | 타이포그래피 변형 (기본값: .body1) |
| weight | 폰트 두께 (기본값: .regular) |
| atomic | 원자적 색상 |
| lineBreakMode | 줄바꿈 모드 (기본값: .byWordWrapping) |

#### Returns

Montage 스타일이 적용된 NSAttributedString



</details>

<details><summary markdown="span"><code>montage(_:variant:weight:)</code></summary>

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular
) -> NSAttributedString
```

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 변환할 문자열 |
| variant | 타이포그래피 변형 (기본값: .body1) |
| weight | 폰트 두께 (기본값: .regular) |

#### Returns

Montage 스타일이 적용된 NSAttributedString



</details>

<details><summary markdown="span"><code>montage(_:)</code></summary>

```swift
static func montage(
    _ string: String
) -> NSAttributedString
```

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| string | 변환할 문자열 |

#### Returns

Montage 스타일이 적용된 NSAttributedString



</details>
