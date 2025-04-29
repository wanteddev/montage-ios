Instance Method

# headingContent(_:) 

헤더 타이틀 옆에 추가 콘텐츠를 표시합니다.

```swift
@MainActor
func headingContent(_ content: (() -> any View)? = nil) -> SectionHeader
```

## Parameters 

content

표시할 콘텐츠를 생성하는 클로저

## Return Value 

수정된 SectionHeader 인스턴스

## Discussion 

타이틀 텍스트 바로 옆(오른쪽)에 추가 콘텐츠나 뱃지를 표시할 때 사용합니다.

