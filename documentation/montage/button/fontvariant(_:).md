Instance Method

# fontVariant(_:) 

버튼 텍스트의 폰트 변형을 설정합니다.

```swift
@MainActor
func fontVariant(_ fontVariant: Typography.Variant?) -> Button
```

## Parameters 

fontVariant

설정할 폰트 변형

## Return Value 

수정된 버튼 인스턴스

## Discussion 

텍스트의 크기와 스타일을 변경할 때 사용합니다.

## 사용 예시 

```swift
Button.text(text: "중요 안내")
    .fontVariant(.heading)
```

> **See Also**
>
> Typography.Variant

