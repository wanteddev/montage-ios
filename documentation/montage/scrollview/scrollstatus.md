---
1title: scrollstatus
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# ScrollView.ScrollStatus 

스크롤 뷰의 상태를 추적하는 구조체입니다.

```swift
struct ScrollStatus
```

## Overview 

스크롤 방향, 스크롤 뷰 크기, 콘텐츠 크기, 오프셋 등의 정보를 포함합니다.

## Topics 

### Initializers 

- [init(axis: Axis, scrollViewSize: CGSize, contentSize: CGSize, contentOffset: CGPoint)](/documentation/montage/scrollview/scrollstatus/init(axis:scrollviewsize:contentsize:contentoffset:).md)

  스크롤 상태를 초기화합니다.

### Instance Properties 

- [var axis: Axis](/documentation/montage/scrollview/scrollstatus/axis.md)

- [var contentOffset: CGPoint](/documentation/montage/scrollview/scrollstatus/contentoffset.md)

- [var contentSize: CGSize](/documentation/montage/scrollview/scrollstatus/contentsize.md)

- [var scrollViewSize: CGSize](/documentation/montage/scrollview/scrollstatus/scrollviewsize.md)

- [var scrolledToMax: Bool](/documentation/montage/scrollview/scrollstatus/scrolledtomax.md)

  스크롤이 최대 위치에 도달했는지 여부입니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/scrollview/scrollstatus/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

