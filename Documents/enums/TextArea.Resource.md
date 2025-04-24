**ENUM**

# `TextArea.Resource`

```swift
public enum Resource
```

TextArea 하단 좌/우측에 사용할 수 있는 컴포넌트입니다.
> characterCount는 좌/우측 중 하나에만 사용 가능합니다. 중복된다면 좌측을 우선 표시합니다.

## Cases
### `characterCount(limit:overflow:)`

```swift
case characterCount(limit: Int? = nil, overflow: Bool = false)
```

### `textButton(placement:varaint:title:handler:)`

```swift
case textButton(
    placement: Placement = .leading,
    varaint: Button.Text.Variant? = .assistive,
    title: String,
    handler: (() -> Void)? = nil
)
```

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

### `icon(_:tintColor:)`

```swift
case icon(
    Icon,
    tintColor: SwiftUI.Color = .semantic(.labelAssistive)
)
```

### `actionChip(_:title:handler:)`

```swift
case actionChip(
    Chip.Action.Variant = .solid,
    title: String,
    handler: (() -> Void)? = nil
)
```

### `filterChip(_:title:handler:)`

```swift
case filterChip(
    Chip.Filter.Variant = .solid,
    title: String,
    handler: (() -> Void)? = nil
)
```

### `badge(_:title:)`

```swift
case badge(
    ContentBadge.Variant = .solid,
    title: String
)
```
