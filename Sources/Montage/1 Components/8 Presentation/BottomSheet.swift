//
//  ModalBottom.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

/// 화면 하단에서 위로 올라오는 바텀 시트 모달 컴포넌트입니다.
///
/// 다양한 크기와 동작을 지원하며, 내비게이션 바·액션 영역·핸들을 설정할 수 있습니다.
///
/// 띄우는 방법은 두 가지입니다. 대개는
/// ``SwiftUI/View/bottomSheet(isPresented:isFullScreenCover:needHandle:resize:ignoresEdgeInsets:navigation:actionArea:onDismiss:_:)``
/// 수정자를 씁니다. 표시 애니메이션과 딤 처리까지 함께 해 줍니다.
///
/// ```swift
/// @State private var showBottomSheet = false
///
/// YourView()
///     .bottomSheet(
///         isPresented: $showBottomSheet,
///         resize: .flexible,
///         navigation: {
///             ModalNavigation()
///                 .title("제목")
///         },
///         actionArea: {
///             ActionArea(variant: .strong(main: .init(text: "확인", action: confirm)))
///         },
///         {
///             Text("바텀 시트 내용")
///         }
///     )
/// ```
///
/// `presentationDetents`·`interactiveDismissDisabled`처럼 SwiftUI 표준 시트 옵션을 함께
/// 얹어야 할 때는 이 타입을 직접 만들어 `.sheet` 안에 넣습니다. 수정자는 표시까지 맡으므로
/// 그 옵션을 끼워 넣을 자리가 없습니다.
///
/// ```swift
/// .sheet(isPresented: $showBottomSheet) {
///     BottomSheet {
///         Text("바텀 시트 내용")
///     }
///     .needHandle(false)
///     .presentationDetents([.large])
///     .interactiveDismissDisabled()
/// }
/// ```
public struct BottomSheet: View {
    // MARK: - Types
    
    /// 바텀 시트의 크기를 정의하는 열거형입니다.
    public enum Resize {
        /// 컨텐츠 크기에 맞게 자동 조절됩니다.
        case hug
        /// 화면 높이의 특정 비율로 고정됩니다.
        /// - Parameter ratio: 비율 (0.0 ~ 1.0)
        case fixedRatio(CGFloat)
        /// 지정한 높이로 고정됩니다.
        /// - Parameter height: 높이
        case fixedHeight(CGFloat)
        /// 사용자가 드래그하여 크기를 조절할 수 있습니다.
        case flexible
        /// 화면 전체를 채웁니다.
        case fill
        
        fileprivate var isFlexible: Bool {
            switch self {
            case .flexible:
                true
            default:
                false
            }
        }
    }
    
    // MARK: - Initializer
    
    private var content: () -> AnyView
    
    /// 바텀 시트 모달을 초기화합니다.
    ///
    /// - Parameter content: 모달 내에 표시할 콘텐츠를 반환하는 클로저
    public init<V: View>(@ViewBuilder _ content: @escaping () -> V) {
        self.content = { AnyView(content()) }
    }
    
