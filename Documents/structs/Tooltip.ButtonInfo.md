**STRUCT**

# `Tooltip.ButtonInfo`

```swift
public struct ButtonInfo
```

툴팁에 표시되는 버튼의 정보를 정의하는 구조체입니다.

툴팁 내용 아래에 표시되는 버튼의 제목과 동작을 정의합니다.

**사용 예시**:
```swift
Tooltip.ButtonInfo(
    title: "더 알아보기",
    action: {
        // 상세 정보 페이지로 이동
    }
)
```

## Properties
<details><summary markdown="span"><code>title</code></summary>

```swift
public let title: String
```

</details>

<details><summary markdown="span"><code>action</code></summary>

```swift
public let action: () -> Void
```

</details>

## Methods
<details><summary markdown="span"><code>init(title:action:)</code></summary>

```swift
public init(title: String, action: @escaping () -> Void)
```

ButtonInfo를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| title | 버튼에 표시될 텍스트 |
| action | 버튼 클릭 시 실행될 동작 |




</details>
