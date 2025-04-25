**STRUCT**

# `SnackBar.Model`

```swift
public struct Model: Equatable
```

SnackBar의 데이터 모델을 정의하는 구조체입니다.

스낵바에 표시할 콘텐츠와 동작 방식을 설정할 수 있습니다.

**사용 예시**:
```swift
// 기본 스낵바 모델
SnackBar.Model(
    description: "저장되었습니다.",
    action: "확인"
)

// 모든 요소를 활용한 스낵바 모델
SnackBar.Model(
    duration: .long,
    heading: "알림",
    description: "새로운 메시지가 도착했습니다.",
    extraContents: {
        Image.montage(.bell)
            .resizable()
            .frame(width: 24, height: 24)
    },
    action: "보기"
)
```

## Methods
<details><summary markdown="span"><code>init(duration:heading:description:extraContents:action:)</code></summary>

```swift
public init(
    duration: Duration = .short,
    heading: String? = nil,
    description: String? = nil,
    extraContents: (() -> any View)? = nil,
    action: String
)
```

SnackBar 모델을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| duration | 스낵바가 표시되는 시간 |
| heading | 스낵바의 제목 (선택 사항) |
| description | 스낵바의 설명 텍스트 (선택 사항) |
| extraContents | 스낵바에 표시할 추가 콘텐츠를 반환하는 클로저 (선택 사항) |
| action | 스낵바의 액션 버튼에 표시할 텍스트 |




</details>

<details><summary markdown="span"><code>==(_:_:)</code></summary>

```swift
public static func == (lhs: Self, rhs: Self) -> Bool
```



</details>