    // MARK: - Body
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var navigationHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var actionAreaHeight: CGFloat = 0
    @State private var scrollStatus: ScrollView.ScrollStatus = .init()
    @State private var isContentMeasured = false
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                if needHandle && navigation == nil {
                    ZStack(alignment: .bottom) {
                        SwiftUI.Color.clear
                            .frame(height: 12)
                        RoundedRectangle(cornerRadius: 1000)
                            .foregroundStyle(SwiftUI.Color.semantic(.surfaceNeutralStrong))
                            .frame(width: 40, height: 5)
                    }
                }
                if isContentScrollable {
                    ZStack(alignment: .top) {
                        ScrollView(scrollStatus: $scrollStatus) {
                            VStack(spacing: 0) {
                                SwiftUI.Color.clear
                                    .frame(height: navigationHeight)
                                HStack(spacing: 0) {
                                    Spacer(minLength: 0)
                                    contentContainer()
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        
                        navigationView
                    }
                } else {
                    VStack(spacing: 0) {
                        navigationView
                        contentContainer()
                        if bottomSheetContentHeight <= bottomSheetMaxHeight {
                            Spacer(minLength: 0)
                        }
                    }
                }
                
                if let actionArea {
                    actionArea()
                        .environment(\.actionAreaScrollReachedEnd, contentScrollReachedEnd)
                        .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                            actionAreaHeight = $0
                        })
                }
            }
        }
        .opacity(isContentMeasured ? 1 : 0)
        .background(
            SwiftUI.Color.semantic(.backgroundNeutralPrimary)
                .opacity(.opacity88)
        )
        .presentationDetents(detents)
        .presentationDragIndicator(.hidden)
        .onChange(of: contentHeight) { newValue in
            if newValue > 0 { isContentMeasured = true }
        }
    }
    
    // MARK: - Modifiers
    
    private var needHandle = true
    private var resize: Resize = .hug
    private var navigation: (() -> Montage.ModalNavigation)?
    private var actionArea: (() -> ActionArea)?
    private var ignoresEdgeInsets = false
    
    /// 바텀 시트 상단의 핸들 표시 여부를 설정합니다.
    ///
    /// - Parameter needHandle: 핸들 표시 여부
    /// - Returns: 수정된 바텀 시트 뷰
    public func needHandle(_ needHandle: Bool) -> Self {
        var zelf = self
        zelf.needHandle = needHandle
        return zelf
    }
    
    /// 바텀 시트의 크기 조절 방식을 설정합니다.
    ///
    /// - Parameter resize: 크기 조절 방식
    /// - Returns: 수정된 바텀 시트 뷰
    public func resize(_ resize: BottomSheet.Resize) -> Self {
        var zelf = self
        zelf.resize = resize
        return zelf
    }
    
    /// 바텀 시트 상단에 내비게이션 바를 설정합니다.
    ///
    /// - Parameter navigation: 내비게이션 바를 반환하는 클로저
    /// - Returns: 수정된 바텀 시트 뷰
    public func modalNavigation(_ navigation: (() -> Montage.ModalNavigation)?) -> Self {
        var zelf = self
        zelf.navigation = navigation
        return zelf
    }
    
    /// 바텀 시트 하단에 액션 영역을 설정합니다.
    ///
    /// - Parameter actionArea: 하단에 배치할 ``ActionArea``를 만드는 클로저
    /// - Returns: 수정된 바텀 시트 뷰
    public func modalActionArea(_ actionArea: (() -> ActionArea)?) -> Self {
        var zelf = self
        zelf.actionArea = actionArea
        return zelf
    }
    
    /// 컨텐츠의 기본 여백을 무시할지 설정합니다.
    ///
    /// - Parameter ignoresEdgeInsets: 여백 무시 여부
    /// - Returns: 수정된 바텀 시트 뷰
    public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self {
        var zelf = self
        zelf.ignoresEdgeInsets = ignoresEdgeInsets
        return zelf
    }
    
    // MARK: - Private
    
    /// 콘텐츠가 시트 높이를 넘겨 스크롤이 생기는지 여부.
    private var isContentScrollable: Bool {
        bottomSheetContentHeight > bottomSheetMaxHeight ||
            (resize.isFlexible && bottomSheetContentHeight > bottomSheetMaxHeight / 2)
    }

    /// 스크롤이 없는 시트는 가려진 콘텐츠도 없으므로 바닥에 닿은 것으로 본다.
    /// (`nil`을 내리면 "신호 없음"이 되어 ``ActionArea``가 그라데이션을 그린다)
    private var contentScrollReachedEnd: Bool {
        isContentScrollable ? scrollStatus.reachedEnd : true
    }

    @ViewBuilder
    private var navigationView: some View {
        Group {
            if let navigation {
                navigation()
                    .scrollOffset($scrollStatus.contentOffset.y)
                    .needHandleArea(needHandle)
            }
        }
        .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { navigationHeight = $0 })
    }
    
    @ViewBuilder
    private func contentContainer() -> some View {
        content()
            .padding(contentEdgeInsets)
            .onGeometryChange(
                for: CGFloat.self,
                of: { $0.size.height },
                action: { contentHeight = $0 }
            )
    }
    
    private var contentEdgeInsets: EdgeInsets {
        ignoresEdgeInsets
        ? .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        : .init(
            top: navigation == nil ? 20 : 0,
            leading: 20,
            bottom: actionArea == nil ? 0 : 20,
            trailing: 20
        )
    }
    
    private var maxDetentHeight: CGFloat {
        if #available(iOS 26, *) {
            // iOS 26 부터는 stacked sheet로 자동 변경되지 않으므로 보정값 제거
            // 단, 스크린 높이 - 10.2 보다 커지면 자동으로 불투명해지고 edge가 스크린 끝에 붙음
            (UIApplication.keyWindow?.safeAreaSize.height ?? 0)
        } else {
            // 최대 높이에 도달할 경우 자동으로 stacked sheet로 변경되는 것을 막기 위한 보정값 10.2 추가
            // https://wantedx.slack.com/archives/C04TTGN5F1C/p1761040362320469?thread_ts=1761035208.156399&cid=C04TTGN5F1C
            (UIApplication.keyWindow?.safeAreaSize.height ?? 0) - 10.2
        }
    }
    
    private var bottomSheetMaxHeight: CGFloat {
        switch resize {
        case .hug:
            min(maxDetentHeight, bottomSheetContentHeight)
        case .fixedRatio(let ratio):
            maxDetentHeight * ratio
        case .fixedHeight(let height):
            min(maxDetentHeight, height)
        case .flexible, .fill:
            maxDetentHeight
        }
    }
    
    private var bottomSheetContentHeight: CGFloat {
        (needHandle && navigation == nil ? 12 : 0) + navigationHeight + contentHeight + actionAreaHeight
    }
    
    private var detents: Set<PresentationDetent> {
        guard isContentMeasured else {
            return [.height(maxDetentHeight)]
        }
        switch resize {
        case .flexible:
            return [
                .height(min(bottomSheetContentHeight, maxDetentHeight / 2 + safeAreaInsets.bottom)),
                .height(min(bottomSheetContentHeight, maxDetentHeight))
            ]
        default:
            return [.height(bottomSheetMaxHeight)]
        }
    }
}

