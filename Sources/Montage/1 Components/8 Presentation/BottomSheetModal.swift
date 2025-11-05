//
//  ModalBottom.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

/// 화면 하단에서 위로 올라오는 바텀 시트 모달 컴포넌트입니다.
///
/// SwiftUI의 .sheet 수정자와 함께 사용하여 다양한 크기와 동작을 지원하는 바텀 시트를 구현합니다.
/// 내비게이션 바, 액션 영역, 핸들 등의 요소를 설정할 수 있습니다.
///
/// ```swift
/// @State private var showBottomSheet = false
///
/// Button("바텀 시트 열기") {
///     showBottomSheet = true
/// }
/// .sheet(isPresented: $showBottomSheet) {
///     BottomSheetModal {
///         VStack(spacing: 16) {
///             Text("바텀 시트 내용")
///             Button("닫기") {
///                 showBottomSheet = false
///             }
///         }
///     }
///     .resize(.flexible)
///     .modalNavigation {
///         ModalNavigation()
///             .title("제목")
///     }
/// }
/// ```
///
/// 모디파이어를 사용하면 더 간편하게 구현할 수 있습니다:
/// ```swift
/// YourView()
///     .bottomSheetModal(
///         isPresented: $showBottomSheet,
///         resize: .hug
///     ) {
///         Text("바텀 시트 내용")
///     }
/// ```
public struct BottomSheetModal: View {
    // MARK: - Types
    
    /// 바텀 시트의 크기를 정의하는 열거형입니다.
    public enum Resize {
        /// 컨텐츠 크기에 맞게 자동 조절됩니다.
        case hug
        /// 화면 높이의 특정 비율로 고정됩니다.
        ///
        /// - Parameter ratio: 비율 (0.0 ~ 1.0)
        case fixedRatio(CGFloat)
        /// 지정한 높이로 고정됩니다.
        ///
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
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                if needHandle && navigation == nil {
                    ZStack(alignment: .bottom) {
                        SwiftUI.Color.clear
                            .frame(height: 12)
                        RoundedRectangle(cornerRadius: 1000)
                            .foregroundStyle(SwiftUI.Color.semantic(.fillStrong))
                            .frame(width: 40, height: 5)
                    }
                }
                if bottomSheetContentHeight > bottomSheetMaxHeight ||
                    (resize.isFlexible && bottomSheetContentHeight > bottomSheetMaxHeight / 2) {
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
                
                if let actionAreaModel {
                    ActionArea(variant: actionAreaModel.variant)
                        .transparentBackground(scrollStatus.scrolledToMax)
                        .caption(actionAreaModel.caption)
                        .extra(actionAreaModel.extra, divider: actionAreaModel.extraDivider)
                        .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                            actionAreaHeight = $0
                        })
                }
            }
        }
        .presentationDetents(detents)
        .presentationDragIndicator(.hidden)
    }
    
    // MARK: - Modifiers
    
    private var needHandle = true
    private var resize: Resize = .hug
    private var navigation: (() -> Montage.ModalNavigation)?
    private var actionAreaModel: ActionArea.Model?
    private var ignoresEdgeInsets = false
    private var fullModal = false
    
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
    public func resize(_ resize: BottomSheetModal.Resize) -> Self {
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
    /// - Parameter actionAreaModel: 액션 영역 모델
    /// - Returns: 수정된 바텀 시트 뷰
    public func modalActionArea(_ actionAreaModel: ActionArea.Model?) -> Self {
        var zelf = self
        zelf.actionAreaModel = actionAreaModel
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
    
    internal func fullModal(_ fullModal: Bool = true) -> Self {
        var zelf = self
        zelf.fullModal = fullModal
        return zelf
    }
    
    // MARK: - Private
    
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
            bottom: actionAreaModel == nil ? 0 : 20,
            trailing: 20
        )
    }
    
    private var maxDetentHeight: CGFloat {
        // 최대 높이에 도달할 경우 자동으로 스택 형태로 변경되는 것을 막기 위한 보정값 10.2 추가
        // https://wantedx.slack.com/archives/C04TTGN5F1C/p1761040362320469?thread_ts=1761035208.156399&cid=C04TTGN5F1C
        (UIApplication.keyWindow?.safeAreaSize.height ?? 0) - 10.2
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
        switch resize {
        case .flexible:
            [
                .height(min(bottomSheetContentHeight, maxDetentHeight / 2 + safeAreaInsets.bottom)),
                .height(min(bottomSheetContentHeight, maxDetentHeight))
            ]
        default:
            [.height(bottomSheetMaxHeight)]
        }
    }
}

struct BottomSheetModalModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let bottomSheetContent: () -> AnyView
    private let needHandle: Bool
    private let resize: BottomSheetModal.Resize
    private let ignoresEdgeInsets: Bool
    private let navigation: (() -> ModalNavigation)?
    private let actionAreaModel: ActionArea.Model?
    
    init<V: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder _ content: @escaping () -> V,
        needHandle: Bool = true,
        resize: BottomSheetModal.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        navigation: ( () -> ModalNavigation)? = nil,
        actionAreaModel: ActionArea.Model? = nil
    ) {
        _isPresented = isPresented
        bottomSheetContent = { AnyView(content()) }
        self.needHandle = needHandle
        self.resize = resize
        self.ignoresEdgeInsets = ignoresEdgeInsets
        self.navigation = navigation
        self.actionAreaModel = actionAreaModel
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                BottomSheetModal {
                    bottomSheetContent()
                }
                .needHandle(needHandle)
                .resize(resize)
                .ignoresEdgeInsets(ignoresEdgeInsets)
                .modalNavigation(navigation)
                .modalActionArea(actionAreaModel)
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
    ///   - needHandle: 상단 핸들 표시 여부 (기본값: true)
    ///   - resize: 모달 크기 조절 방식 (기본값: .hug)
    ///   - actionAreaModel: 모달 하단에 표시할 액션 영역 모델
    ///   - content: 모달에 표시할 콘텐츠 클로저
    ///   - navigation: 모달 상단에 표시할 네비게이션 클로저
    /// - Returns: 바텀 시트 모달이 적용된 뷰
    public func bottomSheetModal<V: View>(
        isPresented: Binding<Bool>,
        needHandle: Bool = true,
        resize: BottomSheetModal.Resize = .hug,
        actionAreaModel: ActionArea.Model? = nil,
        @ViewBuilder _ content: @escaping () -> V,
        navigation: (() -> ModalNavigation)? = nil
    ) -> some View {
        modifier(
            BottomSheetModalModifier(
                isPresented: isPresented,
                content,
                needHandle: needHandle,
                resize: resize,
                navigation: navigation,
                actionAreaModel: actionAreaModel
            )
        )
    }
}
