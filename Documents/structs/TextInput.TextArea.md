**STRUCT**

# `TextInput.TextArea`

```swift
public struct TextArea: View
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

</details>

<details><summary markdown="span"><code>resize(_:)</code></summary>

```swift
public func resize(_ resize: Resize) -> Self
```

TextArea의 resize 여부 입니다.

</details>

<details><summary markdown="span"><code>negative(_:)</code></summary>

```swift
public func negative(_ negative: Bool = true) -> Self
```

TextArea의 negative 여부를 결정합니다.

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

TextArea의 사용가능 여부입니다.

</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: String?) -> Self
```

TextArea의 제목입니다.
> 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.

</details>

<details><summary markdown="span"><code>requiredBadge(_:)</code></summary>

```swift
public func requiredBadge(_ requiredBadge: Bool = true) -> Self
```

TextArea의 필수 표시 노출 여부입니다.

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

TextArea 하단 컴포넌트입니다.
> 좌/우 각각 최대 3개까지 사용할 수 있습니다.

</details>

<details><summary markdown="span"><code>description(_:)</code></summary>

```swift
public func description(_ description: String?) -> Self
```

TextArea 하단 설명입니다.
> 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.

</details>

<details><summary markdown="span"><code>placeholder(_:)</code></summary>

```swift
public func placeholder(_ placeholder: String?) -> Self
```

TextArea에 입력된 텍스트가 없을 때 노출되는 placeholder입니다.
 > 값을 지정하지 않으면 노출되지 않습니다.

</details>
