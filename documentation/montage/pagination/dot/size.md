---
1title: size
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Pagination.Dot.Size 

점 페이지네이션의 크기를 지정하는 열거형입니다.

```swift
enum Size
```

## Overview 

UI 디자인 요구사항에 따라 점의 크기를 선택할 수 있습니다.

**사용 예시**:

```swift
// 작은 크기의 점 페이지네이션
Pagination.Dot(selectedPage: $currentPage, totalPages: 5)
    .size(.small)
```

## Topics 

### Enumeration Cases 

- [case normal](/documentation/montage/pagination/dot/size/normal.md)

  표준 크기 (10pt 직경)

- [case small](/documentation/montage/pagination/dot/size/small.md)

  작은 크기 (6pt 직경)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/pagination/dot/size/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

