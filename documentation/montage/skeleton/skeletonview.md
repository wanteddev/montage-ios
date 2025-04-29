Structure

# Skeleton.SkeletonView 

스켈레톤 로딩 UI를 표시하는 뷰입니다.

```swift
@MainActor
struct SkeletonView
```

## Overview 

지정된 형태(텍스트, 사각형, 원형)에 따라 적절한 스켈레톤 UI를 렌더링합니다. 색상, 투명도 등을 커스터마이징할 수 있습니다.

**사용 예시**:

```swift
Skeleton.SkeletonView(.text(lineNumber: 3))
    .color(.gray)
    .opacity(0.8)
```

## Topics 

### Initializers 

- [init(Kind)](/documentation/montage/skeleton/skeletonview/init(_:).md)

  스켈레톤 뷰를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/skeleton/skeletonview/body.md)

### Instance Methods 

- [func color(SwiftUI.Color) -> Skeleton.SkeletonView](/documentation/montage/skeleton/skeletonview/color(_:).md)

  스켈레톤 뷰의 색상을 설정합니다.

- [func opacity(CGFloat) -> Skeleton.SkeletonView](/documentation/montage/skeleton/skeletonview/opacity(_:).md)

  스켈레톤 뷰의 투명도를 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

