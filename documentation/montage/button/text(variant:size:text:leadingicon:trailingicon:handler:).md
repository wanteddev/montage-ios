Type Method

# text(variant:size:text:leadingIcon:trailingIcon:handler:) 

Text 스타일의 버튼을 생성합니다.

```swift
@MainActor
static func text(
    variant: Text.Variant = .primary,
    size: Text.Size = .medium,
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

버튼의 크기, 기본값은 .medium

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

텍스트만 있는 스타일의 버튼으로, 가벼운 액션이나 링크 형태의 액션에 적합합니다.

## 사용 예시 

```swift
Button.text(text: "더 보기", handler: { showMore() })
Button.text(variant: .assistive, text: "상세보기", trailingIcon: .chevronRight)
```

