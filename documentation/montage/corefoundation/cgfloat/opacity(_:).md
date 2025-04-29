Type Method

# opacity(_:) 

Opacity 열거형 값에 해당하는 CGFloat 불투명도 값을 반환합니다.MontageCoreFoundation

```swift
static func opacity(_ opacityComponent: Opacity) -> CGFloat
```

## Parameters 

opacityComponent

사용할 불투명도 열거형 값

## Return Value 

지정된 불투명도에 해당하는 CGFloat 값 (0.0 ~ 1.0 범위)

## Discussion 

디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.

**사용 예시**:

```swift
let alpha = CGFloat.opacity(.p052) // 0.52
```

