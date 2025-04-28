**ENUM**

# `Skeleton.Length`

```swift
public enum Length: CGFloat
```

스켈레톤 요소의 길이 비율을 지정하는 열거형입니다.

텍스트 스켈레톤에서 각 라인의 길이를 상대적으로 지정하는 데 사용됩니다.

**사용 예시**:
```swift
.text(lengths: [._100, ._75, ._50], lineNumber: 3)
```

## Cases
### `_100`

```swift
case _100 = 1
```

100% 길이 (전체 너비)

### `_75`

```swift
case _75 = 0.75
```

75% 길이

### `_50`

```swift
case _50 = 0.5
```

50% 길이

### `_25`

```swift
case _25 = 0.25
```

25% 길이
