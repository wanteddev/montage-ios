---
1title: title(_:weight:color:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# title(_:weight:color:) 

텍스트의 타이포그래피 속성을 설정합니다.

```swift
@MainActor
func title(
    _ variant: Typography.Variant? = nil,
    weight: Typography.Weight? = nil,
    color: SwiftUI.Color? = nil
) -> Input
```

## Parameters 

variant

텍스트 변형 (.body2 또는 .label1)

weight

텍스트 굵기

color

텍스트 색상

## Return Value 

수정된 입력 컴포넌트

