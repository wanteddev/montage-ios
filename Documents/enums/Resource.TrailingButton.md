**ENUM**

# `Resource.TrailingButton`

```swift
public enum TrailingButton: Hashable
```

TopNavigation의 우측에 표시될 내용들의 열거형입니다.

## Cases
### `icon(_:disable:showPushBadge:action:)`

```swift
case icon(Icon, disable: Bool = false, showPushBadge: Bool = false, action: () -> Void)
```

icon 형태의 Action입니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| showPushBadge | PushBadge의 노출 여부를 결정합니다. 기본값은 false입니다. |
| action | icon 클릭시 동작할 action입니다. |


### `text(_:disable:action:)`

```swift
case text(String, disable: Bool = false, action: () -> Void)
```

text 형태의 Action입니다.
#### Parameters

| Name | Description |
| ---- | ----------- |
| action | text 클릭시 동작할 action입니다. |


## Methods
<details><summary markdown="span"><code>hash(into:)</code></summary>

```swift
public func hash(into hasher: inout Hasher)
```



</details>

<details><summary markdown="span"><code>==(_:_:)</code></summary>

```swift
public static func == (
    lhs: Bar.TopNavigation.Resource.TrailingButton,
    rhs: Bar.TopNavigation.Resource.TrailingButton
) -> Bool
```



</details>
