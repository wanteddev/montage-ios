**ENUM**

# `Select.LeadingContent`

```swift
public enum LeadingContent
```

왼쪽에 표시될 컨텐트 타입입니다.
- icon: 아이콘 표시
- iconButton: 아이콘 버튼 표시
- custom: 사용자 정의 뷰 표시

## Cases
### `icon(_:)`

```swift
case icon(Icon)
```

### `iconButton(_:)`

```swift
case iconButton(IconButton)
```

### `custom(_:)`

```swift
case custom(() -> any View)
```
