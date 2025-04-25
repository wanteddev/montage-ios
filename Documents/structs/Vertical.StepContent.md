**STRUCT**

# `Vertical.StepContent`

```swift
public struct StepContent: View
```

수직 진행 추적기의 각 단계에 표시되는 콘텐츠 컴포넌트입니다.

각 단계의 라벨, 라벨 보조 뷰, 그리고 추가 콘텐츠를 포함할 수 있습니다.

**사용 예시**:
```swift
ProgressTracker.Vertical.StepContent(
    label: "배송 정보",
    labelAccessoryView: { Image(systemName: "info.circle") },
    contentView: { AddressInputView() }
)
```

- Note: 콘텐츠 뷰를 통해 각 단계에 맞는 복잡한 UI를 표시할 수 있습니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(label:labelAccessoryView:contentView:)</code></summary>

```swift
public init(
    label: String = "",
    labelAccessoryView: (() -> any View)? = nil,
    contentView: (() -> any View)? = nil
)
```

단계 콘텐츠를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| label | 단계의 제목 텍스트 |
| labelAccessoryView | 라벨 옆에 표시할 보조 뷰를 생성하는 클로저 |
| contentView | 라벨 아래에 표시할 추가 콘텐츠 뷰를 생성하는 클로저 |




</details>
