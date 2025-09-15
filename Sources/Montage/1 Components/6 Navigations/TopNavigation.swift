//
//  TopNavigation.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/8/24.
//

import SwiftUI

/// 상단에 표시되는 내비게이션 바 컴포넌트입니다.
///
/// 제목, 뒤로가기, 추가 액션 버튼 등을 포함할 수 있으며, 다양한 외관 스타일을 지원합니다.
/// 스크롤 시 배경색과 구분선의 불투명도가 자동으로 조절됩니다.
///
/// ```swift
/// TopNavigation(
///     variant: .normal,
///     title: "제목",
///     leading: {
///         // 뒤로가기 동작 컴포넌트
///     },
///     trailing: [
///         {
///           // 컴포넌트1
///         },
///         {
///           // 컴포넌트2
///         },
///         ...
///     ]
/// )
/// ```
public struct TopNavigation: View {
    // MARK: - Uninitialised properties
    
    private let variant: Variant
    private let title: String
    private let scrollOffset: CGFloat
    private let backgroundColor: SwiftUI.Color?
    
    // MARK: - Computed properties

    private var scrolled: Bool { scrollOffset < .zero }
    
    private var background: SwiftUI.Color {
        backgroundColor ?? SwiftUI.Color.semantic(.backgroundNormal)
    }
    
    private var backgroundOpacity: CGFloat {
        if variant.isFloating {
            return 0
        } else {
            let ratio = (scrollOffset / -32)
            return max(0, min(1, ratio))
        }
    }

    // MARK: - Initializers
   
    /// TopNavigation을 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 내비게이션 바의 외관 스타일
    ///   - title: 표시할 제목
    ///   - scrollOffset: 스크롤 오프셋 값
    ///   - backgroundColor: 배경색
    ///   - leading: 좌측에 표시할 컨텐츠
    ///   - trailings: 우측에 표시할 버튼 배열 (최대 3개까지 표시)
    public init(
        variant: Variant = .normal,
        title: String = "",
        scrollOffset: CGFloat = .zero,
        backgroundColor: SwiftUI.Color? = nil,
        leading: (() -> any View)? = nil,
        trailings: [(() -> any View)] = []
    ) {
        self.variant = variant
        self.title = title
        self.scrollOffset = scrollOffset
        self.backgroundColor = backgroundColor
        self.leading = leading.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
        self.trailings = trailings.prefix(3).map { view in { AnyView(view()) } }
    }
    
    // MARK: - Modifiers
    
    private var leading: () -> AnyView
    private var trailings: [() -> AnyView]
    
    public func leading<V: View>(@ViewBuilder content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.leading = { AnyView(content()) }
        return zelf
    }
    
