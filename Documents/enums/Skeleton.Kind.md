**ENUM**

# `Skeleton.Kind`

```swift
public enum Kind
```

## Cases
### `text(alignment:lengths:cornerRadius:lineNumber:)`

```swift
case text(
    alignment: Align = .leading,
    lengths: [Length] = [._100],
    cornerRadius: CGFloat = 3,
    lineNumber: Int = 1
)
```

### `rectangle(cornerRadius:)`

```swift
case rectangle(cornerRadius: CGFloat = 3)
```

### `circle`

```swift
case circle
```
