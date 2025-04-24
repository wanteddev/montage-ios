**CLASS**

# `ContentBadgeUIView`

```swift
public class ContentBadgeUIView: UIView
```

컨텐츠의 카테고리를 표현할 때 사용할 수 있는 컨텐츠 뱃지입니다.

이 컴포넌트는 다양한 스타일과 크기를 지원하며, 텍스트와 함께 아이콘을 표시할 수 있습니다.

## 개요
`ContentBadgeUIView`는 카테고리나 상태를 시각적으로 표현하기 위한 UI 컴포넌트입니다.
Solid 또는 Outline 스타일로 표현할 수 있으며, 다양한 크기와 색상을 지원합니다.

- Warning: 이 클래스는 더 이상 사용되지 않으며, 대신 `Montage.ContentBadge`를 사용하세요.
- SeeAlso: ``ContentBadge``

## 사용 예시
```swift
// 기본 사용법
let badge = ContentBadgeUIView()
badge.text = "카테고리"
badge.variant = .solid
badge.size = .small
badge.colorStyle = .neutral()

// 아이콘 추가
badge.leadingIcon = UIImage(named: "icon-category")

// 커스텀 색상 적용
badge.colorStyle = .accent(.blue, nil)
```

## Properties
<details><summary markdown="span"><code>variant</code></summary>

```swift
public var variant: ContentBadge.Variant = .solid
```

뱃지의 외관 스타일입니다.

- `.solid`: 배경색이 채워진 스타일
- `.outline`: 테두리만 있는 스타일

</details>

<details><summary markdown="span"><code>size</code></summary>

```swift
public var size: ContentBadge.Size = .small
```

뱃지의 크기입니다.

- `.xsmall`: 가장 작은 크기 (12pt 아이콘)
- `.small`: 작은 크기 (14pt 아이콘)
- `.medium`: 중간 크기 (16pt 아이콘)

</details>

<details><summary markdown="span"><code>colorStyle</code></summary>

```swift
public var colorStyle: ContentBadge.ColorStyle = .neutral()
```

뱃지에 적용될 색상 스타일입니다.

- `.neutral()`: 기본 중립 색상
- `.accent(contentColor, enclosureColor)`: 커스텀 강조 색상

</details>

<details><summary markdown="span"><code>leadingIcon</code></summary>

```swift
public var leadingIcon: UIImage?
```

텍스트의 좌측에 표시될 아이콘입니다.

아이콘은 현재 색상 스타일에 맞게 색상이 자동으로 적용됩니다.

</details>

<details><summary markdown="span"><code>trailingIcon</code></summary>

```swift
public var trailingIcon: UIImage?
```

텍스트의 우측에 표시될 아이콘입니다.

아이콘은 현재 색상 스타일에 맞게 색상이 자동으로 적용됩니다.

</details>

<details><summary markdown="span"><code>text</code></summary>

```swift
public var text = ""
```

뱃지에 표시될 텍스트입니다.

</details>

<details><summary markdown="span"><code>intrinsicContentSize</code></summary>

```swift
override public var intrinsicContentSize: CGSize
```

뱃지의 기본 크기를 계산하여 반환합니다.

이 메서드는 텍스트 크기, 아이콘 크기, 여백을 고려하여 최적의 크기를 계산합니다.

- Returns: 계산된 뱃지의 크기

</details>

## Methods
<details><summary markdown="span"><code>init()</code></summary>

```swift
public init()
```

기본 초기화 메서드입니다.

이 메서드는 프레임을 `.zero`로 초기화하고 기본 UI 요소를 설정합니다.

</details>

<details><summary markdown="span"><code>init(coder:)</code></summary>

```swift
public required init?(coder: NSCoder)
```

Interface Builder와 함께 사용할 때 호출되는 초기화 메서드입니다.

- Parameter coder: 디코더 객체

#### Parameters

| Name | Description |
| ---- | ----------- |
| coder | 디코더 객체 |

</details>

<details><summary markdown="span"><code>traitCollectionDidChange(_:)</code></summary>

```swift
override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
```

트레이트 컬렉션이 변경될 때 호출되는 메서드입니다.

다크 모드와 라이트 모드 전환 시 UI를 업데이트합니다.

- Parameter previousTraitCollection: 이전 트레이트 컬렉션

#### Parameters

| Name | Description |
| ---- | ----------- |
| previousTraitCollection | 이전 트레이트 컬렉션 |

</details>

<details><summary markdown="span"><code>layoutSubviews()</code></summary>

```swift
override public func layoutSubviews()
```

하위 뷰의 레이아웃이 변경될 때 호출되는 메서드입니다.

</details>