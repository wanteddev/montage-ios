---
1title: init(variant:icon:disable:showpushbadge:padding:iconcolor:backgroundcolor:bordercolor:handler:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Initializer

# init(variant:icon:disable:showPushBadge:padding:iconColor:backgroundColor:borderColor:handler:) 

아이콘 버튼을 생성합니다.

```swift
@MainActor
init(
    variant: IconButton.Variant = .default,
    icon: Icon,
    disable: Bool = false,
    showPushBadge: Bool = false,
    padding: CGFloat = .zero,
    iconColor: SwiftUI.Color? = nil,
    backgroundColor: SwiftUI.Color? = nil,
    borderColor: SwiftUI.Color? = nil,
    handler: (() -> Void)? = nil
)
```

## Parameters 

variant

버튼의 외관 스타일, 기본값은 .default

icon

표시할 아이콘

disable

비활성화 여부, 기본값은 false

showPushBadge

푸시 뱃지 표시 여부, 기본값은 false (normal 변형에서만 적용)

padding

추가 패딩, 기본값은 0 (outlined, solid 변형에서만 적용)

iconColor

아이콘 색상 커스터마이징, 기본값은 nil

backgroundColor

배경 색상 커스터마이징, 기본값은 nil (outlined, solid 변형에서만 적용)

borderColor

테두리 색상 커스터마이징, 기본값은 nil (outlined 변형에서만 적용)

handler

버튼 탭 시 실행할 핸들러

## Return Value 

구성된 아이콘 버튼 뷰

