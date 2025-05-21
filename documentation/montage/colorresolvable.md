---
title: ColorResolvable
description: 색상을 동적으로 해석할 수 있는 타입을 정의하는 프로토콜
---

```swift
protocol ColorResolvable
```

## Overview

이 프로토콜을 준수하는 타입은 주어진 UITraitCollection에 따라 적절한 UIColor를 반환할 수 있어야 합니다.

>  See Also
>
> `Color.Atomic`, `Color.Semantic`

## Topics

### Instance Methods


``func resolve(UITraitCollection) -> UIColor``

주어진 UITraitCollection에 따라 UIColor를 반환합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `traitCollection` | 색상을 해석할 UITraitCollection |
- **Return Value**

  해석된 UIColor 인스턴스

## Relationships

