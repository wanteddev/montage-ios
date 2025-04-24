**CLASS**

# `Button.OutlinedUIButton`

```swift
public class OutlinedUIButton: UIView
```

외곽선으로 둘러 싸인 곡선 모서리 버튼입니다.

테두리와 내부 컨텐츠로 구성된 둥근 모서리 버튼을 제공합니다.
텍스트, 아이콘 또는 둘의 조합을 표시할 수 있으며, 다양한 상호작용 상태에 대응합니다.

```swift
let button = Button.OutlinedUIButton()
button.text = "확인"
button.variant = .primary
button.size = .medium
button.handler = { print("버튼이 탭되었습니다.") }
```

## Properties
<details><summary markdown="span"><code>variant</code></summary>

```swift
public var variant: Variant = .primary
```

버튼의 외관입니다.

기본값은 `.primary`입니다.

</details>

<details><summary markdown="span"><code>size</code></summary>

```swift
public var size: Size = .large
```

버튼의 사이즈입니다.

기본값은 `.large`입니다.
> Important: Variant이 Assistive일 경우 .large를 사용할 수 없습니다.
> size 설정 시 constraint가 정상적으로 반영됩니다.

</details>

<details><summary markdown="span"><code>cornerStyle</code></summary>

```swift
public var cornerStyle: CornerStyle = .default
```

버튼의 모서리 곡률을 결정하는 스타일입니다.

기본값은 `.default`입니다.

</details>

<details><summary markdown="span"><code>state</code></summary>

```swift
public var state: Decorate.Interaction.State = .normal
```

사용자와의 인터렉션 상태를 표현합니다.

버튼의 현재 상호작용 상태를 나타냅니다.
기본값은 `.normal`입니다.

</details>

<details><summary markdown="span"><code>leadingIcon</code></summary>

```swift
public var leadingIcon: Icon?
```

텍스트의 좌측에 표현될 아이콘입니다.

텍스트가 있는 경우, 텍스트 앞에 나타납니다.

</details>

<details><summary markdown="span"><code>trailingIcon</code></summary>

```swift
public var trailingIcon: Icon?
```

텍스트의 우측에 표현될 아이콘입니다.

텍스트가 있는 경우, 텍스트 뒤에 나타납니다.

</details>

<details><summary markdown="span"><code>uniqueIcon</code></summary>

```swift
public var uniqueIcon: Icon?
```

iconOnly인 경우 표현될 아이콘입니다.

`iconOnly`가 `true`일 경우에만 표시됩니다.

</details>

<details><summary markdown="span"><code>iconOnly</code></summary>

```swift
public var iconOnly = false
```

uniqueIcon 노출 여부입니다.

`true`로 설정 시 `text`와 `leadingIcon`, `trailingIcon`은 표현되지 않고
`uniqueIcon`만 표시됩니다.
설정 시 constraint가 업데이트 됩니다.

</details>

<details><summary markdown="span"><code>text</code></summary>

```swift
public var text = ""
```

버튼에서 표현될 텍스트입니다.

버튼에 표시될 문자열을 설정합니다.

</details>

<details><summary markdown="span"><code>disable</code></summary>

```swift
public var disable = false
```

버튼의 활성화 여부입니다.

`true`로 설정 시 버튼이 비활성화되고 시각적으로 비활성 상태로 표시됩니다.
기본값은 `false`입니다.

</details>

<details><summary markdown="span"><code>contentUIColor</code></summary>

```swift
public var contentUIColor: UIColor?
```

커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.

`nil`이 아닌 경우, 지정된 색상으로 텍스트와 아이콘이 표시됩니다.

</details>

<details><summary markdown="span"><code>backgroundUIColor</code></summary>

```swift
public var backgroundUIColor: UIColor?
```

커스텀 가능한 배경색 입니다.

`nil`이 아닌 경우, 지정된 색상으로 버튼 배경이 표시됩니다.

</details>

<details><summary markdown="span"><code>borderUIColor</code></summary>

```swift
public var borderUIColor: UIColor?
```

커스텀 가능한 테두리색 입니다.

`nil`이 아닌 경우, 지정된 색상으로 버튼 테두리가 표시됩니다.

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public var handler: (() -> Void)?
```

버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.

버튼이 탭될 때 호출될 클로저입니다.

</details>

<details><summary markdown="span"><code>intrinsicContentSize</code></summary>

```swift
override public var intrinsicContentSize: CGSize
```

Element의 기본적인 사이즈를 정의합니다.

</details>

## Methods
<details><summary markdown="span"><code>init()</code></summary>

```swift
public init()
```

OutlinedUIButton 객체를 생성합니다.

기본 설정으로 버튼을 초기화합니다.

</details>

<details><summary markdown="span"><code>init(coder:)</code></summary>

```swift
public required init?(coder: NSCoder)
```

</details>

<details><summary markdown="span"><code>traitCollectionDidChange(_:)</code></summary>

```swift
override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
```

</details>

<details><summary markdown="span"><code>layoutSubviews()</code></summary>

```swift
override public func layoutSubviews()
```

</details>