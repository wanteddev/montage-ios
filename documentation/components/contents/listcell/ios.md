---
title: List cell
description: 텍스트와 콘텐츠를 포함하는 리스트 아이템 컴포넌트입니다.
---

```swift
@MainActor struct ListCell
```

## Overview

`ListCell`은 앱 내에서 리스트 형태로 정보를 표시할 때 사용되는 기본 컴포넌트입니다. 라벨, 부가 설명과 함께 네 종류의 콘텐츠 슬롯([leadingContent(_:)](/documentation/montage/listcell/leadingcontent(_:).md), [labelTrailingContent(_:)](/documentation/montage/listcell/labeltrailingcontent(_:).md), [trailingContent(_:)](/documentation/montage/listcell/trailingcontent(_:).md), [extraContent(_:)](/documentation/montage/listcell/extracontent(_:).md))을 제공하며 다양한 스타일로 커스터마이징할 수 있습니다.

```swift
// 기본 셀
ListCell(label: "기본 셀")

// 추가 설명이 있는 셀
ListCell(label: "설명이 있는 셀")
    .description("부가 설명 텍스트")

// 리딩 콘텐츠와 선택 상태의 셀
ListCell(label: "커스텀 셀", onTap: {
    print("셀이 탭되었습니다")
})
.leadingContent {
    Image.icon(.person)
        .frame(width: 24, height: 24)
}
.selected(true)
.chevron(true)
```

## 콘텐츠 슬롯

네 슬롯은 셀 안에서 각각 다음 위치를 차지하며, 슬롯마다 여러 요소를 나열할 수 있습니다.

- [leadingContent(_:)](/documentation/montage/listcell/leadingcontent(_:).md): 라벨 앞, 항목 간 간격 8
- [labelTrailingContent(_:)](/documentation/montage/listcell/labeltrailingcontent(_:).md): 라벨 바로 뒤, 항목 간 간격 4
- [trailingContent(_:)](/documentation/montage/listcell/trailingcontent(_:).md): 셀 오른쪽 끝, 항목 간 간격 8
- [extraContent(_:)](/documentation/montage/listcell/extracontent(_:).md): 설명 아래, 항목 간 간격 6

```swift
ListCell(label: "김티드")
    .description("iOS 개발자")
    .labelTrailingContent {
        ContentBadge(text: "신규")
    }
    .extraContent {
        ContentBadge(variant: .outlined, text: "서울")
    }
    .trailingContent { _ in
        Text("값")
    }
```

## Topics

### Initializers

<details>

<summary>``init(label: String, onTap: (() -> Void)?)``</summary>


셀 컴포넌트를 초기화합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `label` | 셀에 표시할 제목 텍스트 |
  | `onTap` | 셀을 탭했을 때 실행할 클로저, 생략하면 기본값으로 `nil` 적용 |
</details>

### Instance Properties

<details>

<summary>``var body: some View``</summary>


뷰의 내용과 동작을 정의합니다.
</details>

### Instance Methods

<details>

<summary>``func chevron(Bool) -> ListCell``</summary>


셀 우측에 화살표(chevron) 아이콘을 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `chevron` | 화살표 표시 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  주로 탭했을 때 다른 화면으로 이동하는 셀에 사용됩니다.
</details>
<details>

<summary>``func description(String?) -> ListCell``</summary>


셀에 부가 설명을 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `description` | 표시할 설명 텍스트, 생략하면 기본값으로 `nil` 적용 (nil 설정 시 설명 제거) |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  설명은 라벨 아래에 작은 글씨로 표시되는 부가 설명 텍스트입니다.
</details>
<details>

<summary>``func disable(Bool) -> ListCell``</summary>


셀의 비활성화 상태를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `disable` | 비활성화 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  비활성화된 셀은 탭 이벤트를 받지 않으며, 라벨·설명·콘텐츠 슬롯에 `foregroundDisablePrimary` 색상이 적용됩니다.
  >  **Note**
  >
  > 콘텐츠 슬롯에는 전경색으로 전달되므로, 슬롯 안에서 색상을 직접 지정한 뷰에는 적용되지 않습니다.

</details>
<details>

<summary>``func divider(Bool) -> ListCell``</summary>


셀 하단에 구분선을 추가합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `divider` | 구분선 표시 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
</details>
<details>

<summary>``func extraContent<V>(() -> V) -> ListCell``</summary>


