Instance Property

# iconOnly `Deprecated`

uniqueIcon 노출 여부입니다.

```swift
@MainActor
var iconOnly: Bool { get set }
```

> **Deprecated**
>
> `Montage.Button.solid()`를 사용하세요.

## Discussion 

true로 설정 시 text와 leadingIcon, trailingIcon은 표현되지 않고 uniqueIcon만 표시됩니다. 설정 시 constraint가 업데이트 됩니다.

