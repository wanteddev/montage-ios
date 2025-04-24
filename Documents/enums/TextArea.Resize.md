**ENUM**

# `TextArea.Resize`

```swift
public enum Resize
```

TextArea의 텍스트 영역 Resize 관한 열거형입니다.
- normal : 줄 수 제한이 없으며, 줄 수에 따라 영역이 늘어납니다.
- limit : 최대 8줄 노출되며 초과 영역은 Scrollable 합니다.
- fixed: 텍스트가 표시될 영역을 지정합니다. 초과 영역은 Scrollable 합니다.

## Cases
### `normal`

```swift
case normal
```

### `limit`

```swift
case limit
```

### `fixed(min:max:)`

```swift
case fixed(min: CGFloat, max: CGFloat)
```
