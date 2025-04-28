**ENUM**

# `ContentBadge.ColorStyle`

```swift
public enum ColorStyle: Equatable, Hashable
```

뱃지의 색상을 결정하는 열거형입니다.

- neutral: 중립적인 회색 계열 뱃지
- accent: 강조 색상을 사용하는 뱃지

**사용 예시**:
```swift
ContentBadge(text: "이벤트")
    .colorStyle(.accent(SwiftUI.Color.red))
```

## Cases
### `neutral(_:)`

```swift
case neutral(_ contentColor: SwiftUI.Color? = nil)
```

중립 색상 뱃지
#### Parameters

| Name | Description |
| ---- | ----------- |
| contentColor | 콘텐츠 색상 (nil일 경우 기본 색상 사용) |


### `accent(_:background:)`

```swift
case accent(_ contentColor: SwiftUI.Color, background: SwiftUI.Color? = nil)
```

강조 색상 뱃지
#### Parameters

| Name | Description |
| ---- | ----------- |
| contentColor | 콘텐츠 색상 |
| background | 배경 색상 (nil일 경우 contentColor의 투명도를 조절하여 사용) |
