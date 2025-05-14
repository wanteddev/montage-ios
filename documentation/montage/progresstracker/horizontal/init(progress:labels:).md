---
1title: init(progress:labels:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(progress:labels:) 

수평 진행 추적기를 초기화합니다.

```swift
@MainActor
init(
    progress: Binding<Int>,
    labels: [String]
)
```

## Parameters 

progress

현재 진행 중인 단계 (1부터 시작)

labels

각 단계의 라벨 텍스트 배열