struct BottomSheetModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let isFullScreenCover: Bool
    private let needHandle: Bool
    private let resize: BottomSheet.Resize
    private let ignoresEdgeInsets: Bool
    private let actionArea: (() -> ActionArea)?
    private let navigation: (() -> ModalNavigation)?
    private let onDismiss: (() -> Void)?
    private let bottomSheetContent: () -> AnyView
    
    init<V: View>(
        isPresented: Binding<Bool>,
        isFullScreenCover: Bool = false,
        needHandle: Bool = true,
        resize: BottomSheet.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        actionArea: (() -> ActionArea)? = nil,
        navigation: (() -> ModalNavigation)? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder _ content: @escaping () -> V
    ) {
        _isPresented = isPresented
        self.isFullScreenCover = isFullScreenCover
        self.needHandle = needHandle
        self.resize = resize
        self.ignoresEdgeInsets = ignoresEdgeInsets
        self.actionArea = actionArea
        self.navigation = navigation
        self.onDismiss = onDismiss
        bottomSheetContent = { AnyView(content()) }
    }
    
    func body(content: Content) -> some View {
        content
            .modifying {
                if isFullScreenCover {
                    $0.fullScreenCover(
                        isPresented: $isPresented,
                        onDismiss: onDismiss
                    ) {
                        BottomSheet {
                            bottomSheetContent()
                        }
                        .needHandle(false)
                        .resize(.fill)
                        .ignoresEdgeInsets(ignoresEdgeInsets)
                        .modalNavigation(navigation)
                        .modalActionArea(actionArea)
                    }
                } else {
                    $0.sheet(
                        isPresented: $isPresented,
                        onDismiss: onDismiss
                    ) {
                        BottomSheet {
                            bottomSheetContent()
                        }
                        .needHandle(needHandle)
                        .resize(resize)
                        .ignoresEdgeInsets(ignoresEdgeInsets)
                        .modalNavigation(navigation)
                        .modalActionArea(actionArea)
                    }
                }
            }
    }
}

// MARK: - View Extension

extension View {
    /// 바텀 시트 모달을 표시합니다.
    ///
    /// 화면 하단에서 올라오는 바텀 시트 형태의 모달을 표시합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 모달 표시 여부를 제어하는 바인딩
    ///   - isFullScreenCover: 전체 화면 모달로 표시할지 여부, 생략하면 기본값으로 `false` 적용
    ///   - needHandle: 상단 핸들 표시 여부, 생략하면 기본값으로 `true` 적용
    ///   - resize: 모달 크기 조절 방식, 생략하면 기본값으로 `.hug` 적용
    ///   - ignoresEdgeInsets: 모달 내용이 Edge 인셋을 무시할지 여부
    ///   - navigation: 모달 상단에 표시할 네비게이션 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - actionArea: 모달 하단에 배치할 ActionArea를 만드는 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - onDismiss: 모달이 닫힐때 호출될 클로저
    ///   - content: 모달에 표시할 콘텐츠 클로저
    /// - Returns: 바텀 시트 모달이 적용된 뷰
    public func bottomSheet<V: View>(
        isPresented: Binding<Bool>,
        isFullScreenCover: Bool = false,
        needHandle: Bool = true,
        resize: BottomSheet.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        navigation: (() -> ModalNavigation)? = nil,
        actionArea: (() -> ActionArea)? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder _ content: @escaping () -> V
    ) -> some View {
        modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                isFullScreenCover: isFullScreenCover,
                needHandle: needHandle,
                resize: resize,
                ignoresEdgeInsets: ignoresEdgeInsets,
                actionArea: actionArea,
                navigation: navigation,
                onDismiss: onDismiss,
                content
            )
        )
    }
}
