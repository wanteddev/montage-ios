**ENUM**

# `Toast.Variant`

```swift
public enum Variant: Equatable
```

토스트 메시지의 시각적 스타일을 정의하는 열거형입니다.

- normal: 기본 토스트 스타일 (선택적으로 아이콘과 색상 지정 가능)
- positive: 성공이나 긍정적인 메시지를 위한 녹색 체크 아이콘 스타일
- cautionary: 주의가 필요한 메시지를 위한 주황색 경고 아이콘 스타일
- negative: 오류나 실패 메시지를 위한 빨간색 아이콘 스타일

## Cases
### `normal(_:tint:)`

```swift
case normal(Montage.Icon? = nil, tint: Montage.Color.Semantic? = nil)
```

기본 스타일의 토스트
#### Parameters

| Name | Description |
| ---- | ----------- |
| icon | 표시할 아이콘 (선택 사항) |
| tint | 아이콘의 색상 (선택 사항) |


### `positive`

```swift
case positive
```

성공 메시지를 위한 녹색 체크 아이콘 스타일

### `cautionary`

```swift
case cautionary
```

주의 메시지를 위한 주황색 경고 아이콘 스타일

### `negative`

```swift
case negative
```

오류 메시지를 위한 빨간색 경고 아이콘 스타일
