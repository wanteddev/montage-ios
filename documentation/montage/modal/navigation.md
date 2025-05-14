---
1title: navigation
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Modal.Navigation 

모달 내에서 사용하는 내비게이션 바 컴포넌트입니다.

```swift
@MainActor
struct Navigation
```

## Overview 

모달 상단에 제목, 뒤로가기 버튼, 추가 버튼 등을 포함하는 내비게이션 바를 제공합니다. 스크롤에 따라 배경 불투명도가 자동으로 조절되며 다양한 스타일을 지원합니다.

**사용 예시**:

```swift
Modal.Navigation(title: "제목")
    .variant(.normal)
    .leadingButton(.back {
        // 뒤로가기 동작
    })
    .trailingButtons([
        .icon(.close, action: {
            // 닫기 동작
        })
    ])
```

> **See Also**
>
> Modal.Navigation.Variant, Bar.TopNavigation

## Topics 

### Initializers 

- [init(title: String, scrollOffset: Binding<CGFloat>)](/documentation/montage/modal/navigation/init(title:scrolloffset:).md)

  내비게이션 바를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/modal/navigation/body.md)

### Instance Methods 

- [func backgroundColor(SwiftUI.Color) -> Modal.Navigation](/documentation/montage/modal/navigation/backgroundcolor(_:).md)

  내비게이션 바의 배경색을 설정합니다.

- [func leadingButton(Bar.TopNavigation.Resource.LeadingButton?) -> Modal.Navigation](/documentation/montage/modal/navigation/leadingbutton(_:).md)

  내비게이션 바의 왼쪽 버튼을 설정합니다.

- [func needHandleArea(Bool) -> Modal.Navigation](/documentation/montage/modal/navigation/needhandlearea(_:).md)

  바텀 시트의 핸들 영역 필요 여부를 설정합니다.

- [func scrollOffset(Binding<CGFloat>) -> Modal.Navigation](/documentation/montage/modal/navigation/scrolloffset(_:).md)

  스크롤 오프셋을 설정합니다.

- [func trailingButtons([Bar.TopNavigation.Resource.TrailingButton]) -> Modal.Navigation](/documentation/montage/modal/navigation/trailingbuttons(_:).md)

  내비게이션 바의 오른쪽 버튼들을 설정합니다.

- [func variant(Variant) -> Modal.Navigation](/documentation/montage/modal/navigation/variant(_:).md)

  내비게이션 바의 스타일을 설정합니다.

### Enumerations 

- [enum Variant](/documentation/montage/modal/navigation/variant.md)

  내비게이션 바의 외관을 정의하는 열거형입니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

