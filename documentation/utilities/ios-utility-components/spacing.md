---
title: Spacing
description: UI 요소 간의 간격(gap, padding)을 정의하는 시스템
---

```swift
enum Spacing
```

## Overview

Spacing은 Montage 디자인 시스템에서 UI 요소 간의 일관된 간격을 제공하기 위한 규격화된 값들을 정의합니다.

```swift
// UIKit
view.layoutMargins = UIEdgeInsets(
    top: .spacing16, left: .spacing16, bottom: .spacing16, right: .spacing16
)

// SwiftUI
Text("Hello, World!")
    .padding(.horizontal, .spacing24)
    .padding(.vertical, .spacing16)
```

>  **Note**
>
> 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다. 예를 들어 spacing16은 16포인트의 간격을 의미합니다.

실제 값은 `CGFloat.spacing{N}` 정적 프로퍼티로 노출됩니다. 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.

