Initializer

# init(duration:heading:description:extraContents:action:) 

SnackBar 모델을 초기화합니다.

```swift
init(
    duration: Duration = .short,
    heading: String? = nil,
    description: String? = nil,
    extraContents: (() -> any View)? = nil,
    action: String
)
```

## Parameters 

duration

스낵바가 표시되는 시간

heading

스낵바의 제목 (선택 사항)

description

스낵바의 설명 텍스트 (선택 사항)

extraContents

스낵바에 표시할 추가 콘텐츠를 반환하는 클로저 (선택 사항)

action

스낵바의 액션 버튼에 표시할 텍스트

