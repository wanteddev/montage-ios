**STRUCT**

# `TextInput.TextArea`

```swift
public struct TextArea: View
```

여러 줄의 텍스트 입력을 위한 컴포넌트입니다.

이 컴포넌트는 사용자가 여러 줄의 텍스트를 입력할 수 있는 영역을 제공합니다.
제목, 배지, 리사이즈 옵션, 캐릭터 카운터 등 다양한 기능을 지원합니다.

## 사용 예시
```swift
@State private var longText = ""
@FocusState private var isFocused: Bool

// 기본 텍스트 영역
TextInput.TextArea(text: $longText, focus: $isFocused)
    .heading("의견")
    .placeholder("의견을 입력해주세요")

// 문자 수 제한과 고정 크기를 가진 텍스트 영역
TextInput.TextArea(text: $longText)
    .resize(.fixed(min: 100, max: 200))
    .bottomResources(
        trailing: [.characterCount(limit: 100)]
    )

// 필수 항목 표시와 설명이 있는 텍스트 영역
TextInput.TextArea(text: $longText)
    .heading("상세 설명")
    .requiredBadge(true)
    .description("최대한 자세히 작성해주세요")
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(text:focus:)</code></summary>

```swift
public init(
    text: Binding<String>,
    focus: FocusState<Bool>.Binding? = nil
)
```

텍스트 영역을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| text | 텍스트 영역의 값을 바인딩 |
| focus | 텍스트 영역의 포커스 상태를 바인딩 (선택 사항) |

#### Returns

구성된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>resize(_:)</code></summary>

```swift
public func resize(_ resize: Resize) -> Self
```

텍스트 영역의 크기 조절 방식을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| resize | 크기 조절 방식 |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>negative(_:)</code></summary>

```swift
public func negative(_ negative: Bool = true) -> Self
```

텍스트 영역의 오류 상태를 설정합니다.

오류 상태일 때는 텍스트 영역이 적색 테두리로 강조됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| negative | 오류 상태 여부, 기본값은 `true` |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

텍스트 영역의 활성화 상태를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부, `true`이면 비활성화 |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: String?) -> Self
```

텍스트 영역 위에 표시할 제목을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| heading | 표시할 제목, nil이면 제목 표시 안함 |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>requiredBadge(_:)</code></summary>

```swift
public func requiredBadge(_ requiredBadge: Bool = true) -> Self
```

제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| requiredBadge | 필수 입력 뱃지 표시 여부, 기본값은 `true` |
| Note | 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다. |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>bottomResources(leading:trailing:leadingResourceSpacing:trailingResourceSpacing:)</code></summary>

```swift
public func bottomResources(
    leading leadingResources: [Resource] = [],
    trailing trailingResources: [Resource] = [],
    leadingResourceSpacing: CGFloat = 4,
    trailingResourceSpacing: CGFloat = 4
) -> Self
```

텍스트 영역 하단에 표시할 UI 요소를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| leadingResources | 왼쪽에 표시할 UI 요소 배열 (최대 3개) |
| trailingResources | 오른쪽에 표시할 UI 요소 배열 (최대 3개) |
| leadingResourceSpacing | 왼쪽 요소 간의 간격 |
| trailingResourceSpacing | 오른쪽 요소 간의 간격 |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>description(_:)</code></summary>

```swift
public func description(_ description: String?) -> Self
```

텍스트 영역 하단에 표시할 설명 텍스트를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| description | 표시할 설명 텍스트, nil이면 표시 안함 |

#### Returns

수정된 텍스트 영역 인스턴스



</details>

<details><summary markdown="span"><code>placeholder(_:)</code></summary>

```swift
public func placeholder(_ placeholder: String?) -> Self
```

텍스트 영역에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| placeholder | 표시할 플레이스홀더 텍스트 |

#### Returns

수정된 텍스트 영역 인스턴스



</details>
