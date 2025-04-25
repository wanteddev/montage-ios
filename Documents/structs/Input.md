**STRUCT**

# `Input`

```swift
public struct Input: View
```

텍스트와 함께 표시되는 선택 컨트롤 컴포넌트입니다.

체크박스, 체크마크, 라디오 버튼과 같은 컨트롤을 텍스트 레이블과 함께 표시합니다.
사용자가 텍스트를 클릭하여 컨트롤의 상태를 변경할 수 있습니다.

**사용 예시**:
```swift
// 체크박스와 텍스트
Input.checkbox(checked: true, text: "이용약관에 동의합니다") { isChecked in
    print("동의 상태: \(isChecked)")
}

// 라디오 버튼과 텍스트
Input.radio(checked: false, text: "옵션 1")
    .bold()
    .size(.small)

// 바인딩 사용
@State private var isChecked = false
Input.checkmark($isChecked, text: "완료됨")
```

- Note: 컨트롤과 텍스트는 수직 정렬되어 표시됩니다.

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>checkbox(state:text:onSelect:)</code></summary>

```swift
public static func checkbox(
    state: Control.State,
    text: String,
    onSelect: ((Control.State) -> Void)? = nil
) -> Self
```

상태 값을 이용해 체크박스와 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| state | 체크박스의 초기 상태 |
| text | 표시할 텍스트 |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>checkbox(checked:text:onSelect:)</code></summary>

```swift
public static func checkbox(
    checked: Bool,
    text: String,
    onSelect: ((Bool) -> Void)? = nil
) -> Self
```

불리언 값을 이용해 체크박스와 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크박스의 초기 선택 상태 |
| text | 표시할 텍스트 |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>checkmark(checked:text:onSelect:)</code></summary>

```swift
public static func checkmark(
    checked: Bool,
    text: String,
    onSelect: ((Bool) -> Void)? = nil
) -> Self
```

불리언 값을 이용해 체크마크와 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크마크의 초기 선택 상태 |
| text | 표시할 텍스트 |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>radio(checked:text:onSelect:)</code></summary>

```swift
public static func radio(checked: Bool, text: String, onSelect: ((Bool) -> Void)? = nil) -> Self
```

불리언 값을 이용해 라디오 버튼과 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 라디오 버튼의 초기 선택 상태 |
| text | 표시할 텍스트 |
| onSelect | 선택 상태 변경 시 호출되는 클로저 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>checkbox(_:text:)</code></summary>

```swift
public static func checkbox(_ state: Binding<Control.State>, text: String) -> Self
```

상태 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| state | 체크박스 상태와 연결된 바인딩 |
| text | 표시할 텍스트 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>checkbox(_:text:)</code></summary>

```swift
public static func checkbox(_ checked: Binding<Bool>, text: String) -> Self
```

불리언 바인딩을 이용해 체크박스와 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크박스 선택 상태와 연결된 바인딩 |
| text | 표시할 텍스트 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>checkmark(_:text:)</code></summary>

```swift
public static func checkmark(_ checked: Binding<Bool>, text: String) -> Self
```

불리언 바인딩을 이용해 체크마크와 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 체크마크 선택 상태와 연결된 바인딩 |
| text | 표시할 텍스트 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>radio(_:text:)</code></summary>

```swift
public static func radio(_ checked: Binding<Bool>, text: String) -> Self
```

불리언 바인딩을 이용해 라디오 버튼과 텍스트를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| checked | 라디오 버튼 선택 상태와 연결된 바인딩 |
| text | 표시할 텍스트 |

#### Returns

구성된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Control.Size) -> Self
```

컨트롤 사이즈를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 컨트롤 크기 (.medium 또는 .small) |

#### Returns

수정된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>disable(_:)</code></summary>

```swift
public func disable(_ isDisable: Bool = true) -> Self
```

컴포넌트를 비활성화합니다.

비활성화된 컴포넌트는 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isDisable | 비활성화 여부 (기본값: true) |

#### Returns

수정된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>title(_:weight:color:)</code></summary>

```swift
public func title(
    _ variant: Typography.Variant? = nil,
    weight: Typography.Weight? = nil,
    color: SwiftUI.Color? = nil
) -> Self
```

텍스트의 타이포그래피 속성을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 (.body2 또는 .label1) |
| weight | 텍스트 굵기 |
| color | 텍스트 색상 |

#### Returns

수정된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>bold(_:)</code></summary>

```swift
public func bold(_ isBold: Bool = true) -> Self
```

텍스트를 볼드체로 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isBold | 볼드 적용 여부 (기본값: true) |

#### Returns

수정된 입력 컴포넌트



</details>

<details><summary markdown="span"><code>tight(_:)</code></summary>

```swift
public func tight(_ tight: Bool = true) -> Self
```

컨트롤을 더 조밀한 레이아웃으로 표시합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| tight | 조밀한 레이아웃 적용 여부 (기본값: true) |

#### Returns

수정된 입력 컴포넌트



</details>
