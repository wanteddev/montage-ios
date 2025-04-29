Initializer

# init(range:labelFormat:onChanged:) 

슬라이더를 초기화합니다.

```swift
@MainActor
init(
    range: ClosedRange<CGFloat> = 0 ... 1,
    labelFormat: ((CGFloat) -> String)? = nil,
    onChanged: ((CGFloat, CGFloat) -> Void)? = nil
)
```

## Parameters 

range

슬라이더가 표현하는 값의 범위 (기본값: 0…1)

labelFormat

슬라이더 노브에 표시될 레이블 형식을 지정하는 클로저 (기본값: 소수점 한 자리)

onChanged

슬라이더 값이 변경될 때 호출되는 클로저 (기본값: nil)

