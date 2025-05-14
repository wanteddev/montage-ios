---
1title: disable(_:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Instance Method

# disable(_:) 

버튼을 비활성화 상태로 설정합니다.

```swift
@MainActor
func disable(_ disable: Bool = true) -> Button
```

## Parameters 

disable

비활성화 여부, 기본값은 true

## Return Value 

수정된 버튼 인스턴스

## Discussion 

비활성화된 버튼은 시각적으로 흐리게 표시되며 사용자 상호작용에 반응하지 않습니다.

## 사용 예시 

```swift
Button.solid(text: "저장")
    .disable(isFormInvalid)
```

