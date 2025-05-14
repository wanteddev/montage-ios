---
1title: custom(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# custom(_:) 

커스텀 버튼 뷰를 사용하는 버튼 정보를 생성합니다.

```swift
static func custom(_ custom: @escaping (() -> any View)) -> ActionArea.ButtonInfo
```

## Parameters 

custom

커스텀 버튼 뷰를 생성하는 클로저

## Return Value 

커스텀 뷰가 포함된 ButtonInfo 인스턴스

## Discussion 

> **Note**
>
> 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 fill(horizontal:vertical:) 모디파이어를 사용하세요.

