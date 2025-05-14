---
1title: opacity(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# opacity(_:) 

Opacity 열거형 값에 해당하는 Float 불투명도 값을 반환합니다.MontageSwift

```swift
static func opacity(_ opacityComponent: Opacity) -> Float
```

## Parameters 

opacityComponent

사용할 불투명도 열거형 값

## Return Value 

지정된 불투명도에 해당하는 Float 값 (0.0 ~ 1.0 범위)

## Discussion 

디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.

**사용 예시**:

```swift
let alpha = Float.opacity(.p050) // 0.5
```

