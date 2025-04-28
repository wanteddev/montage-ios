**STRUCT**

# `Toast.Model`

```swift
public struct Model: Equatable
```

토스트 메시지의 데이터 모델을 정의하는 구조체입니다.

토스트에 표시할 메시지와 스타일을 설정할 수 있습니다.

**사용 예시**:
```swift
// 기본 토스트 모델
Toast.Model(message: "작업이 완료되었습니다.")

// 특정 상태의 토스트 모델
Toast.Model(.negative, message: "오류가 발생했습니다.")

// 아이콘이 있는 토스트 모델
Toast.Model(.normal(Icon.bell), message: "새 알림이 있습니다.")
```

## Methods
<details><summary markdown="span"><code>init(_:message:)</code></summary>

```swift
public init(
    _ variant: Toast.Variant = .normal(),
    message: String
)
```

Toast 모델을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 토스트 메시지의 스타일 (기본값: .normal()) |
| message | 토스트에 표시할 메시지 텍스트 |




</details>
