---
1title: radio(checked:text:onselect:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# radio(checked:text:onSelect:) 

불리언 값을 이용해 라디오 버튼과 텍스트를 생성합니다.

```swift
@MainActor
static func radio(
    checked: Bool,
    text: String,
    onSelect: ((Bool) -> Void)? = nil
) -> Input
```

## Parameters 

checked

라디오 버튼의 초기 선택 상태

text

표시할 텍스트

onSelect

선택 상태 변경 시 호출되는 클로저

## Return Value 

구성된 입력 컴포넌트

