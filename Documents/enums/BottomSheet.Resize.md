**ENUM**

# `BottomSheet.Resize`

```swift
public enum Resize
```

바텀 시트의 크기를 정의하는 열거형입니다.

- hug: 컨텐츠 크기에 맞게 자동 조절됩니다.
- fixedRatio: 화면 높이의 특정 비율로 고정됩니다.
- fixedHeight: 지정한 높이로 고정됩니다.
- flexible: 사용자가 드래그하여 크기를 조절할 수 있습니다.
- fill: 화면 전체를 채웁니다.

## Cases
### `hug`

```swift
case hug
```

### `fixedRatio(_:)`

```swift
case fixedRatio(CGFloat)
```

### `fixedHeight(_:)`

```swift
case fixedHeight(CGFloat)
```

### `flexible`

```swift
case flexible
```

### `fill`

```swift
case fill
```
