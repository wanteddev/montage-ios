---
1title: scrollview
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# ScrollView 

스크롤 상태 추적과 오프셋 감지가 가능한 커스텀 스크롤 뷰입니다.

```swift
@MainActor
struct ScrollView
```

## Overview 

기본 SwiftUI 스크롤 뷰를 확장하여 스크롤 상태 추적, 오프셋 감지, 새로고침 등 추가 기능을 제공합니다.

**사용 예시**:

```swift
@State private var scrollStatus = ScrollView.ScrollStatus()

ScrollView(scrollStatus: $scrollStatus, 
            onOffsetChanged: { offset in
              print("스크롤 오프셋: \(offset)")
            }) {
    VStack(spacing: 16) {
        ForEach(0..<20) { index in
            Text("항목 \(index)")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    .padding()
}
.axis(.vertical)
.hidesIndicators()
.onRefresh {
    // 새로고침 작업 수행
    try? await Task.sleep(nanoseconds: 2_000_000_000)
}
```

> **See Also**
>
> ScrollView.ScrollStatus

## Topics 

### Structures 

- [struct ScrollStatus](/documentation/montage/scrollview/scrollstatus.md)

  스크롤 뷰의 상태를 추적하는 구조체입니다.

### Initializers 

- [init(scrollStatus: Binding<ScrollStatus>?, onOffsetChanged: (CGPoint) -> Void, content: () -> any View)](/documentation/montage/scrollview/init(scrollstatus:onoffsetchanged:content:).md)

  스크롤 뷰를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/scrollview/body.md)

### Instance Methods 

- [func axis(Axis) -> ScrollView](/documentation/montage/scrollview/axis(_:).md)

  스크롤 방향을 설정합니다.

- [func hidesIndicators(Bool) -> ScrollView](/documentation/montage/scrollview/hidesindicators(_:).md)

  스크롤 인디케이터 표시 여부를 설정합니다.

- [func onRefresh(() async -> Void) -> ScrollView](/documentation/montage/scrollview/onrefresh(_:).md)

  당겨서 새로고침 동작을 설정합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