설명 아래에 자유 콘텐츠를 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contents` | 표시할 콘텐츠를 생성하는 클로저 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  셀 폭을 모두 사용하는 자유 슬롯으로, 여러 요소를 나열하면 6포인트 간격으로 가로 배치됩니다.

  ```swift
  ListCell(label: "김티드")
      .description("iOS 개발자")
      .extraContent {
          ContentBadge(variant: .outlined, text: "서울")
          ContentBadge(variant: .outlined, text: "5년차")
      }
  ```

  >  **Note**
  >
  > 슬롯 내부 구성은 사용처가 정하며, 그 안의 타이포그래피와 색상은 컴포넌트가 보장하지 않습니다.

</details>
<details>

<summary>``func highlight(String) -> ListCell``</summary>


라벨의 특정 텍스트를 강조 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `text` | 강조할 텍스트 문자열 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  지정한 문자열과 일치하는 부분을 굵은 글씨(bold)로 강조 표시합니다. 대소문자를 구분하지 않으며, 첫 번째로 일치하는 부분만 강조됩니다.
</details>
<details>

<summary>``func interactionOutset(CGFloat) -> ListCell``</summary>


인터랙션 효과(hover·pressed 배경)가 셀 경계 바깥으로 확장되는 정도를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `outset` | 좌우로 확장할 크기 (포인트 단위), 생략하면 기본값으로 `12` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  메뉴처럼 좌우 여백이 있는 컨테이너 안에서는 기본값 `12`를 그대로 사용해 여백까지 배경을 넓히고, 셀이 화면 폭을 그대로 채우는 목록에서는 `0`을 지정합니다.
  >  **Note**
  >
  > 모서리 둥글기는 [interactionRadius(_:)](/documentation/montage/listcell/interactionradius(_:).md)로 따로 정하며 `outset`과 독립적으로 동작합니다.

  >  **Note**
  >
  > 4.0.0에서 제거된 `fillWidth(_:)`·`interactionPadding(_:)`을 대체합니다. `fillWidth(true)`는 `interactionOutset(0)`, `fillWidth(false)`는 `interactionOutset(12)`에 대응하며, `fillWidth(true)`가 적용하던 셀 좌우 20포인트 여백은 더 이상 자동으로 붙지 않으므로 필요하면 사용처에서 직접 지정합니다.

</details>
<details>

<summary>``func interactionRadius(CGFloat) -> ListCell``</summary>


인터랙션 효과 영역의 모서리 둥글기를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `radius` | 적용할 모서리 반경 (포인트 단위) |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  지정하지 않으면 [interactionOutset(_:)](/documentation/montage/listcell/interactionoutset(_:).md)이 `0`보다 클 때 `16`, 그 외에는 `0`이 적용됩니다.
</details>
<details>

<summary>``func labelColor(Color.Semantic) -> ListCell``</summary>


라벨 텍스트의 `color` 속성을 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `color` | 적용할 텍스트 색상 |
- **Return Value**

  수정된 ListCell 인스턴스
</details>
<details>

<summary>``func labelTrailingContent<V>(() -> V) -> ListCell``</summary>


라벨 행의 오른쪽 끝에 콘텐츠를 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contents` | 표시할 콘텐츠를 생성하는 클로저 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  배지나 인증 아이콘처럼 라벨에 딸린 요소를 배치할 때 사용합니다. 여러 요소를 나열하면 4포인트 간격으로 가로 배치되며, 높이가 22포인트로 고정되어 행 높이를 늘리지 않습니다.

  ```swift
  ListCell(label: "김티드")
      .labelTrailingContent {
          ContentBadge(text: "신규")
      }
  ```

  >  **Note**
  >
  > 라벨이 2줄 이상일 때 표시 위치는 [verticalAlign(_:)](/documentation/montage/listcell/verticalalign(_:).md)을 따릅니다.

</details>
<details>

<summary>``func labelVariant(Typography.Variant) -> ListCell``</summary>


라벨 텍스트의 `variant` 속성을 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `variant` | 적용할 Typography 변형 스타일 |
- **Return Value**

  수정된 ListCell 인스턴스
</details>
<details>

<summary>``func labelWeight(Typography.Weight) -> ListCell``</summary>


라벨 텍스트의 `weight` 속성을 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `weight` | 적용할 텍스트 두께 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**
  >  **Note**
  >
  > `selected`가 `true`인 셀은 이 값과 무관하게 `bold`로 표시됩니다.

</details>
<details>

<summary>``func leadingContent<V>(() -> V) -> ListCell``</summary>


