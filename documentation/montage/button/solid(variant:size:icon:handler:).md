---
1title: solid(variant:size:icon:handler:)
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Type Method

# solid(variant:size:icon:handler:) 

Solid 스타일의 아이콘 버튼을 생성합니다.

```swift
@MainActor
static func solid(
    variant: Solid.Variant = .primary,
    size: Solid.Size = .large,
    icon: Icon,
    handler: (() -> Void)? = nil
) -> Button
```

## Parameters 

variant

버튼의 변형, 기본값은 .primary

size

버튼의 크기, 기본값은 .large

icon

버튼에 표시할 아이콘

handler

버튼 탭 시 실행할 핸들러

## Return Value 

구성된 버튼 인스턴스

## Discussion 

배경색이 채워진 스타일의 아이콘 버튼으로, 공간이 제한적이거나 아이콘으로 충분히 의미가 전달될 때 사용합니다.

## 사용 예시 

```swift
Button.solid(icon: .plus, handler: { addItem() })
Button.solid(variant: .assistive, size: .small, icon: .search)
```

