Initializer

# init(_:size:onChange:) 

스위치 컴포넌트를 초기화합니다.

```swift
@MainActor
init(
    _ isOn: Binding<Bool>,
    size: Size = .small,
    onChange: @escaping (Bool) -> Void = { _ in }
)
```

## Parameters 

isOn

스위치의 켜짐/꺼짐 상태 바인딩

size

스위치 크기 (기본값: .small)

onChange

상태 변경 시 호출되는 클로저 (기본값: 빈 클로저)

