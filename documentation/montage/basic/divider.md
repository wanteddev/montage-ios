Structure

# Basic.Divider 

구획을 나누기 위해 사용되는 구분선 컴포넌트입니다.

```swift
@MainActor
struct Divider
```

## Overview 

이 컴포넌트는 UI 요소 간의 시각적 구분을 제공하기 위해 사용됩니다. 수직 또는 수평 방향으로 배치할 수 있으며, 두 가지 두께 변형을 지원합니다.

## 사용 예시 

```swift
// 기본 수평 구분선
Basic.Divider(.horizontal)

// 두꺼운 수직 구분선
Basic.Divider(.vertical, variant: .thick)

// 스택 안에서 사용
VStack {
   Text("첫 번째 항목")
   Basic.Divider(.horizontal)
   Text("두 번째 항목")
}
```

## Topics 

### Initializers 

- [init(Axis, variant: Variant)](/documentation/montage/basic/divider/init(_:variant:).md)

  구분선 컴포넌트를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/basic/divider/body.md)

### Enumerations 

- [enum Variant](/documentation/montage/basic/divider/variant.md)

  구분선의 두께 변형을 정의합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

