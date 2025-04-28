**STRUCT**

# `TextField.TrailingButton`

```swift
public struct TrailingButton
```

텍스트 필드의 오른쪽에 표시할 버튼의 속성을 정의합니다.

이 구조체를 사용하여 오른쪽에 표시될 버튼의 스타일, 텍스트, 동작을 정의할 수 있습니다.

## Methods
<details><summary markdown="span"><code>init(variant:title:handler:)</code></summary>

```swift
public init(
    variant: Button.Outlined.Variant,
    title: String,
    handler: (() -> Void)? = nil
)
```

트레일링 버튼을 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼의 변형 스타일 |
| title | 버튼에 표시할 텍스트 |
| handler | 버튼 클릭 시 실행할 핸들러 |

#### Returns

구성된 트레일링 버튼 인스턴스



</details>
