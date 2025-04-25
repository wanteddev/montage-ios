**STRUCT**

# `Select.Item`

```swift
public struct Item: Equatable
```

아이템 타입입니다.
Select 컴포넌트에서 사용하는 항목 모델을 정의합니다.

## Properties
<details><summary markdown="span"><code>text</code></summary>

```swift
public let text: String
```

아이템 텍스트 내용

</details>

<details><summary markdown="span"><code>icon</code></summary>

```swift
public let icon: Icon?
```

아이템의 아이콘 (선택 사항)

</details>

<details><summary markdown="span"><code>isNegative</code></summary>

```swift
public let isNegative: Bool
```

부정적 상태 여부 (오류나 경고를 나타낼 때 사용)

</details>

<details><summary markdown="span"><code>isSelected</code></summary>

```swift
public var isSelected: Bool
```

항목의 선택 여부

</details>

## Methods
<details><summary markdown="span"><code>init(text:icon:isNegative:isSelected:)</code></summary>

```swift
public init(
    text: String,
    icon: Icon? = nil,
    isNegative: Bool = false,
    isSelected: Bool = false
)
```

아이템 초기화
#### Parameters

| Name | Description |
| ---- | ----------- |
| text | 아이템 텍스트 |
| icon | 아이템 아이콘 (기본값: nil) |
| isNegative | 부정적 상태 여부 (기본값: false) |
| isSelected | 선택 여부 (기본값: false) |




</details>
