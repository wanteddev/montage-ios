**ENUM**

# `Resource.LeadingButton`

```swift
public enum LeadingButton
```

TopNavigation의 좌측에 표시될 내용들의 열거형입니다.

뒤로가기 버튼, 아이콘 버튼, 텍스트 버튼을 지원합니다.

**사용 예시**:
```swift
Bar.TopNavigation(
    leadingButton: .back {
        // 뒤로가기 동작
    }
)
```

## Cases
### `back(action:)`

```swift
case back(action: () -> Void)
```

뒤로가기 버튼

### `icon(_:action:)`

```swift
case icon(Icon, action: () -> Void)
```

아이콘 버튼

### `text(_:action:)`

```swift
case text(String, action: () -> Void)
```

텍스트 버튼
