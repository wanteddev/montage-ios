Enumeration

# Tab.Resize 

탭 아이템 너비를 결정하는 열거형입니다.

```swift
enum Resize
```

## Overview 

탭 아이템의 너비가 콘텐츠에 맞게 조정될지, 전체 너비를 균등하게 분할할지 결정합니다.

**사용 예시**:

```swift
Tab(selectedIndex: $selectedTab, items: tabItems)
    .resize(.fill) // 균등하게 분할
```

> **Note**
>
> hug는 콘텐츠 너비에 맞게 조정되며, fill은 사용 가능한 전체 너비를 균등하게 분할합니다.

## Topics 

### Enumeration Cases 

- [case fill](/documentation/montage/tab/resize/fill.md)

  전체 너비를 균등하게 분할하여 탭 아이템 배치

- [case hug](/documentation/montage/tab/resize/hug.md)

  콘텐츠 크기에 맞게 탭 아이템의 너비 조정

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/tab/resize/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

