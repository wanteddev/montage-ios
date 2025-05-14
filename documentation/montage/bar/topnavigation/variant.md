---
1title: variant
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Bar.TopNavigation.Variant 

TopNavigation의 외관을 결정하는 열거형입니다.

```swift
enum Variant
```

## Overview 

내비게이션 바의 다양한 레이아웃과 시각적 스타일을 정의합니다.

**사용 예시**:

```swift
Bar.TopNavigation(
    variant: .floating(alternative: true, background: true),
    title: "제목"
)
```

## Topics 

### Enumeration Cases 

- [case extended](/documentation/montage/bar/topnavigation/variant/extended.md)

  확장된 내비게이션 바 스타일 (제목이 별도의 줄에 표시됨)

- [case floating(alternative: Bool, background: Bool)](/documentation/montage/bar/topnavigation/variant/floating(alternative:background:).md)

  플로팅 스타일의 내비게이션 바

- [case normal](/documentation/montage/bar/topnavigation/variant/normal.md)

  기본 내비게이션 바 스타일

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/bar/topnavigation/variant/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable

