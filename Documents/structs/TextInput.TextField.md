**STRUCT**

# `TextInput.TextField`

```swift
public struct TextField: View
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

</details>

<details><summary markdown="span"><code>status(_:)</code></summary>

```swift
public func status(_ status: Status) -> Self
```

상태를 조정합니다.

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool) -> Self
```

사용가능 여부를 조정합니다.

</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: String?) -> Self
```

제목을 표시합니다.

</details>

<details><summary markdown="span"><code>requiredBadge(_:)</code></summary>

```swift
public func requiredBadge(_ requiredBadge: Bool) -> Self
```

필수값임을 나타내는 뱃지를 제목 옆에 노출할지 여부를 조정합니다. 제목이 없으면 노출되지 않습니다.

</details>

<details><summary markdown="span"><code>placeholder(_:)</code></summary>

```swift
public func placeholder(_ placeholder: String?) -> Self
```

입력된 텍스트가 없을 때 노출되는 placeholder를 지정합니다.

</details>

<details><summary markdown="span"><code>icon(_:)</code></summary>

```swift
public func icon(_ icon: Icon?) -> Self
```

왼쪽에 표시될 아이콘을 지정합니다.

</details>

<details><summary markdown="span"><code>trailingButton(_:)</code></summary>

```swift
public func trailingButton(_ trailingButton: TrailingButton?) -> Self
```

오른쪽에 표시될 버튼의 속성을 지정합니다. `trailingContent`와 함께 사용될 경우 `trailingButton`이 우선순위가 높습니다.

</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ trailingContent: (() -> any View)?) -> Self
```

오른쪽에 표시될 컨텐츠를 지정합니다. `trailingButton`과 함께 사용하는 경우 `trailingContent`가 무시됩니다.

</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ color: SwiftUI.Color?) -> Self
```

</details>