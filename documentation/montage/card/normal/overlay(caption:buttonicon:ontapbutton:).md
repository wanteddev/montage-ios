---
1title: overlay(caption:buttonicon:ontapbutton:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# overlay(caption:buttonIcon:onTapButton:) 

썸네일에 오버레이할 콘텐츠를 설정합니다.

```swift
@MainActor
func overlay(
    caption: String? = nil,
    buttonIcon: Montage.Icon? = nil,
    onTapButton: (() -> Void)? = nil
) -> Card.Normal
```

## Parameters 

caption

오버레이에 표시할 텍스트

buttonIcon

오버레이에 표시할 버튼 아이콘

onTapButton

버튼 탭 시 실행할 액션

## Return Value 

수정된 카드 인스턴스

