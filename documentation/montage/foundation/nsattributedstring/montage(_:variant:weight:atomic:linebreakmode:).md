Type Method

# montage(_:variant:weight:atomic:lineBreakMode:) 

Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.MontageFoundation

```swift
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    atomic: Color.Atomic,
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

atomic

원자적 색상

lineBreakMode

줄바꿈 모드 (기본값: .byWordWrapping)

## Return Value 

Montage 스타일이 적용된 NSAttributedString

