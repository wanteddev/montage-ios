---
1title: solid(variant:size:text:leadingicon:trailingicon:handler:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# solid(variant:size:text:leadingIcon:trailingIcon:handler:) 

Solid 스타일의 텍스트 버튼을 생성합니다.

```swift
@MainActor
static func solid(
    variant: Solid.Variant = .primary,
    size: Solid.Size = .large,
    text: String,
    leadingIcon: Icon? = nil,
    trailingIcon: Icon? = nil,
    handler: (() -> Void)? = nil
) -> Button
```

## Parameters 

variant

버튼의 변형, 기본값은 .primary

size

버튼의 크기, 기본값은 .large

text

버튼에 표시할 텍스트

leadingIcon

텍스트 앞에 표시할 아이콘

trailingIcon

텍스트 뒤에 표시할 아이콘

handler

버튼 탭 시 실행할 핸들러

## Return Value 

구성된 버튼 인스턴스

## Discussion 

배경색이 채워진 스타일의 버튼으로, 주요 액션이나 강조가 필요한 액션에 적합합니다.

## 사용 예시 

```swift
Button.solid(text: "로그인", handler: { loginUser() })
Button.solid(variant: .assistive, size: .small, text: "확인")
```

