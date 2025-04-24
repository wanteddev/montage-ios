**STRUCT**

# `Modal.BottomSheet`

```swift
public struct BottomSheet: View
```

Modal/BottomSheet Component입니다.

.sheet(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
```
.sheet(
  isPresented: Binding<Bool>,
  content: {
      Modal.BottomSheet {
          ...
      }
})
```

- Parameters:
    - needHandle: Content 표시 영역을 변경시킬 수 있는 handle의 여부 입니다. 기본값은 true입니다.
    - resize: Content가 표시될 영역의 사이즈 입니다. 기본값은 .hug입니다.
    - containScrollView: Content에 ScrollView 가 삽입된 경우 전달합니다. 기본값은 false입니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(_:)</code></summary>

```swift
public init(_ content: @escaping () -> any View)
```

</details>

<details><summary markdown="span"><code>needHandle(_:)</code></summary>

```swift
public func needHandle(_ needHandle: Bool) -> Self
```

</details>

<details><summary markdown="span"><code>resize(_:)</code></summary>

```swift
public func resize(_ resize: Modal.BottomSheet.Resize) -> Self
```

</details>

<details><summary markdown="span"><code>modalNavigation(_:)</code></summary>

```swift
public func modalNavigation(_ navigation: (() -> Montage.Modal.Navigation)?) -> Self
```

</details>

<details><summary markdown="span"><code>modalActionArea(_:)</code></summary>

```swift
public func modalActionArea(_ actionAreaModel: ActionAreaModifier.Model?) -> Self
```

</details>

<details><summary markdown="span"><code>ignoresEdgeInsets(_:)</code></summary>

```swift
public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self
```

</details>