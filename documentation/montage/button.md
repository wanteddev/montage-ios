---
1title: button
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Structure

# Button 

사용자가 상호작용할 수 있는 버튼 컴포넌트입니다.

```swift
@MainActor
struct Button
```

## Overview 

세 가지 스타일로 제공됩니다:

- solid: 색상이 채워진 버튼
- outlined: 테두리만 있는 버튼
- text: 텍스트만 있는 버튼

## 사용 예시 

```swift
// 기본 솔리드 버튼
Button.solid(text: "확인", handler: { print("버튼 클릭") })

// 아웃라인 버튼
Button.outlined(variant: .primary, size: .medium, text: "취소")

// 텍스트 버튼
Button.text(text: "더보기", trailingIcon: .chevronRight)

// 아이콘 버튼
Button.solid(icon: .bell, handler: { print("알림 보기") })

// 로딩 상태 설정
Button.solid(text: "저장")
    .loading(true)
```

> **Note**
>
> 버튼은 다양한 수정자(modifier)를 사용하여 모양과 동작을 커스터마이즈할 수 있습니다.

> **See Also**
>
> Typography, Color

## Topics 

### Classes 

- [~~class OutlinedUIButton~~](/documentation/montage/button/outlineduibutton.md)

  외곽선으로 둘러 싸인 곡선 모서리 버튼입니다.

  `Deprecated`

- [~~class SolidUIButton~~](/documentation/montage/button/soliduibutton.md)

  배경으로 둘러 싸인 곡선 모서리 버튼입니다.

  `Deprecated`

### Instance Properties 

- [var body: some View](/documentation/montage/button/body.md)

### Instance Methods 

- [func backgroundColor(SwiftUI.Color?) -> Button](/documentation/montage/button/backgroundcolor(_:).md)

  버튼 배경색을 설정합니다.

- [func borderColor(SwiftUI.Color?) -> Button](/documentation/montage/button/bordercolor(_:).md)

  버튼 테두리 색상을 설정합니다.

- [func contentColor(SwiftUI.Color?) -> Button](/documentation/montage/button/contentcolor(_:).md)

  버튼 콘텐츠(텍스트와 아이콘)의 색상을 설정합니다.

- [func disable(Bool) -> Button](/documentation/montage/button/disable(_:).md)

  버튼을 비활성화 상태로 설정합니다.

- [func fill(horizontal: Bool, vertical: Bool) -> Button](/documentation/montage/button/fill(horizontal:vertical:).md)

  버튼이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.

- [func fontVariant(Typography.Variant?) -> Button](/documentation/montage/button/fontvariant(_:).md)

  버튼 텍스트의 폰트 변형을 설정합니다.

- [func fontWeight(Typography.Weight?) -> Button](/documentation/montage/button/fontweight(_:).md)

  버튼 텍스트의 폰트 두께를 설정합니다.

- [func loading(Bool) -> Button](/documentation/montage/button/loading(_:).md)

  버튼을 로딩 상태로 설정합니다.

### Type Methods 

- [static func outlined(variant: Outlined.Variant, size: Outlined.Size, icon: Icon, handler: (() -> Void)?) -> Button](/documentation/montage/button/outlined(variant:size:icon:handler:).md)

  Outlined 스타일의 아이콘 버튼을 생성합니다.

- [static func outlined(variant: Outlined.Variant, size: Outlined.Size, text: String, leadingIcon: Icon?, trailingIcon: Icon?, handler: (() -> Void)?) -> Button](/documentation/montage/button/outlined(variant:size:text:leadingicon:trailingicon:handler:).md)

  Outlined 스타일의 텍스트 버튼을 생성합니다.

- [static func solid(variant: Solid.Variant, size: Solid.Size, icon: Icon, handler: (() -> Void)?) -> Button](/documentation/montage/button/solid(variant:size:icon:handler:).md)

  Solid 스타일의 아이콘 버튼을 생성합니다.

- [static func solid(variant: Solid.Variant, size: Solid.Size, text: String, leadingIcon: Icon?, trailingIcon: Icon?, handler: (() -> Void)?) -> Button](/documentation/montage/button/solid(variant:size:text:leadingicon:trailingicon:handler:).md)

  Solid 스타일의 텍스트 버튼을 생성합니다.

- [static func text(variant: Text.Variant, size: Text.Size, text: String, leadingIcon: Icon?, trailingIcon: Icon?, handler: (() -> Void)?) -> Button](/documentation/montage/button/text(variant:size:text:leadingicon:trailingicon:handler:).md)

  Text 스타일의 버튼을 생성합니다.

### Enumerations 

- [enum Outlined](/documentation/montage/button/outlined.md)

  Outlined 스타일 버튼과 관련된 타입을 정의합니다.

- [enum Size](/documentation/montage/button/size.md)

  버튼의 크기를 정의합니다.

- [enum Solid](/documentation/montage/button/solid.md)

  Solid 스타일 버튼과 관련된 타입을 정의합니다.

- [enum Text](/documentation/montage/button/text.md)

  Text 스타일 버튼과 관련된 타입을 정의합니다.

- [enum Variant](/documentation/montage/button/variant.md)

  버튼의 변형을 정의합니다.

### Default Implementations 

- [View Implementations](/documentation/montage/swiftuicore/view.md)

- [View Implementations](/documentation/montage/swiftuicore/view.md)

## Relationships 

### Conforms To 

- Swift.Sendable
- SwiftUICore.View

