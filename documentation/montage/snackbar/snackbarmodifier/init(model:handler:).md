---
1title: init(model:handler:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(model:handler:) 

SnackBarModifier를 초기화합니다.

```swift
@MainActor
init(
    model: Binding<SnackBar.Model?>,
    handler: @escaping () -> Void
)
```

## Parameters 

model

표시할 스낵바 모델에 대한 바인딩. nil이면 스낵바가 표시되지 않습니다.

handler

스낵바의 액션 버튼이 클릭될 때 실행할 핸들러

