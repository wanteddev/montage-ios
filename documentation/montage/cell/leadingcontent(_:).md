---
1title: leadingcontent(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# leadingContent(_:) 

셀 좌측에 추가 콘텐츠를 표시합니다.

```swift
@MainActor
func leadingContent(_ contents: (() -> any View)? = nil) -> Cell
```

## Parameters 

contents

표시할 콘텐츠를 생성하는 클로저

## Return Value 

수정된 Cell 인스턴스

## Discussion 

아이콘, 이미지, 기타 커스텀 뷰 등을 셀 타이틀 앞에 배치할 수 있습니다.

