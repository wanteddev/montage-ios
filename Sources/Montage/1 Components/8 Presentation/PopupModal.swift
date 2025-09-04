//
//  ModalPopup.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

/// 화면 중앙에 표시되는 팝업 모달 컴포넌트입니다.
///
/// 배경을 어둡게 처리하고 화면 중앙에 콘텐츠를 표시하는 형태의 모달입니다.
/// 내비게이션 바와 액션 영역을 설정할 수 있으며, 애니메이션과 함께 표시됩니다.
///
/// ```swift
/// @State private var showPopup = false
///
/// Button("팝업 열기") {
///     showPopup = true
/// }
/// .fullScreenCover(isPresented: $showPopup) {
///     PopupModal {
///         VStack(spacing: 16) {
///             Text("알림")
///                 .font(.headline)
///             Text("중요한 메시지입니다.")
///             
///             Button("확인") {
///                 showPopup = false
///             }
///         }
///         .padding()
///     }
/// }
/// .transaction { transaction in
///     transaction.disablesAnimations = true
/// }
/// ```
///
/// 모디파이어를 사용하면 더 간편하게 구현할 수 있으며, 애니메이션이 자동으로 처리됩니다:
/// ```swift
/// YourView()
///     .modifier(
///         PopupModalModifier(
///             isPresented: $showPopup
///         ) {
///             Text("팝업 내용")
///         }
///     )
/// ```
public struct PopupModal: View {
    /// 팝업의 크기를 정의하는 열거형입니다.
    public enum Resize {
        /// 컨텐츠 크기에 맞게 자동 조절됩니다.
        case hug
        /// 지정한 높이로 고정됩니다.
        ///
        /// - Parameter height: 높이
        case fixed(CGFloat)
    }
    
    private let content: () -> any View

    /// 팝업 모달을 초기화합니다.
    ///
    /// - Parameter content: 모달 내에 표시할 콘텐츠를 반환하는 클로저
    public init(_ content: @escaping () -> any View) {
        self.content = content
    }

    @State private var navigationHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var actionAreaHeight: CGFloat = 0
    @State private var contentOffset: CGFloat = 0

    private let popupMaxHeight: CGFloat = min(760, UIScreen.main.bounds.height - 40)
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Group {
                    let contentView = AnyView(content())
                        .padding(contentEdgeInsets)
                        .onGeometryChange(
                            for: CGFloat.self,
                            of: { $0.size.height },
                            action: { contentHeight = $0 }
                        )
                    
                    ZStack(alignment: .top) {
                        ScrollView(onOffsetChanged: {
                            contentOffset = $0.y
                        }, content: {
                            VStack(spacing: 0) {
                                SwiftUI.Color.clear
                                    .frame(height: navigationHeight)
                                HStack(spacing: 0) {
                                    Spacer(minLength: 0)
                                    contentView
                                    Spacer(minLength: 0)
                                }
                            }
                        })
                        .hidesIndicators()
                        .scrollDisabled(!scrollable)
                        
                        navigationView
                    }
                }
                
                if let actionAreaModel {
                    ActionArea(variant: actionAreaModel.variant)
                        .clearBackground(scrolledToBottom)
                        .caption(actionAreaModel.caption)
                        .extra(actionAreaModel.extra, divider: actionAreaModel.extraDivider)
                        .padding(.bottom, 20)
                        .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                            actionAreaHeight = $0
                        })
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(SwiftUI.Color.semantic(.backgroundNormal))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .modifying {
            if case .fixed(let height) = resize {
                $0.frame(height: height)
            } else {
                $0.frame(maxHeight: min(popupMaxHeight, popupContentHeight))
            }
        }
        .modifying { originalView in
            Group {
                if #available(iOS 16.4, *) {
                    originalView.presentationBackground(
                        SwiftUI.Color.semantic(.materialDimmer)
                    )
                } else {
                    originalView.dimmerBackground()
                }
            }
        }
    }
    
    // MARK: - Modifiers
    
    private var resize: Resize = .hug
    private var ignoresEdgeInsets = false
    private var navigation: (() -> Montage.ModalNavigation)?
    private var actionAreaModel: ActionArea.Model?
    
    /// 팝업 모달의 크기를 설정합니다.
    ///
    /// - Parameter resize: 팝업 모달의 크기 설정
    /// - Returns: 수정된 팝업 모달 뷰
    public func resize(_ resize: Resize) -> Self {
        var zelf = self
        zelf.resize = resize
        return zelf
    }
    
    /// 컨텐츠의 기본 여백을 무시할지 설정합니다.
    ///
    /// - Parameter ignoresEdgeInsets: 여백 무시 여부
    /// - Returns: 수정된 팝업 모달 뷰
    public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self {
        var zelf = self
        zelf.ignoresEdgeInsets = ignoresEdgeInsets
        return zelf
    }
    
    /// 팝업 모달 상단에 내비게이션 바를 설정합니다.
    ///
    /// - Parameter navigation: 내비게이션 바를 반환하는 클로저
    /// - Returns: 수정된 팝업 모달 뷰
    public func modalNavigation(_ navigation: (() -> Montage.ModalNavigation)?) -> Self {
        var zelf = self
        zelf.navigation = navigation
        return zelf
    }
    
    /// 팝업 모달 하단에 액션 영역을 설정합니다.
    ///
    /// - Parameter actionAreaModel: 액션 영역 모델
    /// - Returns: 수정된 팝업 모달 뷰
    public func modalActionArea(_ actionAreaModel: ActionArea.Model?) -> Self {
        var zelf = self
        zelf.actionAreaModel = actionAreaModel
        return zelf
    }
    
    // MARK: - Private
    
    private var navigationView: some View {
        Group {
            if let navigation {
                navigation()
                    .scrollOffset($contentOffset)
            }
        }
        .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { navigationHeight = $0 })
    }
    
    private var contentEdgeInsets: EdgeInsets {
        ignoresEdgeInsets
            ? .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            : .init(
                top: navigation == nil ? 20 : 0,
                leading: 20,
                bottom: 20,
                trailing: 20
            )
    }
    
    private var popupContentHeight: CGFloat {
        navigationHeight + contentHeight + actionAreaHeight
    }
    
    private var scrolledToBottom: Bool {
        Int(contentOffset) <= Int(popupMaxHeight) - Int(popupContentHeight)
    }
    
    private var scrollable: Bool {
        if case .fixed(let height) = resize {
            popupContentHeight > height
        } else {
            popupContentHeight > popupMaxHeight
        }
    }
}

