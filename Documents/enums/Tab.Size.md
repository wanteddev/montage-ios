**ENUM**

# `Tab.Size`

```swift
public enum Size
```

탭 아이템의 크기를 결정하는 열거형입니다.

탭 컴포넌트의 높이와 폰트 크기를 결정합니다.

**사용 예시**:
```swift
Tab(selectedIndex: $selectedTab, items: tabItems)
    .size(.large) // 큰 크기의 탭
```

- Note: small(40pt, body2), medium(48pt, headline2), large(56pt, heading2) 세 가지 크기를 제공합니다.

## Cases
### `small`

```swift
case small
```

작은 크기 (40pt 높이, body2 폰트)

### `medium`

```swift
case medium
```

중간 크기 (48pt 높이, headline2 폰트)

### `large`

```swift
case large
```

큰 크기 (56pt 높이, heading2 폰트)
