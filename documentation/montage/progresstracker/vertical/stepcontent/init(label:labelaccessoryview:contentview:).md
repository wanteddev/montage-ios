---
1title: init(label:labelaccessoryview:contentview:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(label:labelAccessoryView:contentView:) 

단계 콘텐츠를 초기화합니다.

```swift
@MainActor
init(
    label: String = "",
    labelAccessoryView: (() -> any View)? = nil,
    contentView: (() -> any View)? = nil
)
```

## Parameters 

label

단계의 제목 텍스트

labelAccessoryView

라벨 옆에 표시할 보조 뷰를 생성하는 클로저

contentView

라벨 아래에 표시할 추가 콘텐츠 뷰를 생성하는 클로저

