---
1title: actionarea(model:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# actionArea(model:) 

현재 뷰에 하단 ActionArea를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func actionArea(model: ActionAreaModifier.Model) -> some View
```

## Parameters 

model

ActionArea의 구성 모델

## Return Value 

ActionArea가 적용된 뷰

## Discussion 

**사용 예시**:

```swift
contentView
    .actionArea(model: .init(
        variant: .strong(
            main: .init(text: "확인", action: { confirmAction() }),
            sub: .init(text: "취소", action: { cancelAction() })
        ),
        caption: "변경 사항을 저장하시겠습니까?"
    ))
```

