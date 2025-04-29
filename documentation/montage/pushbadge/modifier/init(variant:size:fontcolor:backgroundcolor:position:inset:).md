Initializer

# init(variant:size:fontColor:backgroundColor:position:inset:) 

PushBadge 모디파이어를 초기화합니다.

```swift
@MainActor
init(
    variant: Variant = .dot,
    size: Size = .xsmall,
    fontColor: SwiftUI.Color = .semantic(.staticWhite),
    backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
    position: Position = .top(.trailing),
    inset: CGSize = .zero
)
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

