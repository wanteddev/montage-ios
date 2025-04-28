**STRUCT**

# `Slider`

```swift
public struct Slider: View
```

범위 값을 선택할 수 있는 슬라이더 컴포넌트입니다.

단일 또는 이중 슬라이더 노브를 사용하여 지정된 범위 내에서 값을 선택할 수 있습니다.
두 개의 노브를 사용하여 최소값과 최대값을 동시에 설정할 수 있으며, 
각 노브에 레이블을 표시하고 값이 변경될 때 콜백을 받을 수 있습니다.

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

- Note: 슬라이더는 레이블 및 헤딩 옵션을 제공하며, 비활성화 상태를 지원합니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(range:labelFormat:onChanged:)</code></summary>

```swift
public init(
    range: ClosedRange<CGFloat> = 0 ... 1,
    labelFormat: ((CGFloat) -> String)? = nil,
    onChanged: ((CGFloat, CGFloat) -> Void)? = nil
)
```

슬라이더를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| range | 슬라이더가 표현하는 값의 범위 (기본값: 0...1) |
| labelFormat | 슬라이더 노브에 표시될 레이블 형식을 지정하는 클로저 (기본값: 소수점 한 자리) |
| onChanged | 슬라이더 값이 변경될 때 호출되는 클로저 (기본값: nil) |




</details>

<details><summary markdown="span"><code>heading(_:)</code></summary>

```swift
public func heading(_ heading: Bool = true) -> Self
```

슬라이더 상단에 제목을 표시할지 여부를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| heading | 제목 표시 여부 (기본값: true) |

#### Returns

수정된 슬라이더 인스턴스



</details>

<details><summary markdown="span"><code>label(_:)</code></summary>

```swift
public func label(_ label: Bool = true) -> Self
```

슬라이더 노브에 값 레이블을 표시할지 여부를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| label | 레이블 표시 여부 (기본값: true) |

#### Returns

수정된 슬라이더 인스턴스



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

슬라이더의 활성화 상태를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부 (기본값: true - 비활성화) |

#### Returns

수정된 슬라이더 인스턴스



</details>
