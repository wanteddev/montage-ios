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

## 사용 예시
```swift
// 기본 솔리드 버튼
Button.solid(text: "확인", handler: { print("버튼 클릭") })

// 아웃라인 버튼
Button.outlined(variant: .primary, size: .medium, text: "취소")

// 텍스트 버튼
Button.text(text: "더보기", trailingIcon: .chevronRight)

// 아이콘 버튼
Button.solid(icon: .bell, handler: { print("알림 보기") })

// 로딩 상태 설정
Button.solid(text: "저장")
    .loading(true)
```

- Note: 버튼은 다양한 수정자(modifier)를 사용하여 모양과 동작을 커스터마이즈할 수 있습니다.
- SeeAlso: ``Typography``, ``Color``

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

배경색이 채워진 스타일의 버튼으로, 주요 액션이나 강조가 필요한 액션에 적합합니다.

## 사용 예시
```swift
Button.solid(text: "로그인", handler: { loginUser() })
Button.solid(variant: .assistive, size: .small, text: "확인")
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| text | 버튼에 표시할 텍스트 |
| leadingIcon | 텍스트 앞에 표시할 아이콘 |
| trailingIcon | 텍스트 뒤에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

#### Returns

구성된 버튼 인스턴스



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

배경색이 채워진 스타일의 아이콘 버튼으로, 공간이 제한적이거나 아이콘으로 충분히 의미가 전달될 때 사용합니다.

## 사용 예시
```swift
Button.solid(icon: .plus, handler: { addItem() })
Button.solid(variant: .assistive, size: .small, icon: .search)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| icon | 버튼에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

#### Returns

구성된 버튼 인스턴스



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

테두리만 있는 스타일의 버튼으로, 보조 액션이나 덜 강조된 액션에 적합합니다.

## 사용 예시
```swift
Button.outlined(text: "취소", handler: { dismiss() })
Button.outlined(variant: .secondary, size: .medium, text: "뒤로")
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| text | 버튼에 표시할 텍스트 |
| leadingIcon | 텍스트 앞에 표시할 아이콘 |
| trailingIcon | 텍스트 뒤에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

#### Returns

구성된 버튼 인스턴스



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

테두리만 있는 스타일의 아이콘 버튼으로, 공간이 제한적이거나 보조적인 아이콘 액션에 적합합니다.

## 사용 예시
```swift
Button.outlined(icon: .share, handler: { shareContent() })
Button.outlined(variant: .assistive, size: .small, icon: .bookmark)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.large` |
| icon | 버튼에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

#### Returns

구성된 버튼 인스턴스



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

텍스트만 있는 스타일의 버튼으로, 가벼운 액션이나 링크 형태의 액션에 적합합니다.

## 사용 예시
```swift
Button.text(text: "더 보기", handler: { showMore() })
Button.text(variant: .assistive, text: "상세보기", trailingIcon: .chevronRight)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형, 기본값은 `.primary` |
| size | 버튼의 크기, 기본값은 `.medium` |
| text | 버튼에 표시할 텍스트 |
| leadingIcon | 텍스트 앞에 표시할 아이콘 |
| trailingIcon | 텍스트 뒤에 표시할 아이콘 |
| handler | 버튼 탭 시 실행할 핸들러 |

#### Returns

구성된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

버튼을 비활성화 상태로 설정합니다.

비활성화된 버튼은 시각적으로 흐리게 표시되며 사용자 상호작용에 반응하지 않습니다.

## 사용 예시
```swift
Button.solid(text: "저장")
    .disable(isFormInvalid)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부, 기본값은 `true` |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>contentColor(_:)</code></summary>

```swift
public func contentColor(_ contentColor: SwiftUI.Color?) -> Self
```

버튼 콘텐츠(텍스트와 아이콘)의 색상을 설정합니다.

## 사용 예시
```swift
Button.outlined(text: "복사")
    .contentColor(.red)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| contentColor | 설정할 색상 |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ backgroundColor: SwiftUI.Color?) -> Self
```

버튼 배경색을 설정합니다.

Solid 스타일 버튼에 가장 효과적으로 적용됩니다.

## 사용 예시
```swift
Button.solid(text: "특별 액션")
    .backgroundColor(.blue)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| backgroundColor | 설정할 배경색 |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>borderColor(_:)</code></summary>

```swift
public func borderColor(_ borderColor: SwiftUI.Color?) -> Self
```

버튼 테두리 색상을 설정합니다.

Outlined 스타일 버튼에 가장 효과적으로 적용됩니다.

## 사용 예시
```swift
Button.outlined(text: "경고")
    .borderColor(.red)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| borderColor | 설정할 테두리 색상 |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>fontVariant(_:)</code></summary>

```swift
public func fontVariant(_ fontVariant: Typography.Variant?) -> Self
```

버튼 텍스트의 폰트 변형을 설정합니다.

텍스트의 크기와 스타일을 변경할 때 사용합니다.

## 사용 예시
```swift
Button.text(text: "중요 안내")
    .fontVariant(.heading)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| fontVariant | 설정할 폰트 변형 |
| SeeAlso | ``Typography.Variant`` |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>fontWeight(_:)</code></summary>

```swift
public func fontWeight(_ fontWeight: Typography.Weight?) -> Self
```

버튼 텍스트의 폰트 두께를 설정합니다.

텍스트의 강조를 조절할 때 사용합니다.

## 사용 예시
```swift
Button.text(text: "중요 공지")
    .fontWeight(.bold)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| fontWeight | 설정할 폰트 두께 |
| SeeAlso | ``Typography.Weight`` |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>loading(_:)</code></summary>

```swift
public func loading(_ loading: Bool = true) -> Self
```

버튼을 로딩 상태로 설정합니다.

로딩 상태인 버튼은 내부 콘텐츠 대신 로딩 인디케이터를 표시하며 사용자 상호작용에 반응하지 않습니다.
비동기 작업이 진행 중일 때 사용자에게 피드백을 제공하는 데 유용합니다.

## 사용 예시
```swift
Button.solid(text: "저장")
    .loading(isLoading)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| loading | 로딩 상태 여부, 기본값은 `true` |

#### Returns

수정된 버튼 인스턴스



</details>

<details><summary markdown="span"><code>fill(horizontal:vertical:)</code></summary>

```swift
public func fill(horizontal fillHorizontal: Bool = false, vertical fillVertical: Bool = false) -> Self
```

버튼이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.

버튼의 크기를 조절하여 컨테이너 뷰의 공간을 효율적으로 활용할 때 사용합니다.

## 사용 예시
```swift
// 부모 뷰의 가로 너비를 모두 채우는 버튼
Button.solid(text: "전체 확인")
    .fill(horizontal: true)

// 가로, 세로 모두 채우는 버튼
Button.outlined(text: "영역 전체 채우기")
    .fill(horizontal: true, vertical: true)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontal | 수평 방향 채우기 여부, 기본값은 `false` |
| vertical | 수직 방향 채우기 여부, 기본값은 `false` |

#### Returns

수정된 버튼 인스턴스



</details>
