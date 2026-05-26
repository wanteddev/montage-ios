---
title: Primitive
description: 모든 치수 토큰의 원시 척도(Primitive scale)
---

```swift
enum Primitive
```

## Overview

Primitive는 Spacing, Radius, Dimension 등 상위 토큰의 기반이 되는 원시 수치 값입니다. 일반적으로 컴포넌트 구현에서 직접 사용하지 말고, 의도가 명시된 상위 토큰 (`.spacing{N}`, `.radius{N}`, `.dimension{N}`)을 사용하세요.

```swift
// 권장: 의도가 명시된 상위 토큰 사용
let padding = CGFloat.spacing16

// 예외: 적합한 상위 토큰이 없을 때만 Primitive 사용
let custom = CGFloat.primitive18
```

>  **Note**
>
> 실제 값은 `CGFloat.primitive{N}` 정적 프로퍼티로 노출됩니다. 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.

