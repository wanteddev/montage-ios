**ENUM**

# `ActionArea.Variant`

```swift
public enum Variant
```

ActionArea의 버튼 레이아웃 변형을 정의합니다.

- `.strong`: 강조된 주 버튼과 보조/대체 버튼이 있는 레이아웃
- `.neutral`: 중립적인 스타일의 버튼 레이아웃
- `.cancel`: 취소 버튼만 있는 간단한 레이아웃

## Cases
### `strong(main:sub:alternative:)`

```swift
case strong(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
```

### `neutral(main:sub:alternative:)`

```swift
case neutral(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
```

### `cancel(main:)`

```swift
case cancel(main: ButtonInfo)
```
