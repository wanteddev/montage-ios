---
1title: init(title:scrolloffset:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(title:scrollOffset:) 

내비게이션 바를 초기화합니다.

```swift
@MainActor
init(
    title: String,
    scrollOffset: Binding<CGFloat> = .constant(0)
)
```

## Parameters 

title

내비게이션 바에 표시할 제목

scrollOffset

스크롤 오프셋에 대한 바인딩 (기본값: .constant(0))

