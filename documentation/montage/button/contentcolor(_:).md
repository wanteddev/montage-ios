Instance Method

# contentColor(_:) 

버튼 콘텐츠(텍스트와 아이콘)의 색상을 설정합니다.

```swift
@MainActor
func contentColor(_ contentColor: SwiftUI.Color?) -> Button
```

## Parameters 

contentColor

설정할 색상

## Return Value 

수정된 버튼 인스턴스

## 사용 예시 

```swift
Button.outlined(text: "복사")
    .contentColor(.red)
```

