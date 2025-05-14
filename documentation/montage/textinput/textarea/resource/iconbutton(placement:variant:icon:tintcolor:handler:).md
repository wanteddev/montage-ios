---
1title: iconbutton(placement:variant:icon:tintcolor:handler:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Case

# TextInput.TextArea.Resource.iconButton(placement:variant:icon:tintColor:handler:) 

아이콘 버튼

```swift
case iconButton(
    placement: Placement = .leading,
    variant: IconButton.Variant? = .solid(size: .small),
    icon: Icon,
    tintColor: SwiftUI.Color = .semantic(.labelAlternative),
    handler: (() -> Void)? = nil
)
```

## Parameters 

placement

버튼 위치

variant

버튼 변형 스타일

icon

버튼 아이콘

tintColor

아이콘 색상

handler

버튼 클릭 핸들러

