---
1title: size
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Pagination.Counter.Size 

카운터 페이지네이션의 크기를 지정하는 열거형입니다.

```swift
enum Size
```

## Overview 

UI 디자인 요구사항에 따라 카운터의 크기를 선택할 수 있습니다.

**사용 예시**:

```swift
// 작은 크기의 카운터 페이지네이션
Pagination.Counter(selectedPage: $currentPage, totalPages: 5)
    .size(.small)
```

## Topics 

### Enumeration Cases 

- [case medium](/documentation/montage/pagination/counter/size/medium.md)

  중간 크기 (62x34pt, body2 폰트)

- [case small](/documentation/montage/pagination/counter/size/small.md)

  작은 크기 (52x26pt, label2 폰트)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/pagination/counter/size/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

