---
1title: negative(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# negative(_:) 

텍스트 영역의 오류 상태를 설정합니다.

```swift
@MainActor
func negative(_ negative: Bool = true) -> TextInput.TextArea
```

## Parameters 

negative

오류 상태 여부, 기본값은 true

## Return Value 

수정된 텍스트 영역 인스턴스

## Discussion 

오류 상태일 때는 텍스트 영역이 적색 테두리로 강조됩니다.

