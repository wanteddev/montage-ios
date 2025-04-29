Instance Method

# tooltip(isPresented:position:message:showArrow:showCloseButton:buttonInfo:) 

현재 뷰에 툴팁을 표시하는 modifier를 적용합니다.MontageSwiftUICore

```swift
@MainActor
func tooltip(
    isPresented: Binding<Bool>,
    position: Tooltip.Position,
    message: String,
    showArrow: Bool = true,
    showCloseButton: Bool = false,
    buttonInfo: Tooltip.ButtonInfo? = nil
) -> some View
```

## Parameters 

isPresented

툴팁의 표시 여부를 제어하는 바인딩

position

툴팁이 표시될 위치 및 화살표 위치

message

툴팁에 표시될 메시지

showArrow

화살표 표시 여부 (기본값: true)

showCloseButton

닫기 버튼 표시 여부 (기본값: false)

buttonInfo

툴팁에 추가할 버튼 정보 (선택 사항)

## Return Value 

툴팁이 적용된 뷰

