Instance Method

# backgroundColor(_:) 

버튼 배경색을 설정합니다.

```swift
@MainActor
func backgroundColor(_ backgroundColor: SwiftUI.Color?) -> Button
```

## Parameters 

backgroundColor

설정할 배경색

## Return Value 

수정된 버튼 인스턴스

## Discussion 

Solid 스타일 버튼에 가장 효과적으로 적용됩니다.

## 사용 예시 

```swift
Button.solid(text: "특별 액션")
    .backgroundColor(.blue)
```

