**ENUM**

# `Resource.LeadingButton`

```swift
public enum LeadingButton
```

TopNavigation의 좌측에 표시될 내용들의 열거형입니다.

## Cases
### `back(action:)`

```swift
case back(action: () -> Void)
```

### `icon(_:action:)`

```swift
case icon(Icon, action: () -> Void)
```

### `text(_:action:)`

```swift
case text(String, action: () -> Void)
```
