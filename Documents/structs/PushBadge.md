**STRUCT**

# `PushBadge`

```swift
public struct PushBadge: View
```

푸시 알림이나 알림 표시를 위한 뱃지 컴포넌트입니다.

작은 점, 'N' 표시, 또는 숫자를 표시할 수 있으며 다양한 크기와 위치를 지원합니다.
주로 아이콘이나 버튼 주변에 새로운 알림이나 메시지가 있음을 나타내기 위해 사용됩니다.

**사용 예시**:
```swift
// 기본 점 형태 뱃지
PushBadge(variant: .dot)

// 'N' 표시 뱃지
PushBadge(variant: .new)
    .size(.small)

// 숫자 표시 뱃지
PushBadge(variant: .number(5))
    .backgroundColor(.red)
```

- SeeAlso: `PushBadge.Modifier`, `PushBadge.Variant`, `PushBadge.Size`, `PushBadge.Position`

## Properties
<details><summary markdown="span"><code>body</code></summary>

```swift
public var body: some View
```

</details>

## Methods
<details><summary markdown="span"><code>init(variant:)</code></summary>

```swift
public init(variant: Variant)
```

PushBadge를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 뱃지의 표시 형태 (dot, new, number) |




</details>

<details><summary markdown="span"><code>size(_:)</code></summary>

```swift
public func size(_ size: Size) -> Self
```

뱃지의 크기를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| size | 뱃지 크기 |

#### Returns

크기가 변경된 PushBadge



</details>

<details><summary markdown="span"><code>fontColor(_:)</code></summary>

```swift
public func fontColor(_ color: SwiftUI.Color) -> Self
```

텍스트 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 텍스트 색상 |

#### Returns

텍스트 색상이 변경된 PushBadge



</details>

<details><summary markdown="span"><code>backgroundColor(_:)</code></summary>

```swift
public func backgroundColor(_ color: SwiftUI.Color) -> Self
```

배경 색상을 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 배경 색상 |

#### Returns

배경 색상이 변경된 PushBadge



</details>
