---
1title: radio(_:text:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# radio(_:text:) 

불리언 바인딩을 이용해 라디오 버튼과 텍스트를 생성합니다.

```swift
@MainActor
static func radio(
    _ checked: Binding<Bool>,
    text: String
) -> Input
```

## Parameters 

checked

라디오 버튼 선택 상태와 연결된 바인딩

text

표시할 텍스트

## Return Value 

구성된 입력 컴포넌트

