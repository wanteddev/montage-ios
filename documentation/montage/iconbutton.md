---
1title: iconbutton
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# IconButton 

다양한 스타일의 아이콘 버튼을 제공하는 컴포넌트입니다.

```swift
@MainActor
struct IconButton
```

## Overview 

아이콘만 표시하는 간결한 버튼으로, 여러 변형과 스타일을 지원합니다:

- 기본형(normal): 배경 없이 아이콘만 표시
- 배경형(background): 반투명 배경을 가진 아이콘
- 외곽선형(outlined): 테두리로 둘러싸인 아이콘
- 솔리드형(solid): 배경색이 채워진 아이콘

```swift
IconButton(
    variant: .default,
    icon: .arrowLeft,
    handler: { print("뒤로 가기 버튼 탭됨") }
)
```

## Topics 

### Initializers 

- [init(variant: IconButton.Variant, icon: Icon, disable: Bool, showPushBadge: Bool, padding: CGFloat, iconColor: SwiftUI.Color?, backgroundColor: SwiftUI.Color?, borderColor: SwiftUI.Color?, handler: (() -> Void)?)](/documentation/montage/iconbutton/init(variant:icon:disable:showpushbadge:padding:iconcolor:backgroundcolor:bordercolor:handler:).md)

  아이콘 버튼을 생성합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/iconbutton/body.md)

### Enumerations 

- [enum Variant](/documentation/montage/iconbutton/variant.md)

  버튼의 외관을 결정하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

