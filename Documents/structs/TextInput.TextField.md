**STRUCT**

# `TextInput.TextField`

```swift
public struct TextField: View
```

단일 라인 텍스트 입력을 위한 컴포넌트입니다.

이 컴포넌트는 사용자가 텍스트를 입력할 수 있는 필드를 제공합니다.
제목, 아이콘, 자동완성, 상태 표시 등 다양한 기능을 지원합니다.

## 사용 예시
```swift
@State private var inputText = ""

// 기본 텍스트 필드
TextInput.TextField(text: $inputText)
   .heading("이메일")
   .placeholder("이메일을 입력하세요")

// 아이콘이 있는 필수 입력 필드
TextInput.TextField(text: $inputText)
   .heading("아이디")
   .requiredBadge(true)
   .icon(.person)
   .status(.negative(description: "올바른 아이디를 입력해주세요"))

// 오른쪽 버튼이 있는 텍스트 필드
TextInput.TextField(text: $inputText)
   .trailingButton(
       .init(
           variant: .primary,
           title: "인증",
           handler: { verifyCode() }
       )
   )
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(text:autoCompletionDataSource:)</code></summary>

```swift
public init(
    text: Binding<String>,
    autoCompletionDataSource: Binding<AutoCompletionDataSource?> = .constant(
        nil
    )
)
```

텍스트 필드를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| text | 텍스트 필드의 값을 바인딩 |
| autoCompletionDataSource | 자동완성 데이터 소스를 바인딩, 기본값은 nil |

#### Returns

구성된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>status(_:)</code></summary>

```swift
public func status(_ status: Status) -> Self
```

텍스트 필드의 상태를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| status | 텍스트 필드의 상태 |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool) -> Self
```

텍스트 필드의 활성화 상태를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부, `true`이면 비활성화 |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: String?) -> Self
```

텍스트 필드 위에 표시할 제목을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| heading | 표시할 제목, nil이면 제목 표시 안함 |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>requiredBadge(_:)</code></summary>

```swift
public func requiredBadge(_ requiredBadge: Bool) -> Self
```

제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| requiredBadge | 필수 입력 뱃지 표시 여부 |
| Note | 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다. |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>placeholder(_:)</code></summary>

```swift
public func placeholder(_ placeholder: String?) -> Self
```

텍스트 필드에 입력된 텍스트가 없을 때 표시할 플레이스홀더를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| placeholder | 표시할 플레이스홀더 텍스트 |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>icon(_:)</code></summary>

```swift
public func icon(_ icon: Icon?) -> Self
```

텍스트 필드 왼쪽에 표시할 아이콘을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| icon | 표시할 아이콘 |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>trailingButton(_:)</code></summary>

```swift
public func trailingButton(_ trailingButton: TrailingButton?) -> Self
```

텍스트 필드 오른쪽에 표시할 버튼을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| trailingButton | 표시할 버튼의 속성 |
| Note | `trailingContent`와 함께 사용될 경우 `trailingButton`이 우선적으로 표시됩니다. |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ trailingContent: (() -> any View)?) -> Self
```

텍스트 필드 오른쪽에 표시할 커스텀 콘텐츠를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| trailingContent | 표시할 커스텀 콘텐츠를 생성하는 클로저 |
| Note | `trailingButton`과 함께 사용하는 경우 `trailingContent`가 무시됩니다. |

#### Returns

수정된 텍스트 필드 인스턴스



</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ color: SwiftUI.Color?) -> Self
```

텍스트 필드의 배경색을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 설정할 배경색 |

#### Returns

수정된 텍스트 필드 인스턴스



</details>
