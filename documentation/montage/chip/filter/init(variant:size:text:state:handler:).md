---
1title: init(variant:size:text:state:handler:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(variant:size:text:state:handler:) 

필터 칩을 초기화합니다.

```swift
@MainActor
init(
    variant: Variant = .solid,
    size: Size = .medium,
    text: String,
    state: Binding<State> = .constant(.normal),
    handler: (() -> Void)? = nil
)
```

## Parameters 

variant

칩의 외관 스타일, 기본값은 .solid

size

칩의 크기, 기본값은 .medium

text

칩에 표시할 텍스트

state

칩의 확장 상태 바인딩, 기본값은 .constant(.normal)

handler

칩 클릭 시 실행할 핸들러, 기본값은 nil

