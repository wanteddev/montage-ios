**ENUM**

# `TextArea.Resource`

```swift
public enum Resource
```

텍스트 영역 하단에 표시할 수 있는 UI 요소를 정의합니다.

다양한 종류의 컴포넌트를 텍스트 영역 하단에 배치할 수 있습니다.
문자 수 카운터, 버튼, 아이콘, 칩, 뱃지 등을 지원합니다.

- Note: 문자 수 카운터는 좌/우측 중 하나에만 사용 가능합니다. 중복 사용 시 좌측이 우선 표시됩니다.

## Cases
### `characterCount(limit:overflow:)`

```swift
case characterCount(limit: Int? = nil, overflow: Bool = false)
```

문자 수 카운터
#### Parameters

| Name | Description |
| ---- | ----------- |
| limit | 최대 문자 수 제한 (nil인 경우 제한 없음) |
| overflow | 최대 문자 수 초과 허용 여부 |


### `textButton(placement:varaint:title:handler:)`

```swift
case textButton(
    placement: Placement = .leading,
    varaint: Button.Text.Variant? = .assistive,
    title: String,
    handler: (() -> Void)? = nil
)
```

텍스트 버튼
#### Parameters

| Name | Description |
| ---- | ----------- |
| placement | 버튼 위치 |
| varaint | 버튼 변형 스타일 |
| title | 버튼 텍스트 |
| handler | 버튼 클릭 핸들러 |


### `iconButton(placement:variant:icon:tintColor:handler:)`

```swift
case iconButton(
    placement: Placement = .leading,
    variant: IconButton.Variant? = .solid(size: .small),
    icon: Icon,
    tintColor: SwiftUI.Color = .semantic(.labelAlternative),
    handler: (() -> Void)? = nil
)
```

아이콘 버튼
#### Parameters

| Name | Description |
| ---- | ----------- |
| placement | 버튼 위치 |
| variant | 버튼 변형 스타일 |
| icon | 버튼 아이콘 |
| tintColor | 아이콘 색상 |
| handler | 버튼 클릭 핸들러 |


### `icon(_:tintColor:)`

```swift
case icon(
    Icon,
    tintColor: SwiftUI.Color = .semantic(.labelAssistive)
)
```

단순 아이콘
#### Parameters

| Name | Description |
| ---- | ----------- |
| icon | 표시할 아이콘 |
| tintColor | 아이콘 색상 |


### `actionChip(_:title:handler:)`

```swift
case actionChip(
    Chip.Action.Variant = .solid,
    title: String,
    handler: (() -> Void)? = nil
)
```

액션 칩
#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 칩 변형 스타일 |
| title | 칩 텍스트 |
| handler | 칩 클릭 핸들러 |


### `filterChip(_:title:handler:)`

```swift
case filterChip(
    Chip.Filter.Variant = .solid,
    title: String,
    handler: (() -> Void)? = nil
)
```

필터 칩
#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 칩 변형 스타일 |
| title | 칩 텍스트 |
| handler | 칩 클릭 핸들러 |


### `badge(_:title:)`

```swift
case badge(
    ContentBadge.Variant = .solid,
    title: String
)
```

뱃지
#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 뱃지 변형 스타일 |
| title | 뱃지 텍스트 |
