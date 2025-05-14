---
1title: variant
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Pagination.Dot.Variant 

점 페이지네이션의 색상 변형을 지정하는 열거형입니다.

```swift
enum Variant
```

## Overview 

배경색이나 사용 컨텍스트에 따라 적합한 색상 테마를 선택할 수 있습니다.

**사용 예시**:

```swift
// 어두운 배경에 사용
Pagination.Dot(selectedPage: $currentPage, totalPages: 5)
    .variant(.white)
```

## Topics 

### Enumeration Cases 

- [case normal](/documentation/montage/pagination/dot/variant/normal.md)

  기본 스타일 (회색 배경에 검은색 점)

- [case white](/documentation/montage/pagination/dot/variant/white.md)

  흰색 스타일 (어두운 배경에 적합)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/pagination/dot/variant/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

