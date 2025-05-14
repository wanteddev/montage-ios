---
1title: montage(_:variant:weight:colorresolver:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# montage(_:variant:weight:colorResolver:) 

Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.MontageUIKit

```swift
@MainActor
static func montage(
    _ string: String,
    variant: Typography.Variant = .body1,
    weight: Typography.Weight = .regular,
    colorResolver: ColorResolvable
) -> UILabel
```

## Parameters 

string

표시할 문자열

variant

텍스트 변형

weight

폰트 두께

colorResolver

색상 해석기

## Return Value 

생성된 UILabel 인스턴스

