---
1title: init(selectedpage:totalpages:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(selectedPage:totalPages:) 

카운터 형태의 페이지네이션을 초기화합니다.

```swift
@MainActor
init(
    selectedPage: Binding<Int>,
    totalPages: Int
)
```

## Parameters 

selectedPage

현재 선택된 페이지 번호 (1부터 시작)

totalPages

전체 페이지 수

