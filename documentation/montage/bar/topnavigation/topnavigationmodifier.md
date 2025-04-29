Structure

# Bar.TopNavigation.TopNavigationModifier 

컨텐츠 뷰에 TopNavigation을 적용하는 뷰 모디파이어입니다.

```swift
@MainActor
struct TopNavigationModifier
```

## Overview 

스크롤 감지 및 내비게이션 바 스타일링을 자동으로 처리합니다.

**사용 예시**:

```swift
contentView
    .modifier(
        Bar.TopNavigation.TopNavigationModifier(
            variant: .normal,
            title: "제목",
            leadingButton: .back { 
                // 뒤로가기 동작
            },
            trailingButtons: []
        )
    )
```

## Topics 

### Initializers 

- [init(variant: Variant, title: String, showIndicator: Bool, backgroundColorResolvable: ColorResolvable?, leadingButton: Resource.LeadingButton?, trailingButtons: [Resource.TrailingButton], actionAreaModel: ActionAreaModifier.Model?)](/documentation/montage/bar/topnavigation/topnavigationmodifier/init(variant:title:showindicator:backgroundcolorresolvable:leadingbutton:trailingbuttons:actionareamodel:).md)

  TopNavigationModifier를 초기화합니다.

### Instance Methods 

- [func body(content: Content) -> some View](/documentation/montage/bar/topnavigation/topnavigationmodifier/body(content:).md)

### Default Implementations 

- [API ReferenceViewModifier Implementations](/documentation/montage/bar/topnavigation/topnavigationmodifier/viewmodifier-implementations.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.ViewModifier

