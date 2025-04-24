**STRUCT**

# `ActionArea.ButtonInfo`

```swift
public struct ButtonInfo
```

## Methods
<details><summary markdown="span"><code>init(text:action:)</code></summary>

```swift
public init(
    text: String,
    action: @escaping (() -> Void)
)
```

ActionArea/Bottom의 항목을 기본값으로 생성합니다.
- Parameters:
  - text: 기본 컴포넌트에 나타날 텍스트입니다.
  - action: 기본 컴포넌트 클릭시 동작할 내용입니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| text | 기본 컴포넌트에 나타날 텍스트입니다. |
| action | 기본 컴포넌트 클릭시 동작할 내용입니다. |

</details>

<details><summary markdown="span"><code>custom(_:)</code></summary>

```swift
public static func custom(
    _ custom: @escaping (() -> any View)
) -> Self
```

ActionArea/Bottom의 항목을 커스텀하여 생성합니다.
- Parameter custom: 커스텀 Montage/Button 컴포넌트입니다.
> 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 fill(horizontal:vertical:) 모디파이어를 사용하십시오.

#### Parameters

| Name | Description |
| ---- | ----------- |
| custom | 커스텀 Montage/Button 컴포넌트입니다. |

</details>