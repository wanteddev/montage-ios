**EXTENSION**

# `View`
```swift
public extension View
```

## Methods
<details><summary markdown="span"><code>elevation(_:)</code></summary>

```swift
func elevation(_ elevation: Elevation) -> Self
```

Montage 디자인 시스템의 그림자 효과를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| elevation | 적용할 그림자 효과 |

#### Returns

그림자 효과가 적용된 View



</details>

<details><summary markdown="span"><code>paragraph(variant:)</code></summary>

```swift
func paragraph(variant: Typography.Variant) -> some View
```

Montage 디자인 시스템의 단락 스타일을 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 텍스트 변형 |

#### Returns

단락 스타일이 적용된 View



</details>

<details><summary markdown="span"><code>actionArea(model:)</code></summary>

```swift
public func actionArea(model: ActionAreaModifier.Model) -> some View
```

현재 뷰에 하단 ActionArea를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| model | ActionArea의 구성 모델 |

#### Returns

ActionArea가 적용된 뷰

**사용 예시**:
```swift
contentView
    .actionArea(model: .init(
        variant: .strong(
            main: .init(text: "확인", action: { confirmAction() }),
            sub: .init(text: "취소", action: { cancelAction() })
        ),
        caption: "변경 사항을 저장하시겠습니까?"
    ))
```



</details>

<details><summary markdown="span"><code>loading(_:type:dimmedColor:)</code></summary>

```swift
public func loading(
    _ isLoading: Binding<Bool>,
    type: Loading.Kind,
    dimmedColor: SwiftUI.Color = .clear
) -> some View
```

현재 뷰에 로딩 인디케이터와 함께 로딩 오버레이를 적용합니다.

로딩 상태일 때 뷰 위에 반투명 배경과 로딩 애니메이션을 표시합니다.
로딩 중에는 사용자 상호작용이 비활성화됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isLoading | 로딩 상태를 제어하는 바인딩 불리언 값 |
| type | 로딩 애니메이션 종류 (.wanted 또는 .circular) |
| dimmedColor | 오버레이 배경색 (기본값: 투명) |

#### Returns

로딩 기능이 적용된 뷰

**사용 예시**:
```swift
@State private var isLoading = false

contentView
    .loading($isLoading, type: .wanted)
    .onAppear {
        // 로딩 상태 시작
        isLoading = true
    }
```



</details>

<details><summary markdown="span"><code>pullToRefresh(scrollYOffset:refresh:)</code></summary>

```swift
public func pullToRefresh(
    scrollYOffset: Binding<CGFloat>,
    refresh: @escaping () async -> Void
) -> some View
```

스크롤 뷰에 풀-투-리프레시(Pull-to-Refresh) 기능을 추가합니다.

사용자가 스크롤 뷰를 아래로 당기면 애니메이션과 함께 리프레시 기능을 제공합니다.
iOS 18 이상에서 사용 가능하며, 로딩 애니메이션과 함께 당김 정도에 따른 시각적 피드백을 제공합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| scrollYOffset | 스크롤 뷰의 Y축 오프셋 바인딩. 당김 정도를 감지하는 데 사용됩니다. |
| refresh | 리프레시가 트리거될 때 실행될 비동기 클로저입니다. |

#### Returns

풀-투-리프레시 기능이, 추가된 뷰

**사용 예시**:
```swift
@State private var scrollYOffset: CGFloat = 0

ScrollView {
    content
}
.scrollable(.vertical, contentOffset: $contentOffset)
.onChange(of: contentOffset) { newValue in
    scrollYOffset = newValue.y
}
.pullToRefresh(scrollYOffset: $scrollYOffset) {
    await loadData()
}
```



</details>

<details><summary markdown="span"><code>skeleton(isPresented:skeletonView:)</code></summary>

```swift
public func skeleton(
    isPresented: Bool,
    @ViewBuilder skeletonView: @escaping () -> any View
) -> some View
```

