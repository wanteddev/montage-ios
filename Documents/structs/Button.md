**STRUCT**

# `Button`

```swift
public struct Button: View
```

사용자가 상호작용할 수 있는 버튼 컴포넌트입니다.

세 가지 스타일로 제공됩니다:
- `solid`: 색상이 채워진 버튼
- `outlined`: 테두리만 있는 버튼
- `text`: 텍스트만 있는 버튼

```swift
Button.solid(text: "확인", handler: { print("버튼 클릭") })
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>solid(variant:size:text:leadingIcon:trailingIcon:handler:)</code></summary>

```swift
public static func solid(
    variant: Solid.Variant = .primary,
    size: Solid.Size = .large,
    text: String,
    leadingIcon: Icon? = nil,
    trailingIcon: Icon? = nil,
    handler: (() -> Void)? = nil
) -> Self
```

Solid 스타일의 텍스트 버튼을 생성합니다.

- Parameters:
  - variant: 버튼의 변형, 기본값은 `.primary`
  - size: 버튼의 크기, 기본값은 `.large`
  - text: 버튼에 표시할 텍스트
  - leadingIcon: 텍스트 앞에 표시할 아이콘
  - trailingIcon: 텍스트 뒤에 표시할 아이콘
  - handler: 버튼 탭 시 실행할 핸들러
- Returns: 구성된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| text | 버튼에 표시할 텍스트 |
| leadingIcon | 텍스트 앞에 표시할 아이콘 |
| trailingIcon | 텍스트 뒤에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

</details>

<details><summary markdown="span"><code>solid(variant:size:icon:handler:)</code></summary>

```swift
public static func solid(
    variant: Solid.Variant = .primary,
    size: Solid.Size = .large,
    icon: Icon,
    handler: (() -> Void)? = nil
) -> Self
```

Solid 스타일의 아이콘 버튼을 생성합니다.

- Parameters:
  - variant: 버튼의 변형, 기본값은 `.primary`
  - size: 버튼의 크기, 기본값은 `.large`
  - icon: 버튼에 표시할 아이콘
  - handler: 버튼 탭 시 실행할 핸들러
- Returns: 구성된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| icon | 버튼에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

</details>

<details><summary markdown="span"><code>outlined(variant:size:text:leadingIcon:trailingIcon:handler:)</code></summary>

```swift
public static func outlined(
    variant: Outlined.Variant = .primary,
    size: Outlined.Size = .large,
    text: String,
    leadingIcon: Icon? = nil,
    trailingIcon: Icon? = nil,
    handler: (() -> Void)? = nil
) -> Self
```

Outlined 스타일의 텍스트 버튼을 생성합니다.

- Parameters:
  - variant: 버튼의 변형, 기본값은 `.primary`
  - size: 버튼의 크기, 기본값은 `.large`
  - text: 버튼에 표시할 텍스트
  - leadingIcon: 텍스트 앞에 표시할 아이콘
  - trailingIcon: 텍스트 뒤에 표시할 아이콘
  - handler: 버튼 탭 시 실행할 핸들러
- Returns: 구성된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| text | 버튼에 표시할 텍스트 |
| leadingIcon | 텍스트 앞에 표시할 아이콘 |
| trailingIcon | 텍스트 뒤에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

</details>

<details><summary markdown="span"><code>outlined(variant:size:icon:handler:)</code></summary>

```swift
public static func outlined(
    variant: Outlined.Variant = .primary,
    size: Outlined.Size = .large,
    icon: Icon,
    handler: (() -> Void)? = nil
) -> Self
```

Outlined 스타일의 아이콘 버튼을 생성합니다.

- Parameters:
  - variant: 버튼의 변형, 기본값은 `.primary`
  - size: 버튼의 크기, 기본값은 `.large`
  - icon: 버튼에 표시할 아이콘
  - handler: 버튼 탭 시 실행할 핸들러
- Returns: 구성된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| icon | 버튼에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

</details>

<details><summary markdown="span"><code>text(variant:size:text:leadingIcon:trailingIcon:handler:)</code></summary>

```swift
public static func text(
    variant: Text.Variant = .primary,
    size: Text.Size = .medium,
    text: String,
    leadingIcon: Icon? = nil,
    trailingIcon: Icon? = nil,
    handler: (() -> Void)? = nil
) -> Self
```

Text 스타일의 버튼을 생성합니다.

- Parameters:
  - variant: 버튼의 변형, 기본값은 `.primary`
  - size: 버튼의 크기, 기본값은 `.medium`
  - text: 버튼에 표시할 텍스트
  - leadingIcon: 텍스트 앞에 표시할 아이콘
  - trailingIcon: 텍스트 뒤에 표시할 아이콘
  - handler: 버튼 탭 시 실행할 핸들러
- Returns: 구성된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.medium` |
| text | 버튼에 표시할 텍스트 |
| leadingIcon | 텍스트 앞에 표시할 아이콘 |
| trailingIcon | 텍스트 뒤에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

버튼을 비활성화 상태로 설정합니다.

- Parameter disable: 비활성화 여부, 기본값은 `true`
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부, 기본값은 `true` |

</details>

<details><summary markdown="span"><code>contentColor(_:)</code></summary>

```swift
public func contentColor(_ contentColor: SwiftUI.Color?) -> Self
```

버튼 콘텐츠의 색상을 설정합니다.

- Parameter contentColor: 설정할 색상
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| contentColor | 설정할 색상 |

</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ backgroundColor: SwiftUI.Color?) -> Self
```

버튼 배경색을 설정합니다.

- Parameter backgroundColor: 설정할 배경색
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| backgroundColor | 설정할 배경색 |

</details>

<details><summary markdown="span"><code>borderColor(_:)</code></summary>

```swift
public func borderColor(_ borderColor: SwiftUI.Color?) -> Self
```

버튼 테두리 색상을 설정합니다.

- Parameter borderColor: 설정할 테두리 색상
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| borderColor | 설정할 테두리 색상 |

</details>

<details><summary markdown="span"><code>fontVariant(_:)</code></summary>

```swift
public func fontVariant(_ fontVariant: Typography.Variant?) -> Self
```

버튼 텍스트의 폰트 변형을 설정합니다.

- Parameter fontVariant: 설정할 폰트 변형
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| fontVariant | 설정할 폰트 변형 |

</details>

<details><summary markdown="span"><code>fontWeight(_:)</code></summary>

```swift
public func fontWeight(_ fontWeight: Typography.Weight?) -> Self
```

버튼 텍스트의 폰트 두께를 설정합니다.

- Parameter fontWeight: 설정할 폰트 두께
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| fontWeight | 설정할 폰트 두께 |

</details>

<details><summary markdown="span"><code>loading(_:)</code></summary>

```swift
public func loading(_ loading: Bool = true) -> Self
```

버튼을 로딩 상태로 설정합니다.

- Parameter loading: 로딩 상태 여부, 기본값은 `true`
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| loading | 로딩 상태 여부, 기본값은 `true` |

</details>

<details><summary markdown="span"><code>fill(horizontal:vertical:)</code></summary>

```swift
public func fill(horizontal fillHorizontal: Bool = false, vertical fillVertical: Bool = false) -> Self
```

버튼이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.

- Parameters:
  - horizontal: 수평 방향 채우기 여부, 기본값은 `false`
  - vertical: 수직 방향 채우기 여부, 기본값은 `false`
- Returns: 수정된 버튼 인스턴스

#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontal | 수평 방향 채우기 여부, 기본값은 `false` |
| vertical | 수직 방향 채우기 여부, 기본값은 `false` |

</details>