**ENUM**

# `Select.Variant`

```swift
public enum Variant
```

다중 선택 가능여부를 나타내는 열거형입니다.

## Cases
### `single(selectionType:menuPrimaryButtonTitle:)`

```swift
case single(selectionType: SingleSelectionType = .radio, menuPrimaryButtonTitle: String? = nil)
```

### `multiple(render:overflow:menuPrimaryButtonTitle:)`

```swift
case multiple(render: Render = .text, overflow: Bool = false, menuPrimaryButtonTitle: String)
```
