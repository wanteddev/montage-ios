**ENUM**

# `PushBadge.Position`

```swift
public enum Position
```

뱃지의 위치를 정의하는 열거형입니다.

수직 위치(top, center, bottom)와 수평 위치(leading, center, trailing)를 함께 지정할 수 있습니다.

**사용 예시**:
```swift
// 우측 상단에 위치
.modifier(PushBadge.Modifier(position: .top(.trailing)))

// 좌측 하단에 위치
.modifier(PushBadge.Modifier(position: .bottom(.leading)))
```

## Cases
### `top(_:)`

```swift
case top(HorizontalPosition = .center)
```

상단 위치
#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontalPosition | 수평 위치 (기본값: center) |


### `center(_:)`

```swift
case center(HorizontalPosition = .center)
```

중앙 위치
#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontalPosition | 수평 위치 (기본값: center) |


### `bottom(_:)`

```swift
case bottom(HorizontalPosition = .center)
```

하단 위치
#### Parameters

| Name | Description |
| ---- | ----------- |
| horizontalPosition | 수평 위치 (기본값: center) |
