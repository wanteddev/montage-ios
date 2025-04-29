Instance Method

# trailingContent(_:) 

셀 우측에 추가 콘텐츠를 표시합니다.

```swift
@MainActor
func trailingContent(_ contents: ((Bool) -> any View)? = nil) -> Cell
```

## Parameters 

contents

표시할 콘텐츠를 생성하는 클로저 (활성화 상태를 파라미터로 받음)

## Return Value 

수정된 Cell 인스턴스

## Discussion 

배지, 스위치, 토글 등 추가 UI 요소를 셀 타이틀 뒤에 배치할 수 있습니다. 클로저 파라미터를 통해 셀의 활성화 상태를 전달받을 수 있습니다.

