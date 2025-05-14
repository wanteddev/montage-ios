---
1title: description(_:weight:color:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# description(_:weight:color:) 

설명 텍스트의 타이포그래피 속성을 조정합니다.

```swift
@MainActor
func description(
    _ variant: Typography.Variant = .label1,
    weight: Typography.Weight = .regular,
    color: SwiftUI.Color = .semantic(.labelNeutral)
) -> Accordion
```

## Parameters 

variant

텍스트 변형 (기본값: .label1)

weight

텍스트 굵기 (기본값: .regular)

color

텍스트 색상 (기본값: .semantic(.labelNeutral))

## Return Value 

수정된 아코디언 인스턴스

