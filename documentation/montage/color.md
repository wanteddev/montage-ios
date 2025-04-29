Enumeration

# Color 

디자인 시스템에서 미리 정의된 컬러 네임스페이스

```swift
enum Color
```

## Overview 

Color는 모든 Montage 컴포넌트에서 일관된 색상을 사용할 수 있도록 설계된 색상 체계를 제공합니다. Atomic과 Semantic으로 구분된 두 가지 색상 타입을 지원합니다.

**사용 예시**:

```swift
// Atomic 색상 사용
let atomicColor = Color.Atomic.blue50
let uiColor = UIColor.atomic(.blue50)
let swiftUIColor = SwiftUI.Color.atomic(.blue50)

// Semantic 색상 사용
let semanticColor = Color.Semantic.primaryNormal
let uiColor = UIColor.semantic(.primaryNormal)
let swiftUIColor = SwiftUI.Color.semantic(.primaryNormal)
```

> **Note**
>
> 디자인 시스템 UI 구성요소를 개발할 때는 직접 Atomic 색상을 사용하기보다 Semantic 색상을 사용하는 것이 권장됩니다. 이는 다크 모드와 같은 다양한 환경에서 일관된 디자인을 유지하는 데 도움이 됩니다.

> **See Also**
>
> Color.Atomic, Color.Semantic

## Topics 

### Enumerations 

- [enum Atomic](/documentation/montage/color/atomic.md)

  디자인 시스템에서 정의된 Atomic 컬러 팔레트

- [enum Semantic](/documentation/montage/color/semantic.md)

