---
1title: fontweight(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# fontWeight(_:) 

버튼 텍스트의 폰트 두께를 설정합니다.

```swift
@MainActor
func fontWeight(_ fontWeight: Typography.Weight?) -> Button
```

## Parameters 

fontWeight

설정할 폰트 두께

## Return Value 

수정된 버튼 인스턴스

## Discussion 

텍스트의 강조를 조절할 때 사용합니다.

## 사용 예시 

```swift
Button.text(text: "중요 공지")
    .fontWeight(.bold)
```

> **See Also**
>
> Typography.Weight

