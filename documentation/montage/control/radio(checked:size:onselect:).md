---
1title: radio(checked:size:onselect:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# radio(checked:size:onSelect:) 

불리언 값을 이용해 라디오 버튼을 생성합니다.

```swift
@MainActor
static func radio(
    checked: Bool,
    size: Size = .medium,
    onSelect: ((Bool) -> Void)? = nil
) -> Control
```

## Parameters 

checked

라디오 버튼의 초기 선택 상태

size

라디오 버튼 크기 (기본값: .medium)

onSelect

선택 상태 변경 시 호출되는 클로저

## Return Value 

구성된 라디오 버튼 컨트롤

