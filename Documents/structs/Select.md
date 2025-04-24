**STRUCT**

# `Select`

```swift
public struct Select: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(menuPresented:variant:items:onTapItem:)</code></summary>

```swift
public init(
    menuPresented: Binding<Bool>? = nil,
    variant: Variant,
    items: Binding<[Item]>,
    onTapItem: ((Select.Item) -> Void)? = nil
)
```

</details>

<details><summary markdown="span"><code>negative(_:)</code></summary>

```swift
public func negative(_ negative: Bool = true) -> Self
```

negative 상태 여부를 조정합니다.

</details>

<details><summary markdown="span"><code>placeholder(_:)</code></summary>

```swift
public func placeholder(_ placeholder: String) -> Self
```

선택된 항목들이 없는 경우 placeholder를 표시합니다.

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

활성화 여부를 조정합니다.

</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: String) -> Self
```

제목을 추가합니다.

</details>

<details><summary markdown="span"><code>requiredBadge(_:)</code></summary>

```swift
public func requiredBadge(_ requiredBadge: Bool = true) -> Self
```

필수 표시 노출 여부를 조정합니다.

</details>

<details><summary markdown="span"><code>description(_:)</code></summary>

```swift
public func description(_ description: String) -> Self
```

설명을 추가합니다.

</details>

<details><summary markdown="span"><code>shadowBackgroundColor(_:)</code></summary>

```swift
public func shadowBackgroundColor(_ shadowBackgroundColor: SwiftUI.Color) -> Self
```

shadow 배경색을 조정합니다. 기본값은 systemBackgroundColor 입니다.

</details>

<details><summary markdown="span"><code>leadingContent(_:)</code></summary>

```swift
public func leadingContent(_ content: LeadingContent?) -> Self
```

왼쪽 컨텐츠를 추가합니다.

</details>

<details><summary markdown="span"><code>menuResize(_:)</code></summary>

```swift
public func menuResize(_ menuResize: Modal.BottomSheet.Resize) -> Self
```

메뉴의 높이 detent를 지정합니다.

</details>