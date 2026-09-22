---
title: ModalNavigation
description: 모달 내에서 사용하는 내비게이션 바 컴포넌트입니다.
---

```swift
@MainActor struct ModalNavigation
```

## Overview

모달 상단에 제목, 뒤로가기 버튼, 추가 버튼 등을 포함하는 내비게이션 바를 제공합니다. 스크롤에 따라 배경 불투명도가 자동으로 조절되며 다양한 스타일을 지원합니다.

좌우에 놓는 요소는 [ModalNavigation.Resource.Leading](/documentation/montage/modalnavigation/resource/leading.md)·[ModalNavigation.Resource.Trailing](/documentation/montage/modalnavigation/resource/trailing.md) 프리셋에서 고릅니다. 오른쪽은 왼쪽부터 순서대로 배치하므로 닫기 버튼을 마지막에 둡니다.

```swift
ModalNavigation()
    .variant(.emphasized)
    .title("제목")
    .leading(.back(action: goBack))
    .trailings(
        .icon(.share, action: share),
        .close(action: dismiss)
    )
```

프리셋에 없는 구성은 `slot(_:)`으로 직접 그립니다.

```swift
ModalNavigation()
    .leading(.slot { Avatar(url: profileURL) })
```

## Topics

### Structures

<details>

<summary>``struct Variant``</summary>


내비게이션 바의 외관을 정의하는 구조체입니다.
#### Instance Properties

<details>

<summary>``var description: String``</summary>

</details>

#### Type Properties

<details>

<summary>``static let emphasized: ModalNavigation.Variant``</summary>


제목을 왼쪽에 두는 스타일. [Popup](/documentation/montage/popup.md)·[BottomSheet](/documentation/montage/bottomsheet.md)의 기본값입니다.
</details>
<details>

<summary>``static let floating: ModalNavigation.Variant``</summary>


플로팅 스타일 (그라디언트, Progressive Blur 적용)
</details>
<details>

<summary>``static let normal: ModalNavigation.Variant``</summary>


제목을 가운데 두는 스타일. 전체 화면 모달에서만 씁니다.
</details>

</details>

### Initializers

<details>

<summary>``init(scrollOffset: Binding<CGFloat>)``</summary>


내비게이션 바를 초기화합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `scrollOffset` | 스크롤 오프셋 바인딩, 생략하면 기본값으로 `.constant(0)` 적용 |

</details>

### Instance Properties

<details>

<summary>``var body: some View``</summary>


뷰의 내용과 동작을 정의합니다.
</details>

### Instance Methods

<details>

<summary>``func backgroundColor(SwiftUI.Color) -> ModalNavigation``</summary>


내비게이션 바의 배경색을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `backgroundColor` | 배경색 |

- **Return Value**

  수정된 내비게이션 바 뷰
</details>
<details>

<summary>``func fixedBackgroundOpacity(CGFloat) -> ModalNavigation``</summary>


내비게이션 바의 배경 불투명도를 고정값으로 설정합니다. 스크롤에 따른 자동 조절을 비활성화하고 항상 일정한 불투명도를 유지합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `fixedBackgroundOpacity` | 고정 배경 불투명도 (0에서 1 사이의 값) |

- **Return Value**

  수정된 내비게이션 바 뷰
</details>
<details>

<summary>``func iconButtonBackground(Bool) -> ModalNavigation``</summary>


아이콘 버튼에 원형 배경을 넣을지 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `hasBackground` | 원형 배경 사용 여부 |

- **Return Value**

  수정된 내비게이션 바 뷰
- **Discussion**

  상단에 이미지를 깔아 버튼이 묻히는 자리에 씁니다. `floating` variant에서만 동작하고, 텍스트 버튼에는 적용되지 않습니다.
</details>
<details>

<summary>``func leading(Resource.Leading?) -> ModalNavigation``</summary>


내비게이션 바 왼쪽에 놓을 요소를 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `leading` | 왼쪽에 놓을 [ModalNavigation.Resource.Leading](/documentation/montage/modalnavigation/resource/leading.md). `nil`이면 비워 둡니다 |

- **Return Value**

  수정된 내비게이션 바 뷰
</details>
<details>

<summary>``func needHandleArea(Bool) -> ModalNavigation``</summary>


바텀 시트의 핸들 영역 필요 여부를 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `needHandleArea` | 핸들 영역 필요 여부 |

- **Return Value**

  수정된 내비게이션 바 뷰
- **Discussion**
  > **Note**
  >
  > titleView(_:)와 함께 사용될 경우 이 메서드로 설정된 텍스트만 표시됩니다.

</details>
<details>

<summary>``func noMaterialBackground() -> ModalNavigation``</summary>


내비게이션 바의 배경에 머티리얼 효과를 적용하지 않습니다.
- **Return Value**

  수정된 내비게이션 바 뷰
</details>
<details>

<summary>``func scrollOffset(Binding<CGFloat>) -> ModalNavigation``</summary>


스크롤 오프셋을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `scrollOffset` | 스크롤 오프셋에 대한 바인딩 |

- **Return Value**

  수정된 내비게이션 바 뷰
