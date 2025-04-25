**STRUCT**

# `Control`

```swift
public struct Control: View
```

체크박스, 체크마크, 라디오 버튼과 같은 선택 컨트롤을 제공하는 컴포넌트입니다.

다양한 유형의 선택 컨트롤을 통일된 인터페이스로 제공합니다.
선택 상태 변경 시 콜백을 받을 수 있으며, 크기와 스타일을 조정할 수 있습니다.

**사용 예시**:
```swift
// 체크박스
Control.checkbox(checked: true) { isChecked in
    print("체크박스 선택 상태: \(isChecked)")
}

// 라디오 버튼
Control.radio(checked: false)
    .tight()
    .size(.small)

// 바인딩 사용
@State private var isChecked = false
Control.checkmark($isChecked)
```

- Note: 모든 컨트롤은 상태에 따라 적절한 시각적 피드백을 제공합니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>checkbox(state:size:onSelect:)</code></summary>

```swift
public static func checkbox(
    state: State, size: Size = .medium, onSelect: ((State) -> Void)? = nil
) -> Self
```

상태 값을 이용해 체크박스를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| state | 체크박스의 초기 상태 |
| size | 체크박스 크기 (기본값: .medium) |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 체크박스 컨트롤



</details>

<details><summary markdown="span"><code>checkbox(checked:size:onSelect:)</code></summary>

```swift
public static func checkbox(
    checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
) -> Self
```

불리언 값을 이용해 체크박스를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크박스의 초기 선택 상태 |
| size | 체크박스 크기 (기본값: .medium) |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 체크박스 컨트롤



</details>

<details><summary markdown="span"><code>checkmark(checked:size:onSelect:)</code></summary>

```swift
public static func checkmark(
    checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
) -> Self
```

불리언 값을 이용해 체크마크를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크마크의 초기 선택 상태 |
| size | 체크마크 크기 (기본값: .medium) |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 체크마크 컨트롤



</details>

<details><summary markdown="span"><code>radio(checked:size:onSelect:)</code></summary>

```swift
public static func radio(
    checked: Bool, size: Size = .medium, onSelect: ((Bool) -> Void)? = nil
) -> Self
```

불리언 값을 이용해 라디오 버튼을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 라디오 버튼의 초기 선택 상태 |
| size | 라디오 버튼 크기 (기본값: .medium) |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 라디오 버튼 컨트롤



</details>

<details><summary markdown="span"><code>checkbox(_:size:)</code></summary>

```swift
public static func checkbox(_ state: Binding<State>, size: Size = .medium) -> Self
```

상태 바인딩을 이용해 체크박스를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| state | 체크박스 상태와 연결된 바인딩 |
| size | 체크박스 크기 (기본값: .medium) |

#### Returns

구성된 체크박스 컨트롤



</details>

<details><summary markdown="span"><code>checkbox(_:size:)</code></summary>

```swift
public static func checkbox(_ checked: Binding<Bool>, size: Size = .medium) -> Self
```

불리언 바인딩을 이용해 체크박스를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크박스 선택 상태와 연결된 바인딩 |
| size | 체크박스 크기 (기본값: .medium) |

#### Returns

구성된 체크박스 컨트롤



</details>

<details><summary markdown="span"><code>checkmark(_:size:)</code></summary>

```swift
public static func checkmark(_ checked: Binding<Bool>, size: Size = .medium) -> Self
```

불리언 바인딩을 이용해 체크마크를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크마크 선택 상태와 연결된 바인딩 |
| size | 체크마크 크기 (기본값: .medium) |

#### Returns

구성된 체크마크 컨트롤



</details>

<details><summary markdown="span"><code>radio(_:size:)</code></summary>

```swift
public static func radio(_ checked: Binding<Bool>, size: Size = .medium) -> Self
```

불리언 바인딩을 이용해 라디오 버튼을 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 라디오 버튼 선택 상태와 연결된 바인딩 |
| size | 라디오 버튼 크기 (기본값: .medium) |

#### Returns

구성된 라디오 버튼 컨트롤



</details>

<details><summary markdown="span"><code>tight(_:)</code></summary>

```swift
public func tight(_ tight: Bool = true) -> Self
```

컨트롤을 더 조밀한 레이아웃으로 표시합니다.

이 수정자를 적용하면 컨트롤의 가로 너비가 줄어듭니다.
- medium: 24px → 20px
- small: 20px → 16px

#### Parameters

| Name | Description |
| ---- | ----------- |
| tight | 조밀한 레이아웃 적용 여부 (기본값: true) |

#### Returns

수정된 컨트롤 인스턴스



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ disable: Bool = true) -> Self
```

컨트롤을 비활성화합니다.

비활성화된 컨트롤은 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disable | 비활성화 여부 (기본값: true) |

#### Returns

수정된 컨트롤 인스턴스



</details>
