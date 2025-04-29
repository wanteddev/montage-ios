Instance Method

# printValue(_:_:) 

프리뷰에서 값이 변경될 때마다 콘솔에 출력합니다.MontageSwiftUICore

```swift
@MainActor
func printValue<V>(
    _ value: V,
    _ label: String = "Unknown"
) -> some View where V : Equatable
```

## Parameters 

value

출력할 값

label

출력할 레이블

## Return Value 

값이 출력된 View