/// 팝업 모달을 표시하기 위한 뷰 모디파이어입니다.
///
/// 이 모디파이어를 사용하면 팝업 모달을 자연스러운 애니메이션과 함께
/// 표시하고 설정할 수 있습니다.
///
/// ```swift
/// @State private var showPopup = false
///
/// Button("팝업 열기") {
///     showPopup = true
/// }
/// .modifier(
///     PopupModalModifier(
///         isPresented: $showPopup
///     ) {
///         Text("팝업 내용")
///     }
/// )
/// ```
struct PopupModalModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let resize: PopupModal.Resize
    private let ignoresEdgeInsets: Bool
    private let popupContent: () -> any View
    private let navigation: (() -> ModalNavigation)?
    private let actionAreaModel: ActionArea.Model?
    
    /// 팝업 모달 모디파이어를 초기화합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 팝업 모달 표시 여부에 대한 바인딩
    ///   - resize: 팝업 모달의 크기 설정 (기본값: .hug)
    ///   - ignoresEdgeInsets: 여백 무시 여부 (기본값: false)
    ///   - content: 모달에 표시할 콘텐츠를 반환하는 클로저
    ///   - navigation: 내비게이션 바를 반환하는 클로저 (선택 사항)
    ///   - actionAreaModel: 액션 영역 모델 (선택 사항)
    init(
        isPresented: Binding<Bool>,
        resize: PopupModal.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        _ content: @escaping () -> any View,
        navigation: (() -> ModalNavigation)? = nil,
        actionAreaModel: ActionArea.Model? = nil
    ) {
        _isPresented = isPresented
        self.resize = resize
        self.ignoresEdgeInsets = ignoresEdgeInsets
        popupContent = content
        self.navigation = navigation
        self.actionAreaModel = actionAreaModel
    }
    
        @State private var opacity: CGFloat = 0
        @State private var fullScreenCoverPresented = false

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $fullScreenCoverPresented) {
                PopupModal {
                    AnyView(popupContent())
                }
                .resize(resize)
                .ignoresEdgeInsets(ignoresEdgeInsets)
                .modalNavigation(navigation)
                .modalActionArea(actionAreaModel)
                .opacity(opacity)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
            .onChange(of: isPresented) { _ in
                if isPresented {
                    fullScreenCoverPresented = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        withAnimation(.easeInOut(duration: 0.29)) {
                            opacity = 1
                        }
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        fullScreenCoverPresented = false
                    }
                }
            }
    }
}

private struct DimmerBackgroundView: UIViewRepresentable {
    func makeUIView(context _: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .semantic(.materialDimmer)
        }
        return view
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

private struct DimmerBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DimmerBackgroundView())
    }
}

private extension View {
    func dimmerBackground() -> some View {
        modifier(DimmerBackgroundViewModifier())
    }
}

// MARK: - View Extension

extension View {
    /// 팝업 모달을 표시합니다.
    ///
    /// 화면 중앙에 표시되는 팝업 형태의 모달을 표시합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 모달 표시 여부를 제어하는 바인딩
    ///   - resize: 모달 크기 조절 방식 (기본값: .hug)
    ///   - ignoresEdgeInsets: 모달 내용이 Edge 인셋을 무시할지 여부
    ///   - actionAreaModel: 모달 하단에 표시할 액션 영역 모델
    ///   - content: 모달에 표시할 콘텐츠 클로저
    ///   - navigation: 모달 상단에 표시할 네비게이션 클로저
    /// - Returns: 팝업 모달이 적용된 뷰
    public func popupModal(
        isPresented: Binding<Bool>,
        resize: PopupModal.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        actionAreaModel: ActionArea.Model? = nil,
        _ content: @escaping () -> any View,
        navigation: (() -> ModalNavigation)? = nil
    ) -> some View {
        modifier(
            PopupModalModifier(
                isPresented: isPresented,
                resize: resize,
                ignoresEdgeInsets: ignoresEdgeInsets,
                content,
                navigation: navigation,
                actionAreaModel: actionAreaModel
            )
        )
    }
}