    public func trailing<V: View>(contents: [() -> V]) -> Self {
        var zelf = self
        zelf.trailings = contents.prefix(3).map{ view in { AnyView(view()) } }
        return zelf
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Contents(
                variant: variant,
                title: title,
                leading: leading,
                trailings: trailings
            )
            .padding(.all, 16)
            .background {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial)
                        .opacity(backgroundOpacity)
                    background
                        .opacity(backgroundOpacity * 0.70)
                }
                .ignoresSafeArea(.container, edges: .top)
            }
            
            if scrolled && variant.isFloating == false {
                Rectangle()
                    .foregroundStyle(SwiftUI.Color.semantic(.lineNeutral).opacity(backgroundOpacity))
                    .frame(height: 0.5)
            }
        }
        .onAppear {
            Task { @MainActor in
                if let vc = UIApplication.topViewController() {
                    vc.navigationController?.setNavigationBarHidden(true, animated: false)
                    vc.setNavigationBar(type: .hideShadow)
                }
            }
        }
    }
    
    struct Contents: View {
        @State private var leadingSize: CGSize = .zero
        @State private var totalSizeOfTrailings: CGSize = .zero
        @State private var screenWidth: CGFloat = 0
        
        var variant: Variant
        var title: String
        var leading: () -> AnyView
        var trailings: [() -> AnyView]

        private var titleSize: CGFloat {
            let componentSize: CGFloat = max(leadingSize.width, totalSizeOfTrailings.width)
            let componentWitdh: CGFloat = componentSize * 2
            let horizontalPadding: CGFloat = 16 * 2
            let titleHorizontalPadding: CGFloat = 4 * 2
            return max(screenWidth - (componentWitdh + horizontalPadding + titleHorizontalPadding), 0)
        }
        
        var body: some View {
            ZStack {
                SwiftUI.Color.clear
                    .frame(height: 1)
                    .onGeometryChange(
                        for: CGFloat.self,
                        of: { $0.size.width },
                        action: { screenWidth = $0 }
                    )
                switch variant {
                case .normal:
                    HStack(spacing: .zero) {
                        leading()
                            .onGeometryChange(
                                for: CGSize.self,
                                of: { $0.size },
                                action: { leadingSize = $0 }
                            )
                        Spacer()
                        TrailingContents(trailings)
                        .onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { totalSizeOfTrailings = $0 }
                        )
                    }
                    titleView
                        .frame(width: titleSize, height: 24)
                case .extended:
                    VStack(spacing: 20) {
                        HStack {
                            leading()
                            Spacer()
                            TrailingContents(trailings)
                        }
                        HStack {
                            titleView
                                .frame(height: 24, alignment: variant.textAlignment)
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                    }
                case let .floating(alternative, background):
                    ZStack {
                        HStack(spacing: .zero) {
                            leading()
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { leadingSize = $0 }
                                )
                            Spacer()
                            TrailingContents(trailings)
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { totalSizeOfTrailings = $0 }
                                )
                        }
                        .frame(height: 24)
                        titleView
                            .frame(width: titleSize, height: 24)
                    }
                }
            }
        }
        
        private var titleView: some View {
            Text(title)
                .paragraphNew(
                    variant: variant.typoVariant,
                    weight: variant.typoWeight,
                    semantic: .labelStrong
                )
                .lineLimit(1)
        }
    }
    
    public struct LeadingButton: View {
        let action: Resource.LeadingButtonInfo?
        let alternative: Bool
        let background: Bool
        
        public init(
            _ action: Resource.LeadingButtonInfo?,
            _ alternative: Bool = false,
            _ background: Bool = false
        ) {
            self.action = action
            self.alternative = alternative
            self.background = background
        }
        
        public var body: some View {
            if let action {
                Group {
                    switch action {
                    case .back(let action):
                        IconButton(
                            variant: background
                                ? .background(size: 24, isAlternative: alternative)
                                : .default,
                            icon: background ? .chevronLeftThick : .chevronLeft
                        ) {
                            action()
                        }
                        .frame(width: 24, height: 24)
                    case let .icon(i, action):
                        IconButton(
                            variant: background
                                ? .background(size: 24, isAlternative: alternative)
                                : .default,
                            icon: i
                        ) {
                            action()
                        }
                        .frame(width: 24, height: 24)
                    case let .text(t, action):
                        TrailingTextButton(
                            text: t,
                            background: background,
                            alternative: alternative,
                            action: action
                        )
                        .frame(height: 24)
                    }
                }
                .contentShape(Rectangle().scale(2), eoFill: true)
            } else {
                SwiftUI.Color.clear
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    struct TrailingContents: View {
        let contents: [() -> AnyView]
        
        init(_ contents:  [() -> AnyView]) {
            self.contents = contents
        }

        var body: some View {
            HStack(alignment: .center, spacing: 16) {
                ForEach(contents.indices, id: \.self) { i in
                    Group { contents[i]() }
                }
            }
            .contentShape(Rectangle().scale(2), eoFill: true)
        }
    }
    
    public struct TrailingTextButton: View {
        private let text: String
        private let background: Bool
        private let alternative: Bool
        private let disable: Bool
        private let action: () -> Void
        
        public init(
            text: String,
            background: Bool = false,
            alternative: Bool = false,
            disable: Bool = false,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.background = background
            self.alternative = alternative
            self.disable = disable
            self.action = action
        }

        public var body: some View {
            Group {
                if background {
                    SwiftUI.Button {
                        action()
                    } label: {
                        Text(text)
                            .paragraphNew(
                                variant: .body2,
                                weight: .medium,
                                semantic: disable ? .labelDisable : (alternative ? .staticWhite : .labelAlternative)
                            )
                            .if(alternative) {
                                $0.opacity(0.88)
                            } else: {
                                $0.blendMode(.plusDarker)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .modifying { original in
                                Group {
                                    if alternative {
                                        original.background(
                                            SwiftUI.Color.atomic(.coolNeutral30)
                                                .opacity(0.61)
                                        )
                                    } else {
                                        original.background(
                                            ZStack {
                                                SwiftUI.Color.semantic(.staticBlack)
                                                    .opacity(0.05)
                                                SwiftUI.Color.semantic(.staticWhite)
                                                    .opacity(0.35)
                                            }
                                        )
                                        .background(.thinMaterial)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                            }
                    }
                } else {
                    Button.text(text: text) {
                        action()
                    }
                    .disable(disable)
                    .contentColor(.semantic(.labelNormal))
                    .fontVariant(.headline2)
                    .fontWeight(.regular)
                }
            }
            .frame(height: 24)
        }
    }
    
    public struct TrailingIconButton: View {
        private let icon: Icon
        private let disable: Bool
        private let background: Bool
        private let alternative: Bool
        private let showPushBadge: Bool
        private let action: () -> Void
        
        public init(
            icon: Icon,
            disable: Bool = false,
            background: Bool = false,
            alternative: Bool = false,
            showPushBadge: Bool = false,
            action: @escaping () -> Void
        ) {
            self.icon = icon
            self.disable = disable
            self.background = background
            self.alternative = alternative
            self.showPushBadge = showPushBadge
            self.action = action
        }
        
        public var body: some View {
            IconButton(
                variant: background ?
                    .background(size: 24, isAlternative: alternative) : .default,
                icon: icon
            ) {
                action()
            }
            .disable(disable)
            .showPushBadge(showPushBadge)
            .frame(width: 24, height: 24)
        }
    }
}

extension TopNavigation {
    /// TopNavigation의 외관을 결정하는 열거형입니다.
    ///
    /// 내비게이션 바의 다양한 레이아웃과 시각적 스타일을 정의합니다.
    ///
    /// ```swift
    /// TopNavigation(
    ///     variant: .floating(alternative: true, background: true),
    ///     title: "제목"
    /// )
    /// ```
    public enum Variant: Equatable {
        /// 기본 내비게이션 바 스타일
        case normal
        /// 확장된 내비게이션 바 스타일 (제목이 별도의 줄에 표시됨)
        case extended
        /// 플로팅 스타일의 내비게이션 바
        /// - Parameters:
        ///   - alternative: 대체 색상 사용 여부
        ///   - background: 배경색 적용 여부
        case floating(alternative: Bool = false, background: Bool = false)
        
        fileprivate var isFloating: Bool {
            switch self {
            case .floating: true
            case .normal, .extended: false
            }
        }
    }
    
    /// TopNavigation의 좌/우에 표시될 Resource들의 Namespace입니다.
    public enum Resource {
        /// TopNavigation의 좌측에 표시될 내용들의 열거형입니다.
        ///
        /// 뒤로가기 버튼, 아이콘 버튼, 텍스트 버튼을 지원합니다.
        ///
        /// ```swift
        /// TopNavigation(
        ///     leadingButton: .back {
        ///         // 뒤로가기 동작
        ///     }
        /// )
        /// ```
        public enum LeadingButtonInfo {
            /// 뒤로가기 버튼
            /// - Parameters:
            ///  - action: 뒤로가기 버튼 클릭시 동작할 action입니다.
            case back(action: () -> Void)
            /// 아이콘 버튼
            /// - Parameters:
            ///  - action: 아이콘 버튼 클릭시 동작할 action입니다.
            case icon(Icon, action: () -> Void)
            /// 텍스트 버튼
            /// - Parameters:
            ///  - action: 텍스트 버튼 클릭시 동작할 action입니다.
            case text(String, action: () -> Void)
        }
        
        /// TopNavigation의 우측에 표시될 내용들의 열거형입니다.
        ///
        /// 아이콘 버튼과 텍스트 버튼을 지원합니다.
        ///
        /// ```swift
        /// TopNavigation(
        ///     trailingButtons: [
        ///         .icon(.search) {
        ///             // 검색 동작
        ///         },
        ///         .text("완료") {
        ///             // 완료 동작
        ///         }
        ///     ]
        /// )
        /// ```
        public enum TrailingButtonInfo: Hashable {
            /// icon 형태의 Action입니다.
            /// - Parameters:
            ///  - icon: 아이콘 버튼의 아이콘입니다.
            ///  - disable: 버튼 비활성화 여부를 결정합니다. 기본값은 false입니다.
            ///  - showPushBadge: PushBadge의 노출 여부를 결정합니다. 기본값은 false입니다.
            ///  - action: icon 클릭시 동작할 action입니다.
            case icon(Icon, disable: Bool = false, showPushBadge: Bool = false, action: () -> Void)
            /// text 형태의 Action입니다.
            /// - Parameters:
            ///  - text: 텍스트 버튼의 텍스트입니다.
            ///  - disable: 버튼 비활성화 여부를 결정합니다. 기본값은 false입니다.
            ///  - action: text 클릭시 동작할 action입니다.
            case text(String, disable: Bool = false, action: () -> Void)
            
            public func hash(into hasher: inout Hasher) {
                switch self {
                case let .icon(i, d, s, _):
                    hasher.combine(i)
                    hasher.combine(d)
                    hasher.combine(s)
                case let .text(t, d, _):
                    hasher.combine(t)
                    hasher.combine(d)
                }
            }
            
            public static func == (
                lhs: TopNavigation.Resource.TrailingButtonInfo,
                rhs: TopNavigation.Resource.TrailingButtonInfo
            ) -> Bool {
                lhs.hashValue == rhs.hashValue
            }
        }
    }
}

extension TopNavigation.Variant {
    var typoVariant: Typography.Variant {
        switch self {
        case .normal: .headline2
        case .extended: .title3
        case .floating: .headline2
        }
    }
    
    var typoWeight: Typography.Weight {
        switch self {
        case .normal: .bold
        case .extended: .bold
        case .floating: .bold
        }
    }
    
    var textAlignment: Alignment {
        switch self {
        case .normal: .center
        case .extended: .leading
        case .floating: .center
        }
    }
}

extension TopNavigation {
    /// 컨텐츠 뷰에 TopNavigation을 적용하는 뷰 모디파이어입니다.
    ///
    /// 스크롤 감지 및 내비게이션 바 스타일링을 자동으로 처리합니다.
    ///
    /// ```swift
    /// contentView
    ///     .modifier(
    ///         TopNavigation.TopNavigationModifier(
    ///             variant: .normal,
    ///             title: "제목",
    ///             leadingButton: .back { 
    ///                 // 뒤로가기 동작
    ///             },
    ///             trailingButtons: []
    ///         )
    ///     )
    /// ```
    struct TopNavigationModifier: ViewModifier {
        private let variant: Variant
        private let title: String
        private let showIndicator: Bool
        private let backgroundColor: SwiftUI.Color?
        private let leading: (() -> any View)?
        private let trailings: [() -> any View]
        private let actionAreaModel: ActionArea.Model?
        
        /// TopNavigationModifier를 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 내비게이션 바의 외관 스타일
        ///   - title: 표시할 제목
        ///   - showIndicator: 인디케이터 표시 여부
        ///   - backgroundColor: 배경색
        ///   - leading: 좌측에 표시할 버튼
        ///   - trailings: 우측에 표시할 버튼 배열
        ///   - actionAreaModel: 액션 영역 모델
        init(
            variant: Variant,
            title: String,
            showIndicator: Bool = true,
            backgroundColor: SwiftUI.Color? = nil,
            leading: (() -> any View)? = nil,
            trailings: [() -> any View] = [],
            actionAreaModel: ActionArea.Model? = nil
        ) {
            self.variant = variant
            self.title = title
            self.showIndicator = showIndicator
            self.backgroundColor = backgroundColor
            self.leading = leading.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
            self.trailings = trailings.prefix(3).map { view in { AnyView(view()) } }
            self.actionAreaModel = actionAreaModel
        }
        
        // MARK: - Body
        
        @Environment(\.safeAreaInsets) private var safeAreaInsets

        @State private var scrollStatus: ScrollView.ScrollStatus = .init()
        @State private var navigationHeight: CGFloat = .zero
        @State private var originBottomActionHeight: CGFloat = .zero
        @State private var currentBottomActionHeight: CGFloat = .zero

        func body(content: Content) -> some View {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView(scrollStatus: $scrollStatus) {
                        content
                            .padding(.top, navigationHeight)
                    }
                    .background(
                        background
                    )
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        TopNavigation(
                            variant: variant,
                            title: title,
                            scrollOffset: scrollStatus.contentOffset.y,
                            backgroundColor: backgroundColor,
                            leading: leading,
                            trailings: trailings
                        )
                        .onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { navigationHeight = $0.height }
                        )
                        Spacer()
                    }
                }
                
                if let actionAreaModel {
                    ActionArea(variant: actionAreaModel.variant)
                        .clearBackground(scrollStatus.scrolledToMax)
                        .caption(actionAreaModel.caption)
                        .extra(actionAreaModel.extra, divider: actionAreaModel.extraDivider)
                }
            }
        }
        
        private var background: SwiftUI.Color {
            backgroundColor ?? .clear
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 TopNavigation 바를 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 내비게이션 바의 외관 스타일 (기본값: .normal)
    ///   - title: 표시할 제목
    ///   - backgroundColor: 배경색 (기본값: nil)
    ///   - leading: 좌측에 표시할 컴포넌트 (기본값: nil)
    ///   - trailings: 우측에 표시할 컴포넌트 (기본값: [])
    ///   - model: 하단 액션 영역에 대한 모델 (기본값: nil)
    /// - Returns: TopNavigation이 적용된 뷰
    public func topNavigation(
        variant: TopNavigation.Variant = .normal,
        title: String,
        backgroundColor: SwiftUI.Color? = nil,
        leading: (() -> any View)? = nil,
        trailings: [() -> any View] = [],
        withBottom model: ActionArea.Model? = nil
    ) -> some View {
        modifier(
            TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title,
                backgroundColor: backgroundColor,
                leading: leading,
                trailings: trailings,
                actionAreaModel: model
            )
        )
    }
}

fileprivate extension UIApplication {
    class func topViewController(
        base: UIViewController? = UIApplication.keyWindow?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

fileprivate extension UIViewController {
    /*
     기존 navigationBar의 shadowImage와 backgroundImage를 제어하는 방식은
     iOS 12 이전 버전에서 사용하는 방식이라 iOS 13에서 뒤로가기 시 네비게이션 바의 색상이 깨지는 현상이 발생
     iOS 13에서 UINavigationBarAppearance가 추가되어 네비게이션의 속성을 정의할 수 있음
     
     standardAppearance : 기본 네비게이션
     scrollEdgeAppearance : Large Title 형태의 네비게이션
     compactAppearance : 가로모드 일 때 타이틀만 있는 네비게이션
     */
    
    func setNavigationBar(
        type: NavigationType,
        backgroundColor: UIColor = .semantic(.backgroundNormal),
        tintColor: UIColor = .semantic(.labelStrong)
    ) {
        let navigationAppearance = UINavigationBarAppearance()
        
        switch type {
        case .default:
            // 불투명 네비게이션 바
            navigationAppearance.configureWithOpaqueBackground()
            navigationController?.navigationBar.barTintColor = tintColor
            navigationAppearance.backgroundColor = backgroundColor
        case .transparent:
            // 투명 네비게이션 바
            navigationAppearance.configureWithTransparentBackground()
            navigationController?.navigationBar.barTintColor = .clear
        case .hideShadow:
            // 하단 라인 제거
            navigationAppearance.configureWithTransparentBackground()
            navigationController?.navigationBar.barTintColor = tintColor
            navigationAppearance.backgroundColor = backgroundColor
        }
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        
        // iOS 15에서 standardAppearance만 설정한 경우 barTintColor 적용이 안되는 이슈가 있다고 하여 함께 설정함
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
    }
}

fileprivate enum NavigationType {
    case `default`
    case transparent
    case hideShadow
}
