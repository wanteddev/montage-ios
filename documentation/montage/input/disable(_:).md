---
1title: disable(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# disable(_:) 

컴포넌트를 비활성화합니다.

```swift
@MainActor
func disable(_ isDisable: Bool = true) -> Input
```

## Parameters 

isDisable

비활성화 여부 (기본값: true)

## Return Value 

수정된 입력 컴포넌트

## Discussion 

비활성화된 컴포넌트는 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.

