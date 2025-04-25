**STRUCT**

# `ActionArea.ButtonInfo`

```swift
public struct ButtonInfo
```

ActionArea에 표시될 버튼 정보를 정의하는 구조체입니다.

버튼의 텍스트, 액션, 커스텀 뷰 등을 지정할 수 있습니다.

## Methods
<details><summary markdown="span"><code>init(text:action:)</code></summary>

```swift
public init(
    text: String,
    action: @escaping (() -> Void)
)
```

기본 버튼 정보를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| text | 버튼에 표시할 텍스트 |
| action | 버튼 클릭 시 실행할 액션 |

#### Returns

구성된 ButtonInfo 인스턴스



</details>

<details><summary markdown="span"><code>custom(_:)</code></summary>

```swift
public static func custom(
    _ custom: @escaping (() -> any View)
) -> Self
```

커스텀 버튼 뷰를 사용하는 버튼 정보를 생성합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| custom | 커스텀 버튼 뷰를 생성하는 클로저 |
| Note | 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 fill(horizontal:vertical:) 모디파이어를 사용하세요. |

#### Returns

커스텀 뷰가 포함된 ButtonInfo 인스턴스



</details>
