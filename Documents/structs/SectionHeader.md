**STRUCT**

# `SectionHeader`

```swift
public struct SectionHeader: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:)</code></summary>

```swift
public init(title: String)
```

</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

사이즈를 조정합니다.

</details>

<details><summary markdown="span"><code>titleColor(_:)</code></summary>

```swift
public func titleColor(_ color: SwiftUI.Color) -> Self
```

타이틀 텍스트의 색상을 조정합니다. 기본값은 `.semantic(.labelNormal)`입니다.

</details>

<details><summary markdown="span"><code>headingContent(_:)</code></summary>

```swift
public func headingContent(_ content: (() -> any View)? = nil) -> Self
```

</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ content: (() -> any View)? = nil) -> Self
```

</details>