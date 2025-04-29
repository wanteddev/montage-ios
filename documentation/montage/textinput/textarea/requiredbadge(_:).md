Instance Method

# requiredBadge(_:) 

제목 옆에 필수 입력을 나타내는 뱃지를 표시할지 설정합니다.

```swift
@MainActor
func requiredBadge(_ requiredBadge: Bool = true) -> TextInput.TextArea
```

## Parameters 

requiredBadge

필수 입력 뱃지 표시 여부, 기본값은 true

## Return Value 

수정된 텍스트 영역 인스턴스

## Discussion 

> **Note**
>
> 제목이 설정되지 않은 경우 뱃지가 표시되지 않습니다.

