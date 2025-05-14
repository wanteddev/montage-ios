---
1title: view
description: 
image: 
createdAt: 2025-05-13
updatedAt: 2025-05-13
---

Extended Protocol

# View 

MontageSwiftUICore

```swift
extension View
```

## Topics 

### Instance Methods 

- [func actionArea(model: ActionAreaModifier.Model) -> some View](/documentation/montage/swiftuicore/view/actionarea(model:).md)

  현재 뷰에 하단 ActionArea를 적용합니다.

- [func asUIImage() -> UIImage](/documentation/montage/swiftuicore/view/asuiimage().md)

  View를 UIImage로 변환합니다.

- [func bottomSheetModal(isPresented: Binding<Bool>, needHandle: Bool, resize: Modal.BottomSheet.Resize, actionAreaModel: ActionAreaModifier.Model?, () -> any View, navigation: (() -> Modal.Navigation)?) -> some View](/documentation/montage/swiftuicore/view/bottomsheetmodal(ispresented:needhandle:resize:actionareamodel:_:navigation:).md)

  바텀 시트 모달을 표시합니다.

- [func carveLogForPreview(String, font: Font?, alignment: Alignment) -> some View](/documentation/montage/swiftuicore/view/carvelogforpreview(_:font:alignment:).md)

  프리뷰에서 뷰 위에 로그를 출력합니다.

- [func disableSwipeBack(Bool) -> some View](/documentation/montage/swiftuicore/view/disableswipeback(_:).md)

  뷰에서 스와이프 백 제스처를 비활성화하는 modifier를 적용합니다.

- [func elevation(Elevation) -> Self](/documentation/montage/swiftuicore/view/elevation(_:).md)

  Montage 디자인 시스템의 그림자 효과를 적용합니다.

- [func fullModal(isPresented: Binding<Bool>, ignoresEdgeInsets: Bool, actionAreaModel: ActionAreaModifier.Model?, () -> any View, navigation: (() -> Modal.Navigation)?) -> some View](/documentation/montage/swiftuicore/view/fullmodal(ispresented:ignoresedgeinsets:actionareamodel:_:navigation:).md)

  전체 화면 모달을 표시합니다.

- [func `if`(Bool) -> some View](/documentation/montage/swiftuicore/view/if(_:).md)

  조건이 true일 때만 View를 표시합니다.

- [func `if`(Bool, (Self) -> any View, else: ((Self) -> any View)?) -> some View](/documentation/montage/swiftuicore/view/if(_:_:else:).md)

  조건에 따라 View를 변환합니다.

- [func loading(Binding<Bool>, type: Loading.Kind, dimmedColor: SwiftUI.Color) -> some View](/documentation/montage/swiftuicore/view/loading(_:type:dimmedcolor:).md)

  현재 뷰에 로딩 인디케이터와 함께 로딩 오버레이를 적용합니다.

- [func measureBoxForPreview() -> some View](/documentation/montage/swiftuicore/view/measureboxforpreview().md)

  프리뷰에서 뷰의 크기를 측정하여 뷰 위에 출력합니다.

- [func measureForPreview(axis: Axis) -> some View](/documentation/montage/swiftuicore/view/measureforpreview(axis:).md)

  프리뷰에서 뷰의 주어진 축의 크기를 측정하여 뷰 위에 출력합니다.

- [func modifying((Self) -> any View) -> some View](/documentation/montage/swiftuicore/view/modifying(_:)-40fac.md)

  View를 변환합니다.

- [func modifying((Self) -> Self) -> Self](/documentation/montage/swiftuicore/view/modifying(_:)-5z8ib.md)

  View를 변환합니다.

- [func onGeometryChange<T>(for: T.Type, of: (GeometryProxy) -> T, for: RunLoop.SchedulerTimeType.Stride, action: (_ newValue: T) -> Void) -> some View](/documentation/montage/swiftuicore/view/ongeometrychange(for:of:for:action:).md)

  View의 지오메트리 변경정보를 디바운스시켜서 받습니다.

- [func paragraph(variant: Typography.Variant) -> some View](/documentation/montage/swiftuicore/view/paragraph(variant:).md)

  Montage 디자인 시스템의 단락 스타일을 적용합니다.

- [func popupModal(isPresented: Binding<Bool>, ignoresEdgeInsets: Bool, actionAreaModel: ActionAreaModifier.Model?, () -> any View, navigation: (() -> Modal.Navigation)?) -> some View](/documentation/montage/swiftuicore/view/popupmodal(ispresented:ignoresedgeinsets:actionareamodel:_:navigation:).md)

  팝업 형태의 모달을 표시합니다.

