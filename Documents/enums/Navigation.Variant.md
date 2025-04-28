**ENUM**

# `Navigation.Variant`

```swift
public enum Variant: Equatable
```

내비게이션 바의 외관을 정의하는 열거형입니다.

- normal: 기본 스타일의 내비게이션 바
- extended: 제목이 별도 줄에 표시되는 확장된 스타일
- floating: 배경이 투명한 플로팅 스타일
- emphasized: 강조된 큰 제목 스타일

## Cases
### `normal`

```swift
case normal
```

### `extended`

```swift
case extended
```

### `floating(alternative:background:)`

```swift
case floating(alternative: Bool = false, background: Bool = true)
```

### `emphasized`

```swift
case emphasized
```
