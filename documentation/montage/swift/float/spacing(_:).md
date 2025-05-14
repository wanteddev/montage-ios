---
1title: spacing(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# spacing(_:) 

Spacing 열거형 값에 해당하는 Float 값을 반환합니다.MontageSwift

```swift
static func spacing(_ spacingComponent: Spacing) -> Float
```

## Parameters 

spacingComponent

사용할 간격 열거형 값

## Return Value 

지정된 간격에 해당하는 Float 값

## Discussion 

디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.

**사용 예시**:

```swift
let padding = Float.spacing(.pt16) // 16.0
```

