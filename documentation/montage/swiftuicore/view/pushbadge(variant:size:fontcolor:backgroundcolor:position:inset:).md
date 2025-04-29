Instance Method

# pushBadge(variant:size:fontColor:backgroundColor:position:inset:) 

현재 뷰에 푸시 알림 뱃지를 표시합니다.MontageSwiftUICore

```swift
@MainActor
func pushBadge(
    variant: PushBadge.Variant = .dot,
    size: PushBadge.Size = .xsmall,
    fontColor: SwiftUI.Color = .semantic(.staticWhite),
    backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
    position: PushBadge.Position = .top(.trailing),
    inset: CGSize = .zero
) -> some View
```

## Parameters 

variant

뱃지의 표시 형태 (기본값: .dot)

size

뱃지 크기 (기본값: .xsmall)

fontColor

텍스트 색상 (기본값: staticWhite)

backgroundColor

배경 색상 (기본값: primaryNormal)

position

뱃지 위치 (기본값: .top(.trailing))

inset

위치 조정을 위한 여백 (기본값: .zero)

## Return Value 

뱃지가 적용된 뷰

## Discussion 

뷰의 특정 위치에 알림 또는 메시지 표시용 뱃지를 추가합니다.

**사용 예시**:

```swift
Button("메시지") { }
    .pushBadge(variant: .number(3), position: .top(.leading))

Image.montage(.bell)
    .pushBadge()  // 기본값: 우측 상단에 빨간 점
```

