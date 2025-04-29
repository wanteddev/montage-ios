Structure

# ProgressTracker.Vertical.StepContent 

수직 진행 추적기의 각 단계에 표시되는 콘텐츠 컴포넌트입니다.

```swift
@MainActor
struct StepContent
```

## Overview 

각 단계의 라벨, 라벨 보조 뷰, 그리고 추가 콘텐츠를 포함할 수 있습니다.

**사용 예시**:

```swift
ProgressTracker.Vertical.StepContent(
    label: "배송 정보",
    labelAccessoryView: { Image(systemName: "info.circle") },
    contentView: { AddressInputView() }
)
```

> **Note**
>
> 콘텐츠 뷰를 통해 각 단계에 맞는 복잡한 UI를 표시할 수 있습니다.

## Topics 

### Initializers 

- [init(label: String, labelAccessoryView: (() -> any View)?, contentView: (() -> any View)?)](/documentation/montage/progresstracker/vertical/stepcontent/init(label:labelaccessoryview:contentview:).md)

  단계 콘텐츠를 초기화합니다.

### Instance Properties 

- [var body: some View](/documentation/montage/progresstracker/vertical/stepcontent/body.md)

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

