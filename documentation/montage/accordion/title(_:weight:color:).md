---
1title: title(_:weight:color:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# title(_:weight:color:) 

타이틀 텍스트의 타이포그래피 속성을 조정합니다.

```swift
@MainActor
func title(
    _ variant: Typography.Variant = .body2,
    weight: Typography.Weight = .bold,
    color: SwiftUI.Color = .semantic(.labelNormal)
) -> Accordion
```

## Parameters 

variant

텍스트 변형 (기본값: .body2)

weight

텍스트 굵기 (기본값: .bold)

color

텍스트 색상 (기본값: .semantic(.labelNormal))

## Return Value 

수정된 아코디언 인스턴스

