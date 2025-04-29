Instance Method

# fill(horizontal:vertical:) 

버튼이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.

```swift
@MainActor
func fill(
    horizontal fillHorizontal: Bool = false,
    vertical fillVertical: Bool = false
) -> Button
```

## Return Value 

수정된 버튼 인스턴스

## Discussion 

버튼의 크기를 조절하여 컨테이너 뷰의 공간을 효율적으로 활용할 때 사용합니다.

## 사용 예시 

```swift
// 부모 뷰의 가로 너비를 모두 채우는 버튼
Button.solid(text: "전체 확인")
    .fill(horizontal: true)

// 가로, 세로 모두 채우는 버튼
Button.outlined(text: "영역 전체 채우기")
    .fill(horizontal: true, vertical: true)
```