- [func printSize(String) -> some View](/documentation/montage/swiftuicore/view/printsize(_:).md)

  프리뷰에서 크기가 변경될 때마다 콘솔에 출력합니다.

- [func printValue<V>(V, String) -> some View](/documentation/montage/swiftuicore/view/printvalue(_:_:).md)

  프리뷰에서 값이 변경될 때마다 콘솔에 출력합니다.

- [func pullToRefresh(scrollYOffset: Binding<CGFloat>, refresh: () async -> Void) -> some View](/documentation/montage/swiftuicore/view/pulltorefresh(scrollyoffset:refresh:).md)

  스크롤 뷰에 풀-투-리프레시(Pull-to-Refresh) 기능을 추가합니다.

- [func pushBadge(variant: PushBadge.Variant, size: PushBadge.Size, fontColor: SwiftUI.Color, backgroundColor: SwiftUI.Color, position: PushBadge.Position, inset: CGSize) -> some View](/documentation/montage/swiftuicore/view/pushbadge(variant:size:fontcolor:backgroundcolor:position:inset:).md)

  현재 뷰에 푸시 알림 뱃지를 표시합니다.

- [func recognizeViewForPreview(SwiftUI.Color, fill: Bool) -> some View](/documentation/montage/swiftuicore/view/recognizeviewforpreview(_:fill:).md)

  프리뷰에서 View의 frame을 인식합니다.

- [func scrollable(Axis, contentOffset: Binding<CGPoint>) -> some View](/documentation/montage/swiftuicore/view/scrollable(_:contentoffset:).md)

  뷰에 자동 스크롤 기능을 적용하는 modifier입니다.

- [func skeleton(isPresented: Bool, kind: Skeleton.Kind, color: SwiftUI.Color?, opacity: CGFloat?, size: CGSize?) -> some View](/documentation/montage/swiftuicore/view/skeleton(ispresented:kind:color:opacity:size:).md)

  현재 뷰에 미리 정의된 스켈레톤 로딩 UI를 적용합니다.

- [func skeleton(isPresented: Bool, skeletonView: () -> any View) -> some View](/documentation/montage/swiftuicore/view/skeleton(ispresented:skeletonview:).md)

  현재 뷰에 커스텀 스켈레톤 로딩 UI를 적용합니다.

- [func snackBar(Binding<SnackBar.Model?>, handler: () -> Void) -> some View](/documentation/montage/swiftuicore/view/snackbar(_:handler:).md)

  현재 뷰에 SnackBar를 표시하는 modifier를 적용합니다.

- [func toast(Binding<Toast.Model?>, location: Toast.Location, duration: Toast.Duration) -> some View](/documentation/montage/swiftuicore/view/toast(_:location:duration:).md)

  현재 뷰에 Toast 메시지를 표시하는 modifier를 적용합니다.

- [func tooltip(isPresented: Binding<Bool>, message: String, showCloseButton: Bool, buttonInfo: Tooltip.ButtonInfo?) -> some View](/documentation/montage/swiftuicore/view/tooltip(ispresented:message:showclosebutton:buttoninfo:).md)

  iOS 16.4 이상에서 시스템 팝오버를 사용하는 툴팁 modifier를 적용합니다.

- [func tooltip(isPresented: Binding<Bool>, position: Tooltip.Position, message: String, showArrow: Bool, showCloseButton: Bool, buttonInfo: Tooltip.ButtonInfo?) -> some View](/documentation/montage/swiftuicore/view/tooltip(ispresented:position:message:showarrow:showclosebutton:buttoninfo:).md)

  현재 뷰에 툴팁을 표시하는 modifier를 적용합니다.

- [func topNavigation(variant: Bar.TopNavigation.Variant, title: String, backgroundColorResolvable: ColorResolvable?, leadingButton: Bar.TopNavigation.Resource.LeadingButton?, trailingButtons: [Bar.TopNavigation.Resource.TrailingButton], withBottom: ActionAreaModifier.Model?) -> some View](/documentation/montage/swiftuicore/view/topnavigation(variant:title:backgroundcolorresolvable:leadingbutton:trailingbuttons:withbottom:).md)

  현재 뷰에 TopNavigation 바를 적용합니다.

- [func userInteractionDisabled(Bool) -> some View](/documentation/montage/swiftuicore/view/userinteractiondisabled(_:).md)

