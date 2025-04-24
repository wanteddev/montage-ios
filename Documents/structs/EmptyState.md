**STRUCT**

# `EmptyState`

```swift
public struct EmptyState: View
```

콘텐츠가 빈 상태일 때 사용자의 이해를 돕기 위한 컴포넌트입니다.

> image, title과 button은 선택적으로 사용할 수 있습니다.

컴포넌트가 기본적으로 화면 전체를 차지하므로 필요하다면
.frame modifier를 사용하여 크기를 조절하여 사용하시길 권장합니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(image:title:description:button:)</code></summary>

```swift
public init(
    image: (() -> any View)? = nil,
    title: String? = nil,
    description: String,
    button: (() -> any View)? = nil
)
```

</details>