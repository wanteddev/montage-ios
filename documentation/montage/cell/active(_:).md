---
1title: active(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# active(_:) 

셀을 활성화 상태로 설정합니다.

```swift
@MainActor
func active(_ active: Bool = true) -> Cell
```

## Parameters 

active

활성화 여부

## Return Value 

수정된 Cell 인스턴스

## Discussion 

활성화된 셀은 타이틀 텍스트의 색상이 primaryNormal로 변경되고, 텍스트 두께가 medium으로 설정됩니다. trailingContent 클로저의 파라미터로 활성화 상태 여부가 전달됩니다.

> **Note**
>
> 기본값은 false입니다.