현재 뷰에 커스텀 스켈레톤 로딩 UI를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 스켈레톤 표시 여부를 제어하는 불리언 값 |
| skeletonView | 커스텀 스켈레톤 뷰를 생성하는 클로저 |

#### Returns

스켈레톤 기능이 적용된 뷰



</details>

<details><summary markdown="span"><code>skeleton(isPresented:kind:color:opacity:size:)</code></summary>

```swift
public func skeleton(
    isPresented: Bool,
    kind: Skeleton.Kind,
    color: SwiftUI.Color? = nil,
    opacity: CGFloat? = nil,
    size: CGSize? = nil
) -> some View
```

현재 뷰에 미리 정의된 스켈레톤 로딩 UI를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 스켈레톤 표시 여부를 제어하는 불리언 값 |
| kind | 스켈레톤 종류 (텍스트, 사각형, 원형 등) |
| color | 스켈레톤 색상 (기본값: 시스템 색상) |
| opacity | 스켈레톤 투명도 (기본값: 1.0) |
| size | 스켈레톤 크기 (지정하지 않으면 원본 뷰 크기를 사용) |

#### Returns

스켈레톤 기능이 적용된 뷰



</details>

<details><summary markdown="span"><code>topNavigation(variant:title:backgroundColorResolvable:leadingButton:trailingButtons:withBottom:)</code></summary>

```swift
public func topNavigation(
    variant: Bar.TopNavigation.Variant = .normal,
    title: String,
    backgroundColorResolvable: ColorResolvable? = nil,
    leadingButton: Bar.TopNavigation.Resource.LeadingButton? = nil,
    trailingButtons: [Bar.TopNavigation.Resource.TrailingButton] = [],
    withBottom model: ActionAreaModifier.Model? = nil
) -> some View
```

현재 뷰에 TopNavigation 바를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 내비게이션 바의 외관 스타일 (기본값: .normal) |
| title | 표시할 제목 |
| backgroundColorResolvable | 배경색 리졸버 (기본값: nil) |
| leadingButton | 좌측에 표시할 버튼 (기본값: nil) |
| trailingButtons | 우측에 표시할 버튼 배열 (기본값: []) |
| model | 하단 액션 영역에 대한 모델 (기본값: nil) |

#### Returns

TopNavigation이 적용된 뷰



</details>

<details><summary markdown="span"><code>pushBadge(variant:size:fontColor:backgroundColor:position:inset:)</code></summary>

```swift
public func pushBadge(
    variant: PushBadge.Variant = .dot,
    size: PushBadge.Size = .xsmall,
    fontColor: SwiftUI.Color = .semantic(.staticWhite),
    backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
    position: PushBadge.Position = .top(.trailing),
    inset: CGSize = .zero
) -> some View
```

현재 뷰에 푸시 알림 뱃지를 표시합니다.

뷰의 특정 위치에 알림 또는 메시지 표시용 뱃지를 추가합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| variant | 뱃지의 표시 형태 (기본값: .dot) |
| size | 뱃지 크기 (기본값: .xsmall) |
| fontColor | 텍스트 색상 (기본값: staticWhite) |
| backgroundColor | 배경 색상 (기본값: primaryNormal) |
| position | 뱃지 위치 (기본값: .top(.trailing)) |
| inset | 위치 조정을 위한 여백 (기본값: .zero) |

#### Returns

뱃지가 적용된 뷰

**사용 예시**:
```swift
Button("메시지") { }
    .pushBadge(variant: .number(3), position: .top(.leading))

Image.montage(.bell)
    .pushBadge()  // 기본값: 우측 상단에 빨간 점
```



</details>

<details><summary markdown="span"><code>snackBar(_:handler:)</code></summary>

```swift
public func snackBar(_ model: Binding<SnackBar.Model?>, handler: @escaping () -> Void) -> some View
```

현재 뷰에 SnackBar를 표시하는 modifier를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| model | SnackBar 모델을 바인딩합니다. nil이 아닌 값이 설정되면 SnackBar가 표시됩니다. |
| handler | SnackBar의 액션 버튼이 클릭되었을 때 실행될 클로저 |

