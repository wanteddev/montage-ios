---
1title: extra(_:divider:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# extra(_:divider:) 

버튼 위에 표시할 추가 콘텐츠를 설정합니다.

```swift
@MainActor
func extra(
    _ content: (() -> any View)?,
    divider: Bool = true
) -> ActionArea
```

## Parameters 

content

표시할 추가 콘텐츠를 생성하는 클로저

divider

추가 콘텐츠 위에 구분선 표시 여부, 기본값은 true

## Return Value 

수정된 ActionArea 인스턴스

