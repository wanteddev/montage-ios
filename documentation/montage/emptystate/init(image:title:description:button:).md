---
1title: init(image:title:description:button:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(image:title:description:button:) 

EmptyState 컴포넌트를 초기화합니다.

```swift
@MainActor
init(
    image: (() -> any View)? = nil,
    title: String? = nil,
    description: String,
    button: (() -> any View)? = nil
)
```

## Parameters 

image

상단에 표시할 이미지 뷰를 반환하는 클로저 (선택 사항)

title

강조되어 표시할 제목 (선택 사항)

description

상황을 설명하는 텍스트 (필수)

button

하단에 표시할 버튼 뷰를 반환하는 클로저 (선택 사항)

## Discussion 

원하는 레이아웃을 구성하기 위해 이미지, 제목, 설명, 버튼을 선택적으로 제공할 수 있습니다. 설명은 필수이며, 최대 2줄로 표시됩니다.

