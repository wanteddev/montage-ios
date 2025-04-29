Instance Method

# trailingContent(_:) 

그룹 아바타 오른쪽에 추가적인 콘텐츠를 표시합니다.

```swift
@MainActor
func trailingContent(_ trailingContent: @escaping () -> any View) -> Avatar.Group
```

## Parameters 

trailingContent

표시할 뷰를 생성하는 클로저

## Return Value 

수정된 그룹 아바타 인스턴스

## Discussion 

이 수정자를 사용하여 아바타 그룹 옆에 추가 정보(예: “+3” 같은 추가 멤버 수)를 표시할 수 있습니다.

