Instance Method

# menuActionArea(leadingContent:trailingContent:) 

메뉴 하단에 액션 버튼 영역을 추가합니다.

```swift
@MainActor
func menuActionArea(
    leadingContent: @escaping () -> any View,
    trailingContent: @escaping () -> any View
) -> Menu
```

## Parameters 

leadingContent

왼쪽에 표시할 콘텐츠를 반환하는 클로저

trailingContent

오른쪽에 표시할 콘텐츠를 반환하는 클로저

## Return Value 

액션 영역이 추가된 Menu

## Discussion 

왼쪽과 오른쪽에 버튼이나 다른 뷰를 배치할 수 있습니다.

**사용 예시**:

```swift
Menu(variant: .normal, items: $items)
    .menuActionArea(
        leadingContent: {
            Button.transparent(text: "취소")
        },
        trailingContent: {
            Button.filled(text: "확인")
        }
    )
```

