Instance Method

# tooltip(isPresented:message:showCloseButton:buttonInfo:) 

iOS 16.4 이상에서 시스템 팝오버를 사용하는 툴팁 modifier를 적용합니다.MontageSwiftUICoreiOS 16.4+iPadOS 16.4+Mac Catalyst 16.4+

```swift
@MainActor
func tooltip(
    isPresented: Binding<Bool>,
    message: String,
    showCloseButton: Bool = false,
    buttonInfo: Tooltip.ButtonInfo? = nil
) -> some View
```

## Parameters 

isPresented

툴팁의 표시 여부를 제어하는 바인딩

message

툴팁에 표시될 메시지

showCloseButton

닫기 버튼 표시 여부 (기본값: false)

buttonInfo

툴팁에 추가할 버튼 정보 (선택 사항)

## Return Value 

툴팁이 적용된 뷰

