**CLASS**

# `Chip.FilterUIView`

```swift
public class FilterUIView: UIView
```

**`Deprecated`**

필터 칩의 UI 구현을 위한 내부 뷰 클래스입니다.

`FilterUIView`는 `Chip.Filter`의 실제 UI 구현체로, UIKit 기반으로 구현되어 있습니다.
SwiftUI에서 `UIViewRepresentable`을 통해 사용되며, 다양한 상태와 스타일을 표현할 수 있습니다.

이 클래스는 다음과 같은 주요 기능을 제공합니다:
- 다양한 외관 스타일 지원 (solid, outlined)
- 크기 조정 (xsmall, small, medium, large)
- 확장 상태 표시 (normal, expand)
- 활성/비활성 상태 표시
- 사용자 상호작용 효과

- Warning: 이 클래스는 더 이상 사용되지 않으며 향후 릴리스에서 제거될 예정입니다.
  SwiftUI에서 `Chip.Filter`를 직접 사용하세요.

- Note: 이 클래스는 `Chip.Filter`의 내부 구현체이므로 직접 사용보다는
  SwiftUI에서 `Chip.Filter`를 통해 사용하는 것이 권장됩니다.

## Properties
<details><summary markdown="span"><code>variant</code></summary>

```swift
public var variant: Filter.Variant = .solid
```

칩의 외관입니다.

</details>

<details><summary markdown="span"><code>state</code></summary>

```swift
public var state: Filter.State = .normal
```

칩의 확장 상태입니다.

</details>

<details><summary markdown="span"><code>size</code></summary>

```swift
public var size: Filter.Size = .medium
```

칩의 사이즈입니다.

</details>

<details><summary markdown="span"><code>interactionState</code></summary>

```swift
public var interactionState: Decorate.Interaction.State = .normal
```

사용자와의 인터렉션 상태를 표현합니다.

</details>

<details><summary markdown="span"><code>text</code></summary>

```swift
public var text = ""
```

칩에서 표현될 텍스트입니다.

</details>

<details><summary markdown="span"><code>active</code></summary>

```swift
public var active = false
```

칩의 선택 여부입니다.

</details>

<details><summary markdown="span"><code>activeLabel</code></summary>

```swift
public var activeLabel: String? = nil
```

칩 선택시 표시될 텍스트입니다.
값이 있는 경우에 표시되며 기본값은 칩의 텍스트가 표현됩니다.

</details>

<details><summary markdown="span"><code>disable</code></summary>

```swift
public var disable = false
```

칩의 활성화 여부입니다.

</details>

<details><summary markdown="span"><code>iconUIColor</code></summary>

```swift
public var iconUIColor: UIColor?
```

커스텀 가능한 아이콘 컬러 입니다.
montage의 모든 컬러를 사용할 수 있습니다.

</details>

<details><summary markdown="span"><code>fontUIColor</code></summary>

```swift
public var fontUIColor: UIColor?
```

커스텀 가능한 텍스트 컬러 입니다.
montage의 모든 컬러를 사용할 수 있습니다.

</details>

<details><summary markdown="span"><code>handler</code></summary>

```swift
public var handler: (() -> Void)?
```

칩이 탭되었을 때 실행될 핸들러입니다.

사용자가 칩을 탭하면 이 클로저가 호출됩니다.

</details>

<details><summary markdown="span"><code>intrinsicContentSize</code></summary>

```swift
override public var intrinsicContentSize: CGSize
```

필터 칩의 기본 내용 크기를 계산합니다.

텍스트 크기, 아이콘 크기, 여백 등을 고려하여 칩의 적절한 크기를 계산합니다.

#### Returns

계산된 콘텐츠 크기

</details>

## Methods
<details><summary markdown="span"><code>init()</code></summary>

```swift
public init()
```

기본 이니셜라이저입니다.

필터 칩 뷰를 초기화하고 기본 설정을 적용합니다.

</details>

<details><summary markdown="span"><code>init(coder:)</code></summary>

```swift
required public init?(coder: NSCoder)
```

스토리보드에서 사용하기 위한 이니셜라이저입니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| coder | 디코더 객체 |




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
