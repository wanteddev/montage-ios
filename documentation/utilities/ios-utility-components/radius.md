---
title: Radius
description: 모서리 반경(corner radius)을 정의하는 시스템
---

```swift
enum Radius
```

## Overview

Radius는 컴포넌트의 둥근 모서리 반경을 일관되게 적용하기 위한 토큰입니다.

```swift
// SwiftUI
RoundedRectangle(cornerRadius: .radius12)

// UIKit
view.layer.cornerRadius = .radius12
```

>  **Note**
>
> 실제 값은 `CGFloat.radius{N}` 정적 프로퍼티로 노출됩니다. 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.

