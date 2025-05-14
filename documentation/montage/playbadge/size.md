---
1title: size
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# PlayBadge.Size 

재생 배지의 크기를 정의하는 열거형입니다.

```swift
enum Size
```

## Overview 

미디어 콘텐츠의 크기나 중요도에 따라 적절한 배지 크기를 선택할 수 있습니다.

**사용 예시**:

```swift
PlayBadge()
    .size(.large) // 큰 크기의 배지 사용
```

> **Note**
>
> small(36pt), medium(60pt), large(80pt) 세 가지 크기를 제공합니다.

## Topics 

### Enumeration Cases 

- [case large](/documentation/montage/playbadge/size/large.md)

  큰 크기 배지 (80pt)

- [case medium](/documentation/montage/playbadge/size/medium.md)

  중간 크기 배지 (60pt, 기본값)

- [case small](/documentation/montage/playbadge/size/small.md)

  작은 크기 배지 (36pt)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/playbadge/size/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