</details>
<details>

<summary>``func title(String) -> ModalNavigation``</summary>


내비게이션 바의 타이틀을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `text` | 타이틀 |

- **Return Value**

  수정된 내비게이션 바 뷰
</details>
<details>

<summary>``func titleView<V>(() -> V) -> ModalNavigation``</summary>


내비게이션 바의 타이틀 영역을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `content` | 타이틀 영역에 표시될 콘텐츠 |

- **Return Value**

  수정된 내비게이션 바 뷰
- **Discussion**
  > **Note**
  >
  > Title(*:)와 함께 사용될 경우 title(*:) 메서드로 설정된 텍스트만 표시됩니다.

</details>
<details>

<summary>``func trailings(Resource.Trailing...) -> ModalNavigation``</summary>


내비게이션 바 오른쪽에 놓을 요소들을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `trailings` | 오른쪽에 놓을 [ModalNavigation.Resource.Trailing](/documentation/montage/modalnavigation/resource/trailing.md) 목록 (최대 3개까지 표시) |

- **Return Value**

  수정된 내비게이션 바 뷰
- **Discussion**

  배열 버전 [trailings(_:)](/documentation/montage/modalnavigation/trailings(_:)-38gw.md)에 대한 편의 오버로딩입니다.
</details>
<details>

<summary>``func trailings([Resource.Trailing]) -> ModalNavigation``</summary>


내비게이션 바 오른쪽에 놓을 요소들을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `trailings` | 오른쪽에 놓을 [ModalNavigation.Resource.Trailing](/documentation/montage/modalnavigation/resource/trailing.md) 목록 (최대 3개까지 표시) |

- **Return Value**

  수정된 내비게이션 바 뷰
- **Discussion**

  왼쪽부터 순서대로 배치하므로 닫기 버튼은 배열의 마지막에 둡니다.
</details>
<details>

<summary>``func variant(Variant) -> ModalNavigation``</summary>


내비게이션 바의 스타일을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `variant` | 내비게이션 바 스타일 |

- **Return Value**

  수정된 내비게이션 바 뷰
</details>

### Enumerations

<details>

<summary>``enum Resource``</summary>


내비게이션 바 좌우에 놓을 수 있는 요소의 프리셋입니다.
#### Enumerations

<details>

<summary>``enum Leading``</summary>


내비게이션 바 왼쪽에 놓는 요소입니다.
##### Enumeration Cases

<details>

<summary>``case back(action: () -> Void)``</summary>


뒤로 가기 버튼입니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `action` | 탭했을 때 실행할 동작 |

</details>
<details>

<summary>``case icon(Icon, action: () -> Void)``</summary>


아이콘을 직접 지정하는 아이콘 버튼입니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 |
  | `action` | 탭했을 때 실행할 동작 |

</details>
<details>

<summary>``case slotView(() -> AnyView)``</summary>


프리셋에 없는 구성을 직접 그릴 때 씁니다. [slot(_:)](/documentation/montage/modalnavigation/resource/leading/slot(_:).md)으로 만듭니다.
</details>
<details>

<summary>``case text(String, action: () -> Void)``</summary>


텍스트 버튼입니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `text` | 표시할 텍스트 |
  | `action` | 탭했을 때 실행할 동작 |

</details>

##### Type Methods

<details>

<summary>``static func slot<V>(() -> V) -> Leading``</summary>


프리셋에 없는 구성을 직접 그립니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `content` | 왼쪽에 놓을 콘텐츠 |

- **Return Value**

  해당 콘텐츠를 그리는 [ModalNavigation.Resource.Leading](/documentation/montage/modalnavigation/resource/leading.md)
</details>

</details>
<details>

<summary>``enum Trailing``</summary>


내비게이션 바 오른쪽에 놓는 요소입니다.
##### Enumeration Cases

<details>

<summary>``case close(action: () -> Void)``</summary>


모달을 닫는 버튼입니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `action` | 탭했을 때 실행할 동작 |

</details>
<details>

<summary>``case icon(Icon, action: () -> Void)``</summary>


아이콘을 직접 지정하는 아이콘 버튼입니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `icon` | 표시할 아이콘 |
  | `action` | 탭했을 때 실행할 동작 |

</details>
<details>

<summary>``case slotView(() -> AnyView)``</summary>


프리셋에 없는 구성을 직접 그릴 때 씁니다. [slot(_:)](/documentation/montage/modalnavigation/resource/trailing/slot(_:).md)으로 만듭니다.
</details>
<details>

<summary>``case text(String, action: () -> Void)``</summary>


텍스트 버튼입니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `text` | 표시할 텍스트 |
  | `action` | 탭했을 때 실행할 동작 |

</details>

##### Type Methods

<details>

<summary>``static func slot<V>(() -> V) -> Trailing``</summary>


프리셋에 없는 구성을 직접 그립니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `content` | 오른쪽에 놓을 콘텐츠 |

- **Return Value**

  해당 콘텐츠를 그리는 [ModalNavigation.Resource.Trailing](/documentation/montage/modalnavigation/resource/trailing.md)
</details>

</details>

</details>

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



