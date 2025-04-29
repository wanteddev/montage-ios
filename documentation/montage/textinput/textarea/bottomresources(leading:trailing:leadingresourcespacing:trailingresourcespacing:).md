Instance Method

# bottomResources(leading:trailing:leadingResourceSpacing:trailingResourceSpacing:) 

텍스트 영역 하단에 표시할 UI 요소를 설정합니다.

```swift
@MainActor
func bottomResources(
    leading leadingResources: [Resource] = [],
    trailing trailingResources: [Resource] = [],
    leadingResourceSpacing: CGFloat = 4,
    trailingResourceSpacing: CGFloat = 4
) -> TextInput.TextArea
```

## Parameters 

leadingResources

왼쪽에 표시할 UI 요소 배열 (최대 3개)

trailingResources

오른쪽에 표시할 UI 요소 배열 (최대 3개)

leadingResourceSpacing

왼쪽 요소 간의 간격

trailingResourceSpacing

오른쪽 요소 간의 간격

## Return Value 

수정된 텍스트 영역 인스턴스

