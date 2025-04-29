Instance Method

# loading(_:) 

버튼을 로딩 상태로 설정합니다.

```swift
@MainActor
func loading(_ loading: Bool = true) -> Button
```

## Parameters 

loading

로딩 상태 여부, 기본값은 true

## Return Value 

수정된 버튼 인스턴스

## Discussion 

로딩 상태인 버튼은 내부 콘텐츠 대신 로딩 인디케이터를 표시하며 사용자 상호작용에 반응하지 않습니다. 비동기 작업이 진행 중일 때 사용자에게 피드백을 제공하는 데 유용합니다.

## 사용 예시 

```swift
Button.solid(text: "저장")
    .loading(isLoading)
```