#### Returns

SnackBar가 적용된 뷰

**사용 예시**:
```swift
@State private var snackBarModel: SnackBar.Model?

var body: some View {
    VStack {
        Button("Show SnackBar") {
            snackBarModel = SnackBar.Model(
                description: "작업이 완료되었습니다",
                action: "확인"
            )
        }
    }
    .snackBar($snackBarModel) {
        // 액션 버튼 클릭 시 실행될 코드
    }
}
```



</details>

<details><summary markdown="span"><code>toast(_:location:duration:)</code></summary>

```swift
public func toast(
    _ model: Binding<Toast.Model?>,
    location: Toast.Location = .bottom(offset: 0),
    duration: Toast.Duration = .short
) -> some View
```

현재 뷰에 Toast 메시지를 표시하는 modifier를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| model | Toast 모델을 바인딩합니다. nil이 아닌 값이 설정되면 Toast가 표시됩니다. |
| location | Toast가 표시될 위치 (기본값: .bottom) |
| duration | Toast가 표시될 시간 (기본값: .short) |

#### Returns

Toast가 적용된 뷰

**사용 예시**:
```swift
@State private var toastModel: Toast.Model?

var body: some View {
    VStack {
        Button("Show Toast") {
            toastModel = Toast.Model(message: "작업이 완료되었습니다")
        }
    }
    .toast($toastModel)
}
```



</details>

<details><summary markdown="span"><code>tooltip(isPresented:position:message:showArrow:showCloseButton:buttonInfo:)</code></summary>

```swift
public func tooltip(
    isPresented: Binding<Bool>,
    position: Tooltip.Position,
    message: String,
    showArrow: Bool = true,
    showCloseButton: Bool = false,
    buttonInfo: Tooltip.ButtonInfo? = nil
) -> some View
```

현재 뷰에 툴팁을 표시하는 modifier를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 툴팁의 표시 여부를 제어하는 바인딩 |
| position | 툴팁이 표시될 위치 및 화살표 위치 |
| message | 툴팁에 표시될 메시지 |
| showArrow | 화살표 표시 여부 (기본값: true) |
| showCloseButton | 닫기 버튼 표시 여부 (기본값: false) |
| buttonInfo | 툴팁에 추가할 버튼 정보 (선택 사항) |

#### Returns

툴팁이 적용된 뷰



</details>

<details><summary markdown="span"><code>tooltip(isPresented:message:showCloseButton:buttonInfo:)</code></summary>

```swift
public func tooltip(
    isPresented: Binding<Bool>,
    message: String,
    showCloseButton: Bool = false,
    buttonInfo: Tooltip.ButtonInfo? = nil
) -> some View
```

iOS 16.4 이상에서 시스템 팝오버를 사용하는 툴팁 modifier를 적용합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 툴팁의 표시 여부를 제어하는 바인딩 |
| message | 툴팁에 표시될 메시지 |
| showCloseButton | 닫기 버튼 표시 여부 (기본값: false) |
| buttonInfo | 툴팁에 추가할 버튼 정보 (선택 사항) |

#### Returns

툴팁이 적용된 뷰



</details>

<details><summary markdown="span"><code>bottomSheetModal(isPresented:needHandle:resize:actionAreaModel:_:navigation:)</code></summary>

