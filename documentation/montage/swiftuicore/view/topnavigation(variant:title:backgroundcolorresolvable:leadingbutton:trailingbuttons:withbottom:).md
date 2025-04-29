Instance Method

# topNavigation(variant:title:backgroundColorResolvable:leadingButton:trailingButtons:withBottom:) 

현재 뷰에 TopNavigation 바를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func topNavigation(
    variant: Bar.TopNavigation.Variant = .normal,
    title: String,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Bar.TopNavigation.Resource.LeadingButton? = nil,
    trailingButtons: [Bar.TopNavigation.Resource.TrailingButton] = [],
    withBottom model: ActionAreaModifier.Model? = nil
) -> some View
```

## Parameters 

variant

내비게이션 바의 외관 스타일 (기본값: .normal)

title

표시할 제목

backgroundColorResolvable

배경색 리졸버 (기본값: nil)

leadingButton

좌측에 표시할 버튼 (기본값: nil)

trailingButtons

우측에 표시할 버튼 배열 (기본값: [])

model

하단 액션 영역에 대한 모델 (기본값: nil)

## Return Value 

TopNavigation이 적용된 뷰

