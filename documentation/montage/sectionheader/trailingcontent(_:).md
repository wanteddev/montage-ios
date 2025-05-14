---
1title: trailingcontent(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# trailingContent(_:) 

헤더의 오른쪽에 추가적인 콘텐츠를 표시합니다.

```swift
@MainActor
func trailingContent(_ content: (() -> any View)? = nil) -> SectionHeader
```

## Parameters 

content

표시할 콘텐츠를 생성하는 클로저

## Return Value 

수정된 SectionHeader 인스턴스

## Discussion 

더보기 버튼이나 필터 등의 추가 기능을 제공할 때 사용합니다.

