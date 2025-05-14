---
1title: highlight(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# highlight(_:) 

타이틀의 특정 텍스트를 강조 표시합니다.

```swift
@MainActor
func highlight(_ text: String) -> Cell
```

## Parameters 

text

강조할 텍스트 문자열

## Return Value 

수정된 Cell 인스턴스

## Discussion 

지정한 문자열과 일치하는 부분을 굵은 글씨(bold)로 강조 표시합니다. 대소문자를 구분하지 않으며, 첫 번째로 일치하는 부분만 강조됩니다.

