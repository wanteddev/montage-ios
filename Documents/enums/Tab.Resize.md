**ENUM**

# `Tab.Resize`

```swift
public enum Resize
```

탭 아이템 너비를 결정하는 열거형입니다.

탭 아이템의 너비가 콘텐츠에 맞게 조정될지, 전체 너비를 균등하게 분할할지 결정합니다.

**사용 예시**:
```swift
Tab(selectedIndex: $selectedTab, items: tabItems)
    .resize(.fill) // 균등하게 분할
```

- Note: `hug`는 콘텐츠 너비에 맞게 조정되며, `fill`은 사용 가능한 전체 너비를 균등하게 분할합니다.

## Cases
### `hug`

```swift
case hug
```

콘텐츠 크기에 맞게 탭 아이템의 너비 조정

### `fill`

```swift
case fill
```

전체 너비를 균등하게 분할하여 탭 아이템 배치
