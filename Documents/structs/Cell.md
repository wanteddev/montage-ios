**STRUCT**

# `Cell`

```swift
public struct Cell: View
```

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:onTap:)</code></summary>

```swift
public init(
    title: String,
    onTap: (() -> Void)? = nil
)
```

</details>

<details><summary markdown="span"><code>titleVariant(_:)</code></summary>

```swift
public func titleVariant(_ variant: Typography.Variant) -> Self
```

타이틀 텍스트의 `variant` 속성을 조정합니다. 기본값은 `.body1`입니다.

</details>

<details><summary markdown="span"><code>titleWeight(_:)</code></summary>

```swift
public func titleWeight(_ weight: Typography.Weight) -> Self
```

타이틀 텍스트의 `weight` 속성을 조정합니다. 기본값은 `.regular`입니다.

</details>

<details><summary markdown="span"><code>titleColor(_:)</code></summary>

```swift
public func titleColor(_ color: Color.Semantic) -> Self
```

타이틀 텍스트의 `color` 속성을 조정합니다. 기본값은 `.labelNormal`입니다.

</details>

<details><summary markdown="span"><code>verticalPadding(_:)</code></summary>

```swift
public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self
```

상하 여백의 크기를 조정합니다. 기본값은 `.medium` 입니다.

</details>

<details><summary markdown="span"><code>verticalAlign(_:)</code></summary>

```swift
public func verticalAlign(_ verticalAlignment: VerticalAlignment) -> Self
```

상단 정렬을 조정합니다. 기본값은 `.center`입니다.

</details>

<details><summary markdown="span"><code>fillWidth(_:)</code></summary>

```swift
public func fillWidth(_ fillWidth: Bool = true) -> Self
```

좌우 여백 여부를 조정합니다. 기본값은 `false`입니다.

</details>

<details><summary markdown="span"><code>textEllipsis(_:)</code></summary>

```swift
public func textEllipsis(_ textEllipsis: Bool = true) -> Self
```

텍스트의 생략 여부를 조정합니다. 기본값은 `false`입니다. `false`인 경우 죄우 컨텐츠는 상단 정렬됩니다.

</details>

<details><summary markdown="span"><code>caption(_:)</code></summary>

```swift
public func caption(_ caption: String? = nil) -> Self
```

캡션을 추가합니다.

</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

비활성화 여부를 조정합니다. 기본값은 `false`입니다.

</details>

<details><summary markdown="span"><code>active(_:)</code></summary>

```swift
public func active(_ active: Bool = true) -> Self
```

활성화 상태로 만듭니다. 타이틀 텍스트의 색상을 `primaryNormal`로 변경하고 `trailingContent(_ contents: @escaping (Bool) -> some View)`의 입력 클로져의 파라메터로 활성화 여부를 받을 수 있습니다.

</details>

<details><summary markdown="span"><code>divider(_:)</code></summary>

```swift
public func divider(_ divider: Bool = true) -> Self
```

아래에 구분선을 추가합니다. 기본값은 `false`입니다.

</details>

<details><summary markdown="span"><code>chevron(_:)</code></summary>

```swift
public func chevron(_ chevron: Bool = true) -> Self
```

우측에 chevron 을 추가합니다.

</details>

<details><summary markdown="span"><code>leadingContent(_:)</code></summary>

```swift
public func leadingContent(_ contents: (() -> any View)? = nil) -> Self
```

좌측 컨텐츠를 지정합니다.

</details>

<details><summary markdown="span"><code>trailingContent(_:)</code></summary>

```swift
public func trailingContent(_ contents: ((Bool) -> any View)? = nil) -> Self
```

우측 컨텐츠를 지정합니다.

</details>

<details><summary markdown="span"><code>interactionPadding(_:)</code></summary>

```swift
public func interactionPadding(_ padding: CGFloat) -> Self
```

인터랙션 효과의 좌우 패딩을 조정합니다. 기본값은 12입니다.

</details>

<details><summary markdown="span"><code>highlight(_:)</code></summary>

```swift
public func highlight(_ text: String) -> Self
```

타이틀의 특정 텍스트를 bold로 강조합니다. 첫 번째 매칭되는 부분만 강조됩니다.

</details>
