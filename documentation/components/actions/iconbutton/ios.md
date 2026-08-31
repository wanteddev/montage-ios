---
title: Icon button
description: 다양한 스타일의 아이콘 버튼을 제공하는 컴포넌트입니다.
---

```swift
@MainActor struct IconButton
```

## Overview

아이콘만 표시하는 간결한 버튼으로, 여러 변형과 스타일을 지원합니다:

- 기본형(normal): 배경 없이 아이콘만 표시
- 배경형(background): 반투명 배경을 가진 아이콘
- 외곽선형(outlined): 테두리로 둘러싸인 아이콘
- 솔리드형(solid): 배경색이 채워진 아이콘

모든 variant의 컨테이너(터치 영역 포함)는 24~64pt 사이에서 커스텀 사이즈로 지정할 수 있습니다.

```swift
IconButton(
    icon: .arrowLeft,
    handler: { print("뒤로 가기 버튼 탭됨") }
)

// 비활성화
IconButton(icon: .bell)
    .disabled(true)

// 인터랙션 레이어 대신 아이콘을 흐리게 해서 press 피드백
IconButton(icon: .search)
    .interactionEffect(.dim)
```

> **Note**
>
> 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다. 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.

## Topics

### Initializers

<details>

<summary>``init(variant: IconButton.Variant, icon: Icon, handler: (() -> Void)?)``</summary>


아이콘 버튼을 생성합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `variant` | 버튼의 외관 스타일, 생략하면 기본값으로 `.normal(size: .xlarge)` 적용 |
  | `icon` | 표시할 아이콘 |
  | `handler` | 버튼 탭 시 실행할 핸들러 |

</details>

### Instance Properties

<details>

<summary>``var body: some View``</summary>


뷰의 내용과 동작을 정의합니다.
</details>

### Instance Methods

<details>

<summary>``func backgroundColor(SwiftUI.Color) -> IconButton``</summary>


배경 색상을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 색상 |

- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  > **Note**
  >
  > Outlined, solid variant에서만 사용 가능합니다.

</details>
<details>

<summary>``func borderColor(SwiftUI.Color) -> IconButton``</summary>


테두리 색상을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 색상 |

- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  > **Note**
  >
  > Outlined 에서만 사용 가능합니다.

</details>
<details>

<summary>``func iconColor(SwiftUI.Color) -> IconButton``</summary>


아이콘 색상을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `color` | 설정할 색상 |

- **Return Value**

  수정된 IconButton 인스턴스
</details>
<details>

<summary>``func interactionColor(Color.Semantic) -> IconButton``</summary>


press 피드백에 사용할 색상을 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `color` | 인터랙션 색상(semantic 토큰) |

- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**

  `interactionEffect(_:)` 값에 따라 적용 대상이 다릅니다. 두 경우 모두 이 색에 상태별 불투명도를 적용합니다.
  - `.highlight`: 아이콘 뒤 인터랙션 레이어에 적용됩니다. 지정하지 않으면 `.foregroundNeutralPrimary`
  - `.dim`: 아이콘 색에 적용됩니다. 지정하지 않으면 평상시 아이콘 색을 그대로 씁니다
  - `.none`: 피드백이 없어 적용되지 않습니다

</details>
<details>

<summary>``func interactionEffect(IconButton.InteractionEffect) -> IconButton``</summary>


press 피드백을 어떤 방식으로 줄지 설정합니다(기본값: `.highlight`).

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `effect` | 인터랙션 피드백 방식 |

- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**

  세 값 모두 터치 영역은 같습니다. 레이어는 시각만 감추고 히트 영역은 그대로 유지합니다. 피드백 색상은 `.highlight`·`.dim` 모두 `interactionColor(_:)`로 바꿀 수 있습니다.
  > **Note**
  >
  > `.dim`은 `normal` variant에서만 동작합니다. 다른 variant에 넘기면 `.highlight`로 처리됩니다.

</details>
<details>

<summary>``func padding(CGFloat) -> IconButton``</summary>


버튼의 추가 패딩을 설정합니다(컨테이너 외곽을 그만큼 확장).

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `value` | 패딩 값 |

- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  > **Note**
  >
  > Outlined, solid variant에서만 사용 가능합니다.

</details>
<details>

<summary>``func showPushBadge(Bool) -> IconButton``</summary>


