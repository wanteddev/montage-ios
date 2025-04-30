**STRUCT**

# `ActionArea`

```swift
public struct ActionArea: View, KeyboardReadable
```

화면 하단에 사용자 액션 버튼을 표시하는 영역 컴포넌트입니다.

이 컴포넌트는 화면 하단에 위치하며 주요 액션 버튼과 보조 버튼을 표시합니다.
다양한 레이아웃 변형을 지원하고, 캡션 텍스트와 추가 콘텐츠를 포함할 수 있습니다.

## 사용 예시
```swift
// 기본 강조 버튼 영역
ActionArea(variant: .strong(
    main: .init(text: "확인", action: { confirmAction() }),
    sub: .init(text: "취소", action: { cancelAction() })
))

// 캡션이 있는 중립 버튼 영역
ActionArea(variant: .neutral(
    main: .init(text: "저장", action: { saveData() })
))
.caption("변경 사항을 저장하시겠습니까?")

// 추가 콘텐츠가 있는 취소 버튼 영역
ActionArea(variant: .cancel(
    main: .init(text: "닫기", action: { dismiss() })
))
.extra({ 
    Text("추가 정보")
        .montage(variant: .label2) 
})
```

- Note: 키보드가 표시될 때 자동으로 조정됩니다.

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

ActionArea 컴포넌트를 초기화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 버튼 영역의 변형 스타일과 버튼 구성 |

#### Returns

구성된 ActionArea 인스턴스



</details>

<details><summary markdown="span"><code>clearBackground(_:)</code></summary>

```swift
public func clearBackground(_ clearBackground: Bool = true) -> Self
```

배경을 투명하게 설정합니다.

이 수정자를 사용하면 그라데이션 배경이 숨겨지고 투명한 배경이 표시됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| clearBackground | 배경 투명 여부, 기본값은 `true` |

#### Returns

수정된 ActionArea 인스턴스



</details>

<details><summary markdown="span"><code>caption(_:)</code></summary>

```swift
public func caption(_ caption: String?) -> Self
```

버튼 위에 표시할 캡션 텍스트를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| caption | 표시할 캡션 텍스트 |

#### Returns

수정된 ActionArea 인스턴스



</details>

<details><summary markdown="span"><code>extra(_:divider:)</code></summary>

```swift
public func extra(_ content: (() -> any View)?, divider: Bool = true) -> Self
```

버튼 위에 표시할 추가 콘텐츠를 설정합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| content | 표시할 추가 콘텐츠를 생성하는 클로저 |
| divider | 추가 콘텐츠 위에 구분선 표시 여부, 기본값은 `true` |

#### Returns

수정된 ActionArea 인스턴스



</details>
