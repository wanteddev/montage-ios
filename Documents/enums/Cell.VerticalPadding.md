**ENUM**

# `Cell.VerticalPadding`

```swift
public enum VerticalPadding
```

상하 여백을 나타내는 열거형입니다.

셀 컴포넌트의 상하 여백을 조정할 때 사용되며, 각 케이스는 다양한 크기의 여백을 제공합니다.

**사용 예시**:
```swift
Cell(title: "넓은 여백이 있는 셀")
    .verticalPadding(.large)
```

- Note: 여백 크기는 none(0), small(8), medium(12), large(16)으로 정의됩니다.

## Cases
### `none`

```swift
case none
```

여백 없음 (0pt)

### `small`

```swift
case small
```

작은 여백 (8pt)

### `medium`

```swift
case medium
```

중간 여백 (12pt)

### `large`

```swift
case large
```

큰 여백 (16pt)

## Properties
<details><summary markdown="span"><code>length</code></summary>

```swift
public var length: CGFloat
```

여백 값을 포인트 단위로 반환합니다.

#### Returns

선택한 여백 케이스에 해당하는 CGFloat 값

</details>
