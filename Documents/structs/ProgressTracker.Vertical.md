**STRUCT**

# `ProgressTracker.Vertical`

```swift
public struct Vertical: View
```

수직 방향으로 단계별 진행 상태를 표시하는 컴포넌트입니다.

`Vertical`은 여러 단계로 구성된 프로세스의 진행 상태를 수직 레이아웃으로 표시합니다.
각 단계는 원형 아이콘과 수직선으로 연결되며, 완료된 단계는 체크 마크로 표시됩니다.
각 단계에 라벨과 추가 콘텐츠를 표시할 수 있어 풍부한 정보 제공이 가능합니다.

**사용 예시**:
```swift
@State private var currentStep = 2

ProgressTracker.Vertical(
    progress: $currentStep,
    stepContents: [
        ProgressTracker.Vertical.StepContent(label: "기본 정보"),
        ProgressTracker.Vertical.StepContent(
            label: "상세 정보",
            contentView: { Text("내용을 입력해주세요") }
        ),
        ProgressTracker.Vertical.StepContent(label: "완료")
    ]
)
```

- Note: 각 단계에는 라벨 외에도 추가 콘텐츠를 표시할 수 있어 복잡한 단계별 정보를 표현하는 데 적합합니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(progress:stepContents:)</code></summary>

```swift
public init(progress: Binding<Int>, stepContents: [StepContent])
```

수직 진행 추적기를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| progress | 현재 진행 중인 단계 (1부터 시작) |
| stepContents | 각 단계의 콘텐츠 배열 |




</details>