```swift
public func bottomSheetModal(
    isPresented: Binding<Bool>,
    needHandle: Bool = true,
    resize: Modal.BottomSheet.Resize = .hug,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

바텀 시트 모달을 표시합니다.

화면 하단에서 올라오는 시트 형태로 모달을 표시합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 모달 표시 여부를 제어하는 바인딩 |
| needHandle | 상단 핸들 표시 여부 (기본값: true) |
| resize | 모달 크기 조절 방식 (기본값: .hug) |
| actionAreaModel | 모달 하단에 표시할 액션 영역 모델 |
| content | 모달에 표시할 콘텐츠 클로저 |
| navigation | 모달 상단에 표시할 네비게이션 클로저 |

#### Returns

바텀 시트 모달이 적용된 뷰



</details>

<details><summary markdown="span"><code>fullModal(isPresented:ignoresEdgeInsets:actionAreaModel:_:navigation:)</code></summary>

```swift
public func fullModal(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

전체 화면 모달을 표시합니다.

화면 전체를 덮는 모달을 표시합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 모달 표시 여부를 제어하는 바인딩 |
| ignoresEdgeInsets | 모달 내용이 Edge 인셋을 무시할지 여부 |
| actionAreaModel | 모달 하단에 표시할 액션 영역 모델 |
| content | 모달에 표시할 콘텐츠 클로저 |
| navigation | 모달 상단에 표시할 네비게이션 클로저 |

#### Returns

전체 화면 모달이 적용된 뷰



</details>

<details><summary markdown="span"><code>popupModal(isPresented:ignoresEdgeInsets:actionAreaModel:_:navigation:)</code></summary>

```swift
public func popupModal(
    isPresented: Binding<Bool>,
    ignoresEdgeInsets: Bool = false,
    actionAreaModel: ActionAreaModifier.Model? = nil,
    _ content: @escaping () -> any View,
    navigation: (() -> Modal.Navigation)? = nil
) -> some View
```

팝업 형태의 모달을 표시합니다.

전체 화면을 어둡게 하고 그 위에 팝업 형태의 모달을 표시합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| isPresented | 모달 표시 여부를 제어하는 바인딩 |
| ignoresEdgeInsets | 모달 내용이 Edge 인셋을 무시할지 여부 |
| actionAreaModel | 모달 하단에 표시할 액션 영역 모델 |
| content | 모달에 표시할 콘텐츠 클로저 |
| navigation | 모달 상단에 표시할 네비게이션 클로저 |

#### Returns

팝업 모달이 적용된 뷰



</details>

<details><summary markdown="span"><code>recognizeViewForPreview(_:fill:)</code></summary>

```swift
public func recognizeViewForPreview(_ color: SwiftUI.Color = .blue, fill: Bool = false) -> some View
```

프리뷰에서 View의 frame을 인식합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| color | 인식 색상 |
| fill | 배경 채우기 여부 |

#### Returns

인식된 View



</details>

<details><summary markdown="span"><code>carveLogForPreview(_:font:alignment:)</code></summary>

```swift
public func carveLogForPreview(
    _ message: String,
    font: Font? = nil,
    alignment: Alignment = .center
) -> some View
```

프리뷰에서 뷰 위에 로그를 출력합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| message | 출력할 메시지 |
| font | 폰트 |
| alignment | 정렬 |

#### Returns

로그가 출력된 View



</details>

<details><summary markdown="span"><code>printValue(_:_:)</code></summary>

```swift
public func printValue<V: Equatable>(_ value: V, _ label: String = "Unknown") -> some View
```

프리뷰에서 값이 변경될 때마다 콘솔에 출력합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | 출력할 값 |
| label | 출력할 레이블 |

#### Returns

값이 출력된 View



</details>

<details><summary markdown="span"><code>printSize(_:)</code></summary>

```swift
public func printSize(_ label: String = "Unknown") -> some View
```

프리뷰에서 크기가 변경될 때마다 콘솔에 출력합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| label | 출력할 레이블 |

#### Returns

크기가 출력된 View



</details>

<details><summary markdown="span"><code>measureForPreview(axis:)</code></summary>

```swift
public func measureForPreview(axis: Axis) -> some View
```

프리뷰에서 뷰의 주어진 축의 크기를 측정하여 뷰 위에 출력합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| axis | 측정할 축 |

#### Returns

뷰 크기가 그려진 View



</details>

<details><summary markdown="span"><code>measureBoxForPreview()</code></summary>

```swift
public func measureBoxForPreview() -> some View
```

프리뷰에서 뷰의 크기를 측정하여 뷰 위에 출력합니다.

#### Returns

뷰 크기가 그려진 View

</details>

<details><summary markdown="span"><code>if(_:_:else:)</code></summary>

```swift
public func `if`(
    _ condition: Bool,
    _ transform: (Self) -> any View,
    else alternative: ((Self) -> any View)? = nil
) -> some View
```

조건에 따라 View를 변환합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| condition | 변환 조건 |
| transform | 조건이 true일 때 적용할 변환 |
| alternative | 조건이 false일 때 적용할 변환 (선택적) |

#### Returns

변환된 View



</details>

<details><summary markdown="span"><code>if(_:)</code></summary>

```swift
public func `if`(_ condition: Bool) -> some View
```

조건이 true일 때만 View를 표시합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| condition | 표시 조건 |

#### Returns

조건에 따라 표시되는 View



</details>

<details><summary markdown="span"><code>modifying(_:)</code></summary>

```swift
public func modifying(_ transform: (Self) -> any View) -> some View
```

View를 변환합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| transform | 적용할 변환 |

#### Returns

변환된 View



</details>

<details><summary markdown="span"><code>modifying(_:)</code></summary>

```swift
public func modifying(_ transform: (Self) -> Self) -> Self
```

View를 변환합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| transform | 적용할 변환 |

#### Returns

변환된 View



</details>

<details><summary markdown="span"><code>asUIImage()</code></summary>

```swift
public func asUIImage() -> UIImage
```

View를 UIImage로 변환합니다.

#### Returns

변환된 UIImage

</details>

<details><summary markdown="span"><code>onGeometryChange(for:of:for:action:)</code></summary>

```swift
public func onGeometryChange<T>(
    for type: T.Type,
    of transform: @escaping (GeometryProxy) -> T,
    for dueTime: RunLoop.SchedulerTimeType.Stride,
    action: @escaping (_ newValue: T) -> Void
) -> some View where T: Equatable
```

View의 지오메트리 변경정보를 디바운스시켜서 받습니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | 변환 타입 |
| transform | 지오메트리 변환 |
| dueTime | 디바운스 시간 |
| action | 변경 시 실행할 액션 |

#### Returns

디바운스된 View



</details>

<details><summary markdown="span"><code>scrollable(_:contentOffset:)</code></summary>

```swift
public func scrollable(_ axis: Axis, contentOffset: Binding<CGPoint>) -> some View
```

뷰에 자동 스크롤 기능을 적용하는 modifier입니다.

콘텐츠 오프셋을 추적하고 스크롤이 필요한 경우에만 스크롤을 활성화합니다.
콘텐츠가 스크롤 뷰보다 작은 경우 스크롤이 비활성화됩니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| axis | 스크롤 방향 (.horizontal 또는 .vertical) |
| contentOffset | 콘텐츠 오프셋을 바인딩하는 CGPoint 값 |

#### Returns

자동 스크롤 기능이 적용된 뷰



</details>

<details><summary markdown="span"><code>disableSwipeBack(_:)</code></summary>

```swift
public func disableSwipeBack(_ disabled: Bool) -> some View
```

뷰에서 스와이프 백 제스처를 비활성화하는 modifier를 적용합니다.

네비게이션 컨트롤러의 스와이프 뒤로가기 제스처 인식기를 제어합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disabled | 스와이프 백 제스처 비활성화 여부 |

#### Returns

스와이프 백 제스처가 제어된 뷰



</details>

<details><summary markdown="span"><code>userInteractionDisabled(_:)</code></summary>

```swift
public func userInteractionDisabled(_ disabled: Bool) -> some View
```

사용자 상호작용을 비활성화하는 modifier를 적용합니다.

뷰의 터치 이벤트와 스와이프 백 제스처를 비활성화합니다.

#### Parameters

| Name | Description |
| ---- | ----------- |
| disabled | 상호작용 비활성화 여부 |

#### Returns

사용자 상호작용이 비활성화된 뷰



</details>
