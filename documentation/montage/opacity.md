---
title: Opacity
description: 색상의 투명도를 정의한 열거형입니다.
---

```swift
enum Opacity
```

## Overview

Montage 디자인 시스템에서 사용하는 정규화된 투명도 값을 제공합니다. 각 케이스는 백분율 형식으로 이름이 지정되어 있습니다 (예: p005는 5% 투명도).

```swift
// CGFloat 값으로 변환
let alpha: CGFloat = .opacity(.p052)

// 뷰 투명도 설정
myView.alpha = .opacity(.p088)

// 색상 투명도 설정
let transparentColor = UIColor.black.withAlphaComponent(.opacity(.p043))
```

>  Note
>
> 표준화된 투명도 값을 사용하면 디자인의 일관성을 유지하는 데 도움이 됩니다.

## Topics

### Enumeration Cases


``case p000``

0% 투명도 (완전 불투명)

``case p005``

5% 투명도

``case p008``

8% 투명도

``case p012``

12% 투명도

``case p016``

16% 투명도

``case p022``

22% 투명도

``case p028``

28% 투명도

``case p032``

32% 투명도

``case p035``

35% 투명도

``case p043``

43% 투명도

``case p052``

52% 투명도

``case p061``

61% 투명도

``case p074``

74% 투명도

``case p088``

88% 투명도

``case p097``

97% 투명도

``case p100``

100% 투명도 (완전 투명)

### Default Implementations


[Equatable Implementations](/documentation/montage/opacity/equatable-implementations.md)

## Relationships

Conforms To

`Swift.Equatable`

`Swift.Hashable`



