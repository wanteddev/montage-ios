---
1title: disable(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# disable(_:) 

셀의 비활성화 상태를 설정합니다.

```swift
@MainActor
func disable(_ disable: Bool = true) -> Cell
```

## Parameters 

disable

비활성화 여부

## Return Value 

수정된 Cell 인스턴스

## Discussion 

비활성화된 셀은 탭 이벤트를 받지 않으며, 시각적으로 흐리게 표시됩니다.

> **Note**
>
> 기본값은 false입니다.

