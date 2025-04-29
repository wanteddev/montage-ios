Type Method

# montage(variant:weight:) 

Montage 디자인 시스템의 폰트를 생성합니다.MontageUIKit

```swift
static func montage(
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular
) -> UIFont
```

## Parameters 

variant

텍스트 변형

weight

폰트 두께

## Return Value 

생성된 UIFont 인스턴스. 폰트를 찾을 수 없는 경우 시스템 폰트로 대체

