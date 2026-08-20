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
///     Popup {
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
///     .popup(
///         isPresented: $showPopup
///     ) {
///         Text("팝업 내용")
///     }
/// ```
public struct Popup: View {
    /// 팝업의 크기를 정의하는 열거형입니다.
    public enum Resize {
        /// 컨텐츠 크기에 맞게 자동 조절됩니다.
        case hug
        /// 지정한 높이로 고정됩니다.
        /// - Parameter height: 높이
        case fixed(CGFloat)
    }

    private let content: () -> AnyView

    /// 팝업 모달을 초기화합니다.
    ///
    /// - Parameter content: 모달 내에 표시할 콘텐츠를 반환하는 클로저
    public init<V: View>(@ViewBuilder _ content: @escaping () -> V) {
        self.content = { AnyView(content()) }
    }

    @State private var navigationHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var actionAreaHeight: CGFloat = 0
    @State private var contentOffset: CGFloat = 0

    private let popupMaxHeight: CGFloat = min(760, UIScreen.main.bounds.height - 40)

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ScrollView(
                        onOffsetChanged: {
                            contentOffset = $0.y
                        },
                        content: {
                            VStack(spacing: 0) {
                                SwiftUI.Color.clear
                                    .frame(height: navigationHeight)
                                HStack(spacing: 0) {
                                    Spacer(minLength: 0)
                                    content()
                                        .padding(contentEdgeInsets)
                                        .onGeometryChange(
                                            for: CGFloat.self,
                                            of: { $0.size.height },
                                            action: { contentHeight = $0 }
                                        )
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                    )
                    .hidesIndicators()
                    .scrollDisabled(!scrollable)

                    navigationView
                }

                if let actionAreaModel {
                    actionAreaModel.makeActionArea(
                        transparentBackground: backgroundTransparency(
                            for: actionAreaModel.backgroundTransparencyControl
                        )
                    )
                        .padding(.bottom, 20)
                        .onGeometryChange(
                            for: CGFloat.self, of: { $0.size.height },
                            action: {
                                actionAreaHeight = $0
                            })
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(SwiftUI.Color.semantic(.backgroundNeutralPrimary))
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
                        SwiftUI.Color.semantic(.effectDimmerPrimary)
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
        .onGeometryChange(
            for: CGFloat.self, of: { $0.size.height }, action: { navigationHeight = $0 })
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

    /// 콘텐츠가 실제로 보이는 영역의 높이.
    ///
    /// `.fixed`는 지정한 높이를 그대로 쓰고, `.hug`는 콘텐츠 높이를 `popupMaxHeight`로 제한한 값이다.
    /// 스크롤 가능 여부와 스크롤 끝 판정이 모두 이 값을 기준으로 계산된다.
    private var viewportHeight: CGFloat {
        if case .fixed(let height) = resize {
            height
        } else {
            min(popupMaxHeight, popupContentHeight)
        }
    }

    /// 스크롤 끝 판정에 허용하는 오프셋 오차.
    ///
    /// @2x·@3x 화면에서 1pt는 2~3픽셀이므로, 1픽셀에도 못 미치는 레이아웃 오차로 판정이 뒤집히지 않도록 둔다.
    private static let bottomOffsetTolerance: CGFloat = 0.5

    /// `contentOffset`은 최상단에서 0이고 아래로 스크롤할수록 음수가 되므로,
    /// 스크롤 끝 오프셋은 `viewportHeight - popupContentHeight`가 된다.
    ///
    /// 비교는 `CGFloat`로 직접 한다. `Int` 변환은 세 값의 소수부를 각각 버리기 때문에
    /// 실제로 끝에 닿은 상황에서도 판정이 최대 1pt 어긋날 수 있다.
    private var scrolledToBottom: Bool {
        contentOffset <= viewportHeight - popupContentHeight + Self.bottomOffsetTolerance
    }

    private var scrollable: Bool {
        popupContentHeight > viewportHeight
    }

    /// ActionArea의 배경 투명도.
    ///
    /// 모델이 `.manual`로 값을 지정하면 그 값을 존중하고, `.automatic`이면 스크롤이 끝에 닿았는지로 판단한다.
    private func backgroundTransparency(
        for control: ActionArea.BackgroundTransparencyControl
    ) -> Bool {
        if case .manual(let transparency) = control {
            transparency
        } else {
            scrolledToBottom
        }
    }
}

struct PopupModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let resize: Popup.Resize
    private let ignoresEdgeInsets: Bool
    private let popupContent: () -> AnyView
    private let navigation: (() -> ModalNavigation)?
    private let actionAreaModel: ActionArea.Model?

    init<V: View>(
        isPresented: Binding<Bool>,
        resize: Popup.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        @ViewBuilder _ content: @escaping () -> V,
        navigation: (() -> ModalNavigation)? = nil,
        actionAreaModel: ActionArea.Model? = nil
    ) {
        _isPresented = isPresented
        self.resize = resize
        self.ignoresEdgeInsets = ignoresEdgeInsets
        popupContent = { AnyView(content()) }
        self.navigation = navigation
        self.actionAreaModel = actionAreaModel
    }

    @State private var opacity: CGFloat = 0
    @State private var fullScreenCoverPresented = false

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $fullScreenCoverPresented) {
                Popup {
                    popupContent()
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
            view.superview?.superview?.backgroundColor = .semantic(.effectDimmerPrimary)
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

extension View {
    fileprivate func dimmerBackground() -> some View {
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
    ///   - resize: 모달 크기 조절 방식, 생략하면 기본값으로 `.hug` 적용
    ///   - ignoresEdgeInsets: 모달 내용이 Edge 인셋을 무시할지 여부, 생략하면 기본값으로 `false` 적용
    ///   - actionAreaModel: 모달 하단에 표시할 액션 영역 모델, 생략하면 기본값으로 `nil` 적용
    ///   - content: 모달에 표시할 콘텐츠 클로저
    ///   - navigation: 모달 상단에 표시할 네비게이션 클로저, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 팝업 모달이 적용된 뷰
    public func popup<V: View>(
        isPresented: Binding<Bool>,
        resize: Popup.Resize = .hug,
        ignoresEdgeInsets: Bool = false,
        actionAreaModel: ActionArea.Model? = nil,
        @ViewBuilder _ content: @escaping () -> V,
        navigation: (() -> ModalNavigation)? = nil
    ) -> some View {
        modifier(
            PopupModifier(
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
