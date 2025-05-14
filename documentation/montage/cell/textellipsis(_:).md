---
1title: textellipsis(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# textEllipsis(_:) 

타이틀 텍스트의 생략 처리 여부를 설정합니다.

```swift
@MainActor
func textEllipsis(_ textEllipsis: Bool = true) -> Cell
```

## Parameters 

textEllipsis

텍스트 생략 처리 여부

## Return Value 

수정된 Cell 인스턴스

## Discussion 

true로 설정하면 타이틀 텍스트가 2줄로 제한되고, 초과 텍스트는 생략됩니다.

> **Note**
>
> 기본값은 false입니다. false인 경우 좌우 콘텐츠는 상단 정렬됩니다.

