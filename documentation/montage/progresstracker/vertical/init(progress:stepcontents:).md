---
1title: init(progress:stepcontents:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(progress:stepContents:) 

수직 진행 추적기를 초기화합니다.

```swift
@MainActor
init(
    progress: Binding<Int>,
    stepContents: [StepContent]
)
```

## Parameters 

progress

현재 진행 중인 단계 (1부터 시작)

stepContents

각 단계의 콘텐츠 배열

