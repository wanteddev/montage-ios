**ENUM**

# `Bar.TopNavigation.Variant`

```swift
public enum Variant: Equatable
```

TopNavigation의 외관을 결정하는 열거형입니다.

내비게이션 바의 다양한 레이아웃과 시각적 스타일을 정의합니다.

**사용 예시**:
```swift
Bar.TopNavigation(
    variant: .floating(alternative: true, background: true),
    title: "제목"
)
```

## Cases
### `normal`

```swift
case normal
```

기본 내비게이션 바 스타일

### `extended`

```swift
case extended
```

확장된 내비게이션 바 스타일 (제목이 별도의 줄에 표시됨)

### `floating(alternative:background:)`

```swift
case floating(alternative: Bool = false, background: Bool = false)
```

플로팅 스타일의 내비게이션 바
#### Parameters

| Name | Description |
| ---- | ----------- |
| alternative | 대체 색상 사용 여부 |
| background | 배경색 적용 여부 |
