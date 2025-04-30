**STRUCT**

# `Menu.Item`

```swift
public struct Item: Equatable
```

메뉴 항목의 데이터를 정의하는 구조체입니다.

제목과 선택 상태를 포함합니다.

**사용 예시**:
```swift
Menu.Item(title: "메뉴 항목", isSelected: false)
```

## Properties
<details><summary markdown="span"><code>title</code></summary>

```swift
public let title: String
```

</details>

<details><summary markdown="span"><code>isSelected</code></summary>

```swift
public var isSelected: Bool
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:isSelected:)</code></summary>

```swift
public init(title: String, isSelected: Bool = false)
```

메뉴 항목을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| title | 메뉴 항목에 표시될 텍스트 |
| isSelected | 초기 선택 상태 (기본값: false) |




</details>
