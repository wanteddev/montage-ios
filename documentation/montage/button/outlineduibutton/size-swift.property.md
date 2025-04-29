Instance Property

# size `Deprecated`

버튼의 사이즈입니다.

```swift
@MainActor
var size: Size { get set }
```

> **Deprecated**
>
> `Montage.Button.outlined()`를 사용하세요.

## Discussion 

기본값은 .large입니다.

> **Important**
>
> Variant이 Assistive일 경우 .large를 사용할 수 없습니다. size 설정 시 constraint가 정상적으로 반영됩니다.

