Instance Method

# chevron(_:) 

셀 우측에 화살표(chevron) 아이콘을 추가합니다.

```swift
@MainActor
func chevron(_ chevron: Bool = true) -> Cell
```

## Parameters 

chevron

화살표 표시 여부

## Return Value 

수정된 Cell 인스턴스

## Discussion 

주로 탭했을 때 다른 화면으로 이동하는 셀에 사용됩니다.

> **Note**
>
> 기본값은 false입니다.

