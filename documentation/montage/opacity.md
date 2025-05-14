---
1title: opacity
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Enumeration

# Opacity 

색상의 투명도를 정의한 열거형입니다.

```swift
enum Opacity
```

## Overview 

Montage 디자인 시스템에서 사용하는 정규화된 투명도 값을 제공합니다. 각 케이스는 백분율 형식으로 이름이 지정되어 있습니다 (예: p005는 5% 투명도).

## 사용 예시 

```swift
// CGFloat 값으로 변환
let alpha: CGFloat = .opacity(.p052)

// 뷰 투명도 설정
myView.alpha = .opacity(.p088)

// 색상 투명도 설정
let transparentColor = UIColor.black.withAlphaComponent(.opacity(.p043))
```

> **Note**
>
> 표준화된 투명도 값을 사용하면 디자인의 일관성을 유지하는 데 도움이 됩니다.

## Topics 

### Enumeration Cases 

- [case p000](/documentation/montage/opacity/p000.md)

  0% 투명도 (완전 불투명)

- [case p005](/documentation/montage/opacity/p005.md)

  5% 투명도

- [case p008](/documentation/montage/opacity/p008.md)

  8% 투명도

- [case p012](/documentation/montage/opacity/p012.md)

  12% 투명도

- [case p016](/documentation/montage/opacity/p016.md)

  16% 투명도

- [case p022](/documentation/montage/opacity/p022.md)

  22% 투명도

- [case p028](/documentation/montage/opacity/p028.md)

  28% 투명도

- [case p032](/documentation/montage/opacity/p032.md)

  32% 투명도

- [case p035](/documentation/montage/opacity/p035.md)

  35% 투명도

- [case p043](/documentation/montage/opacity/p043.md)

  43% 투명도

- [case p052](/documentation/montage/opacity/p052.md)

  52% 투명도

- [case p061](/documentation/montage/opacity/p061.md)

  61% 투명도

- [case p074](/documentation/montage/opacity/p074.md)

  74% 투명도

- [case p088](/documentation/montage/opacity/p088.md)

  88% 투명도

- [case p097](/documentation/montage/opacity/p097.md)

  97% 투명도

- [case p100](/documentation/montage/opacity/p100.md)

  100% 투명도 (완전 투명)

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/opacity/equatable-implementations.md)

## Relationships 

### Conforms To 

- Swift.Equatable
- Swift.Hashable

