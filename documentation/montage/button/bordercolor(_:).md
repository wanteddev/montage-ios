---
1title: bordercolor(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# borderColor(_:) 

버튼 테두리 색상을 설정합니다.

```swift
@MainActor
func borderColor(_ borderColor: SwiftUI.Color?) -> Button
```

## Parameters 

borderColor

설정할 테두리 색상

## Return Value 

수정된 버튼 인스턴스

## Discussion 

Outlined 스타일 버튼에 가장 효과적으로 적용됩니다.

## 사용 예시 

```swift
Button.outlined(text: "경고")
    .borderColor(.red)
```