푸시 뱃지 표시 여부를 설정합니다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `value` | 푸시 뱃지 표시 여부 |

- **Return Value**

  수정된 IconButton 인스턴스
- **Discussion**
  > **Note**
  >
  > Normal variant에서만 사용 가능합니다.

</details>

### Enumerations

<details>

<summary>``enum InteractionEffect``</summary>


press 피드백 방식을 결정하는 열거형입니다.
- **Overview**

  어떤 값을 쓰든 터치 영역은 같습니다. 피드백의 시각 표현만 달라집니다.
#### Enumeration Cases

<details>

<summary>``case dim``</summary>


레이어 대신 아이콘의 불투명도를 낮춰(22%) 피드백합니다. 레이어 형태가 어색한 자리(TopNavigation 등)에 씁니다.
- **Discussion**
  > **Note**
  >
  > `normal` variant에서만 동작합니다. 기준 색은 평상시 아이콘 색이며, `interactionColor(_:)`로 따로 지정할 수 있습니다.

</details>
<details>

<summary>``case highlight``</summary>


아이콘 뒤에 인터랙션 레이어를 깝니다. 기본값이며 3.x까지의 동작입니다.
</details>
<details>

<summary>``case none``</summary>


피드백이 없습니다. 탭 핸들러는 그대로 동작합니다.
</details>

</details>
<details>

<summary>``enum NormalSize``</summary>


Normal variant의 아이콘 사이즈를 결정하는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case custom(size: Int)``</summary>


사용자 지정 크기. 컨테이너는 `[24, 64]` 범위로 클램프된다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `size` | 컨테이너 한 변의 크기(포인트) |

</details>
<details>

<summary>``case large``</summary>


큰 크기 (컨테이너 32pt / 아이콘 20pt / radius 10)
</details>
<details>

<summary>``case medium``</summary>


중간 크기 (컨테이너 28pt / 아이콘 18pt / radius 8)
</details>
<details>

<summary>``case small``</summary>


작은 크기 (컨테이너 24pt / 아이콘 16pt / radius 8)
</details>
<details>

<summary>``case xlarge``</summary>


가장 큰 크기 (컨테이너 36pt / 아이콘 24pt / radius 10)
</details>

</details>
<details>

<summary>``enum Size``</summary>


버튼 사이즈를 결정하는 열거형입니다.
#### Enumeration Cases

<details>

<summary>``case custom(size: Int)``</summary>


사용자 지정 크기. 컨테이너는 `[24, 64]` 범위로 클램프된다.

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `size` | 컨테이너 한 변의 크기(포인트) |

</details>
<details>

<summary>``case medium``</summary>


중간 크기 (컨테이너 40pt / 아이콘 18pt / 원형)
</details>
<details>

<summary>``case small``</summary>


작은 크기 (컨테이너 32pt / 아이콘 16pt / 원형)
</details>

</details>
<details>

<summary>``enum Variant``</summary>


버튼의 외관을 결정하는 열거형입니다.
- **Overview**

  아이콘 버튼의 다양한 스타일과 크기를 정의합니다.
#### Enumeration Cases

<details>

<summary>``case background(size: Int, isAlternative: Bool)``</summary>


배경형 아이콘 버튼 - 반투명 배경을 가진 원형 아이콘

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `size` | 컨테이너 한 변의 크기(포인트). 생략하면 기본값 `32`(컨테이너 32 / 아이콘 20). `[24, 64]` 범위로 클램프되며, `32`가 아닌 값은 커스텀 사이즈 규칙으로 계산된다. |
  | `isAlternative` | 대체 스타일 사용 여부, 생략하면 기본값으로 `false` 적용 |

</details>
<details>

<summary>``case normal(size: NormalSize)``</summary>


기본형 아이콘 버튼 - 배경 없이 아이콘만 표시

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (`NormalSize`) |

</details>
<details>

<summary>``case outlined(size: Size)``</summary>


외곽선형 아이콘 버튼 - 테두리로 둘러싸인 아이콘

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (`Size`) |

</details>
<details>

<summary>``case solid(size: Size)``</summary>


솔리드형 아이콘 버튼 - 배경색이 채워진 아이콘

- **Parameters**

  | Parameter | Description |
  | --- | --- |
  | `size` | 아이콘 크기 (`Size`) |

</details>

</details>

## Relationships

Conforms To

`Swift.Sendable`

`SwiftUICore.View`



