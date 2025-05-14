---
1title: trailingcontent(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# trailingContent(_:) 

텍스트 필드 오른쪽에 표시할 커스텀 콘텐츠를 설정합니다.

```swift
@MainActor
func trailingContent(_ trailingContent: (() -> any View)?) -> TextInput.TextField
```

## Parameters 

trailingContent

표시할 커스텀 콘텐츠를 생성하는 클로저

## Return Value 

수정된 텍스트 필드 인스턴스

## Discussion 

> **Note**
>
> trailingButton과 함께 사용하는 경우 trailingContent가 무시됩니다.

