Type Method

# montage(_:variant:weight:colorResolver:lineBreakMode:) 

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.MontageFoundation

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    colorResolver: ColorResolvable,
    lineBreakMode: NSLineBreakMode = .byWordWrapping
) -> NSAttributedString
```

## Parameters 

string

변환할 문자열

variant

타이포그래피 변형 (기본값: .body1)

weight

폰트 두께 (기본값: .regular)

colorResolver

색상 해석기

lineBreakMode

줄바꿈 모드 (기본값: .byWordWrapping)

## Return Value 

Montage 스타일이 적용된 NSAttributedString