셀 좌측에 추가 콘텐츠를 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contents` | 표시할 콘텐츠를 생성하는 클로저 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  아이콘, 체크박스, 아바타, 썸네일 등을 셀 라벨 앞에 배치할 수 있습니다. 여러 요소를 나열하면 8포인트 간격으로 가로 배치됩니다.

  ```swift
  ListCell(label: "김티드")
      .leadingContent {
          Checkbox(checked: isChecked)
          Avatar(image: profileImage)
      }
  ```

</details>
<details>

<summary>``func selected(Bool) -> ListCell``</summary>


셀을 선택된 상태로 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `selected` | 선택 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  선택된 셀은 라벨 텍스트의 색상이 `surfaceBrandPrimary`로 변경되고, 텍스트 두께가 bold로 설정되며, 셀 오른쪽 끝에 체크 아이콘이 표시됩니다.
  >  **Important**
  >
  > 체크 아이콘은 [trailingContent(_:)](/documentation/montage/listcell/trailingcontent(_:).md) 자리를 대신 차지하므로 둘을 함께 표시할 수 없습니다. 선택 상태와 별개의 우측 콘텐츠가 필요하면 [labelTrailingContent(_:)](/documentation/montage/listcell/labeltrailingcontent(_:).md) 또는 [extraContent(_:)](/documentation/montage/listcell/extracontent(_:).md)를 사용하세요.

</details>
<details>

<summary>``func textEllipsis(Bool) -> ListCell``</summary>


텍스트의 생략 처리 여부를 설정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `textEllipsis` | 텍스트 생략 처리 여부, 생략하면 기본값으로 `true` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  `true`로 설정하면 라벨과 설명이 각각 한 줄로 제한되고, 초과 텍스트는 말줄임 처리됩니다. `false`인 경우 두 텍스트 모두 줄 수 제한 없이 줄바꿈됩니다.
</details>
<details>

<summary>``func trailingContent<V>((Bool) -> V) -> ListCell``</summary>


셀 우측에 추가 콘텐츠를 표시합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `contents` | 표시할 콘텐츠를 생성하는 클로저 (선택된 상태를 파라미터로 받음) |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  값 텍스트, 배지, 버튼, 스위치 등 추가 UI 요소를 셀 오른쪽 끝에 배치할 수 있습니다. 여러 요소를 나열하면 8포인트 간격으로 가로 배치됩니다. 클로저 파라미터를 통해 셀의 선택된 상태를 전달받을 수 있습니다.
</details>
<details>

<summary>``func verticalAlign(VerticalAlign) -> ListCell``</summary>


셀 내 콘텐츠의 수직 정렬을 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `verticalAlignment` | 적용할 수직 정렬 방식, 생략하면 기본값으로 `.top` 적용 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  라벨이 2줄 이상일 때 leading·labelTrailing·trailing 콘텐츠를 첫 행에 맞출지, 셀 중앙에 맞출지 정합니다.
</details>
<details>

<summary>``func verticalPadding(VerticalPadding) -> ListCell``</summary>


상하 여백의 크기를 조정합니다.

- **Parameters**
  | Parameter | Description |
  | --- | --- |
  | `verticalPadding` | 적용할 상하 여백 크기 |
- **Return Value**

  수정된 ListCell 인스턴스
- **Discussion**

  정해진 네 단계(`none`·`small`·`medium`·`large`)로 표현할 수 없는 간격은 [ListCell.VerticalPadding.custom(_:)](/documentation/montage/listcell/verticalpadding/custom(_:).md)으로 직접 지정할 수 있습니다.
  >  **Note**
  >
  > 여백이 `0`인 셀은 인터랙션 효과를 표시하지 않습니다.

</details>

### Enumerations

<details>

<summary>``enum VerticalAlign``</summary>


셀 내 콘텐츠의 수직 정렬을 나타내는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case center``</summary>


셀 높이의 중앙에 정렬
</details>
<details>

<summary>``case top``</summary>


첫 행에 맞춰 정렬
</details>

</details>
<details>

<summary>``enum VerticalPadding``</summary>


상하 여백을 나타내는 열거형입니다.
- **Overview**

  셀 컴포넌트의 상하 여백을 조정할 때 사용되며, 각 케이스는 다양한 크기의 여백을 제공합니다.
#### Enumeration Cases

<details>

<summary>``case custom(CGFloat)``</summary>


직접 지정한 여백
- **Discussion**

  정해진 네 단계로 표현할 수 없는 간격이 필요할 때만 사용합니다.
</details>
<details>

<summary>``case large``</summary>


큰 여백 (16)
</details>
<details>

<summary>``case medium``</summary>


중간 여백 (12)
</details>
<details>

<summary>``case none``</summary>


여백 없음
</details>
<details>

<summary>``case small``</summary>


작은 여백 (8)
</details>

</details>

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



