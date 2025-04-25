**ENUM**

# `Toast.Location`

```swift
public enum Location
```

토스트 메시지가 표시될 위치를 정의하는 열거형입니다.

- top: 화면 상단에 표시
- bottom: 화면 하단에 표시

## Cases
### `top(offset:)`

```swift
case top(offset: CGFloat = .zero)
```

화면 상단에 토스트 표시
#### Parameters

| Name | Description |
| ---- | ----------- |
| offset | 상단에서의 오프셋 값 (기본값: 0) |


### `bottom(offset:)`

```swift
case bottom(offset: CGFloat = .zero)
```

화면 하단에 토스트 표시
#### Parameters

| Name | Description |
| ---- | ----------- |
| offset | 하단에서의 오프셋 값 (기본값: 0) |
