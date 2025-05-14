---
1title: actionarea
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# ActionArea 

화면 하단에 사용자 액션 버튼을 표시하는 영역 컴포넌트입니다.

```swift
@MainActor
struct ActionArea
```

## Overview 

이 컴포넌트는 화면 하단에 위치하며 주요 액션 버튼과 보조 버튼을 표시합니다. 다양한 레이아웃 변형을 지원하고, 캡션 텍스트와 추가 콘텐츠를 포함할 수 있습니다.

## 사용 예시 

```swift
// 기본 강조 버튼 영역
ActionArea(variant: .strong(
    main: .init(text: "확인", action: { confirmAction() }),
    sub: .init(text: "취소", action: { cancelAction() })
))

// 캡션이 있는 중립 버튼 영역
ActionArea(variant: .neutral(
    main: .init(text: "저장", action: { saveData() })
))
.caption("변경 사항을 저장하시겠습니까?")

// 추가 콘텐츠가 있는 취소 버튼 영역
ActionArea(variant: .cancel(
    main: .init(text: "닫기", action: { dismiss() })
))
.extra({ 
    Text("추가 정보")
        .montage(variant: .label2) 
})
```

> **Note**
>
> 키보드가 표시될 때 자동으로 조정됩니다.

## Topics 

### Structures 

- [struct ButtonInfo](/documentation/montage/actionarea/buttoninfo.md)

  ActionArea에 표시될 버튼 정보를 정의하는 구조체입니다.

### Initializers 

- [init(variant: Variant)](/documentation/montage/actionarea/init(variant:).md)

  ActionArea 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/actionarea/body.md)

### Instance Methods 

- [func caption(String?) -> ActionArea](/documentation/montage/actionarea/caption(_:).md)

  버튼 위에 표시할 캡션 텍스트를 설정합니다.

- [func clearBackground(Bool) -> ActionArea](/documentation/montage/actionarea/clearbackground(_:).md)

  배경을 투명하게 설정합니다.

- [func extra((() -> any View)?, divider: Bool) -> ActionArea](/documentation/montage/actionarea/extra(_:divider:).md)

  버튼 위에 표시할 추가 콘텐츠를 설정합니다.

### Enumerations 

- [enum Variant](/documentation/montage/actionarea/variant.md)

  ActionArea의 버튼 레이아웃 변형을 정의합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

