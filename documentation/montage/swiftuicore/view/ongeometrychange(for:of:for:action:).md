Instance Method

# onGeometryChange(for:of:for:action:) 

View의 지오메트리 변경정보를 디바운스시켜서 받습니다.MontageSwiftUICore

```swift
@MainActor
func onGeometryChange<T>(
    for type: T.Type,
    of transform: @escaping (GeometryProxy) -> T,
    for dueTime: RunLoop.SchedulerTimeType.Stride,
    action: @escaping (_ newValue: T) -> Void
) -> some View where T : Equatable
```

## Parameters 

type

변환 타입

transform

지오메트리 변환

dueTime

디바운스 시간

action

변경 시 실행할 액션

## Return Value 

디바운스된 View

