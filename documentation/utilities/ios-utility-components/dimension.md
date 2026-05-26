---
title: Dimension
description: 컴포넌트의 너비/높이를 정의하는 시스템
---

```swift
enum Dimension
```

## Overview

Dimension은 아이콘, 아바타, 컨트롤 등 컴포넌트의 고정 치수(width/height)에 일관된 값을 적용하기 위한 토큰입니다.

```swift
// SwiftUI
Image(systemName: "star")
    .frame(width: .dimension24, height: .dimension24)

// UIKit
imageView.widthAnchor.constraint(equalToConstant: .dimension24).isActive = true
```

>  **Note**
>
> 실제 값은 `CGFloat.dimension{N}` 정적 프로퍼티로 노출됩니다. 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.

