---
1title: init(variant:title:scrolloffset:backgroundcolorresolvable:leadingbutton:trailingbuttons:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(variant:title:scrollOffset:backgroundColorResolvable:leadingButton:trailingButtons:) 

TopNavigation을 초기화합니다.

```swift
@MainActor
init(
    variant: Variant = .normal,
    title: String = "",
    scrollOffset: CGFloat = .zero,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Resource.LeadingButton? = nil,
    trailingButtons: [Resource.TrailingButton] = []
)
```

## Parameters 

variant

내비게이션 바의 외관 스타일

title

표시할 제목

scrollOffset

스크롤 오프셋 값

backgroundColorResolvable

배경색 리졸버

leadingButton

좌측에 표시할 버튼

trailingButtons

우측에 표시할 버튼 배열 (최대 3개까지 표시)

