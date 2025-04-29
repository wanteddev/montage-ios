Structure

# Slider 

범위 값을 선택할 수 있는 슬라이더 컴포넌트입니다.

```swift
@MainActor
struct Slider
```

## Overview 

단일 또는 이중 슬라이더 노브를 사용하여 지정된 범위 내에서 값을 선택할 수 있습니다. 두 개의 노브를 사용하여 최소값과 최대값을 동시에 설정할 수 있으며, 각 노브에 레이블을 표시하고 값이 변경될 때 콜백을 받을 수 있습니다.

**사용 예시**:

```swift
// 기본 슬라이더 (0.0 ~ 1.0 범위)
Slider()

// 사용자 정의 범위 및 레이블 포맷이 있는 슬라이더
Slider(
    range: 0...100,
    labelFormat: { "\(Int($0))%" },
    onChanged: { low, high in
        print("범위: \(low) ~ \(high)")
    }
)
.label()
.heading()
```

> **Note**
>
> 슬라이더는 레이블 및 헤딩 옵션을 제공하며, 비활성화 상태를 지원합니다.

## Topics 

### Initializers 

- [init(range: ClosedRange<CGFloat>, labelFormat: ((CGFloat) -> String)?, onChanged: ((CGFloat, CGFloat) -> Void)?)](/documentation/montage/slider/init(range:labelformat:onchanged:).md)

  슬라이더를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/slider/body.md)

### Instance Methods 

- [func disable(Bool) -> Slider](/documentation/montage/slider/disable(_:).md)

  슬라이더의 활성화 상태를 설정합니다.

- [func heading(Bool) -> Slider](/documentation/montage/slider/heading(_:).md)

  슬라이더 상단에 제목을 표시할지 여부를 설정합니다.

- [func label(Bool) -> Slider](/documentation/montage/slider/label(_:).md)

  슬라이더 노브에 값 레이블을 표시할지 여부를 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

