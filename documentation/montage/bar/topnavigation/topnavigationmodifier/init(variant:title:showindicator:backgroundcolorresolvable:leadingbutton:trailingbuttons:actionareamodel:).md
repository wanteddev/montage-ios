---
1title: init(variant:title:showindicator:backgroundcolorresolvable:leadingbutton:trailingbuttons:actionareamodel:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(variant:title:showIndicator:backgroundColorResolvable:leadingButton:trailingButtons:actionAreaModel:) 

TopNavigationModifier를 초기화합니다.

```swift
@MainActor
init(
    variant: Variant,
    title: String,
    showIndicator: Bool = true,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Resource.LeadingButton?,
    trailingButtons: [Resource.TrailingButton],
    actionAreaModel: ActionAreaModifier.Model? = nil
)
```

## Parameters 

variant

내비게이션 바의 외관 스타일

title

표시할 제목

showIndicator

인디케이터 표시 여부

backgroundColorResolvable

배경색 리졸버

leadingButton

좌측에 표시할 버튼

trailingButtons

우측에 표시할 버튼 배열

actionAreaModel

액션 영역 모델

