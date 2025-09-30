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
///     scrollOffset: $scrollOffset,
///     backgroundColor: .white
/// )
/// .variant(.normal)
/// .title ( /* 제목 텍스트 */ )
/// .leadingContent { /* 왼쪽 영역 컴포넌트 */ }
/// .trailingContents(
///     { /* 컴포넌트1 },
///     { /* 컴포넌트2 } ...
/// )
/// ```
/// ```swift
///TopNavigation(
///    scrollOffset: $scrollOffset,
///    backgroundColor: .white
///)
///.variant(.floating())
///.title { /* 제목 컴포넌트 */ }
///.leadingContent { /* 왼쪽 영역 컴포넌트 */ }
///.trailingContents(
///    { /* 컴포넌트1 },
///    { /* 컴포넌트2 } ...
///)
/// ```
public struct TopNavigation: View {
    // MARK: - Uninitialised properties
    
    
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
    ///   - scrollOffset: 스크롤 오프셋 값
    ///   - backgroundColor: 배경색
    public init(
        scrollOffset: CGFloat = .zero,
        backgroundColor: SwiftUI.Color? = nil
    ) {
        self.scrollOffset = scrollOffset
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Modifiers
    
    private var variant: Variant = .normal
    private var title: () -> AnyView  = { AnyView(EmptyView()) }
    private var leadingContent: () -> AnyView  = { AnyView(EmptyView()) }
    private var trailingContents: [() -> AnyView] = []

    /// 내비게이션 바의 스타일(Variant)을 설정합니다.
    ///
    /// `.normal`, `.extended`, `.floating`, `.emphasized` 중 하나의 스타일을 지정할 수 있으며,
    /// 스타일에 따라 내비게이션의 외형과 정렬 방식 등이 달라집니다.
    ///
    /// - Parameter variant: 적용할 내비게이션 스타일
    /// - Returns: 수정된 내비게이션 바 인스턴스
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    /// 텍스트 기반 타이틀을 설정합니다.
    ///
    /// 전달된 텍스트는 `TopNavigation.TitleView`로 감싸져 렌더링됩니다.
    ///
    /// - Parameters:
    ///   - text: 타이틀에 표시할 문자열
    /// - Returns: 수정된 내비게이션 바 인스턴스
    public func title(text: String) -> Self {
        var zelf = self
        zelf.title = {
            AnyView(TitleView(variant: self.variant, title: text))
        }
        return zelf
    }
    
    /// 내비게이션 영역의 타이틀 뷰를 설정합니다.
    ///
    /// 타이틀에는 텍스트 또는 커스텀 뷰를 사용할 수 있으며, ViewBuilder를 통해 정의됩니다.
    ///
    /// - Parameter content: 표시할 타이틀 뷰를 반환하는 클로저
    /// - Returns: 수정된 인스턴스를 반환합니다.
    public func title<V: View>(@ViewBuilder content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.title = { AnyView(content()) }
        return zelf
    }
    
    /// 내비게이션 영역의 왼쪽(leadingContent) 영역에 표시할 뷰를 설정합니다.
    ///
    /// 주로 아이콘이나 취소 버튼 등을 배치할 수 있으며, ViewBuilder를 통해 정의됩니다.
    ///
    /// - Parameter content: leadingContent 영역에 표시할 뷰를 반환하는 클로저
    /// - Returns: 수정된 인스턴스를 반환합니다.
    public func leadingContent<V: View>(@ViewBuilder content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.leadingContent = { AnyView(content()) }
        return zelf
    }
    
    /// 내비게이션 영역의 오른쪽(trailing) 영역에 표시할 뷰들을 설정합니다.
    ///
    /// 최대 3개까지의 뷰를 클로저 배열로 전달할 수 있으며,
    /// 각 클로저는 다양한 타입의 View를 반환할 수 있습니다 (`any View`).
    /// 내부적으로는 모든 View를 `AnyView`로 타입을 지운 후 렌더링합니다.
    ///
    /// - Parameter contents: trailing 영역에 표시할 뷰들을 반환하는 클로저 배열
    /// - Returns: 수정된 인스턴스를 반환합니다.
    public func trailingContents(_ contents: [() -> any View]) -> Self {
        trailingContents(contents.prefix(3).map{ view in { AnyView(view()) } })
    }

    /// 내비게이션 영역의 오른쪽(trailing) 영역에 표시할 뷰들을 설정합니다.
    ///
    /// 최대 3개까지의 뷰를 클로저를 , 로 구분하여 전달할 수 있으며,
    /// 각 클로저는 다양한 타입의 View를 반환할 수 있습니다 (`any View`).
    /// 내부적으로는 모든 View를 `AnyView`로 타입을 지운 후 렌더링합니다.
    ///
    /// - Parameter contents: trailing 영역에 표시할 뷰들을 반환하는 클로저들
    /// - Returns: 수정된 인스턴스를 반환합니다.
    public func trailingContents(_ contents: (() -> any View)...) -> Self {
        trailingContents(contents.prefix(3).map{ view in { AnyView(view()) } })
    }

    func trailingContents(_ contents: [() -> AnyView]) -> Self {
        var zelf = self
        zelf.trailingContents = Array(contents.prefix(3))
        return zelf
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Contents(
                variant: variant,
                title: title,
                leadingContent: leadingContent,
                trailingContents: trailingContents
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
        var title: () -> AnyView
        var leadingContent: () -> AnyView
        var trailingContents: [() -> AnyView]

        private var titleSize: CGFloat {
            let componentSize: CGFloat = max(leadingSize.width, totalSizeOfTrailings.width)
            let componentWidth: CGFloat = componentSize * 2
            let horizontalPadding: CGFloat = 16 * 2
            let titleHorizontalPadding: CGFloat = 4 * 2
            return max(screenWidth - (componentWidth + horizontalPadding + titleHorizontalPadding), 0)
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
                        leadingContent()
                            .onGeometryChange(
                                for: CGSize.self,
                                of: { $0.size },
                                action: { leadingSize = $0 }
                            )
                        Spacer()
                        TrailingContents(trailingContents)
                            .onGeometryChange(
                                for: CGSize.self,
                                of: { $0.size },
                                action: { totalSizeOfTrailings = $0 }
                            )
                    }
                    title()
                        .frame(width: titleSize, height: 24)
                case .extended:
                    VStack(spacing: 20) {
                        HStack {
                            leadingContent()
                            Spacer()
                            TrailingContents(trailingContents)
                        }
                        HStack {
                            title()
                                .frame(height: 24, alignment: variant.textAlignment)
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                    }
                case .floating:
                    ZStack {
                        HStack(spacing: .zero) {
                            leadingContent()
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { leadingSize = $0 }
                                )
                            Spacer()
                            TrailingContents(trailingContents)
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { totalSizeOfTrailings = $0 }
                                )
                        }
                        .frame(height: 24)
                        title()
                            .frame(width: titleSize, height: 24)
                    }
                }
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
                ForEach(Array(contents.enumerated()), id: \.offset) { _, makeView in
                    makeView()
                }
            }
            .contentShape(Rectangle().scale(2), eoFill: true) // 터치영역 확장
        }
    }
}

extension TopNavigation {
    /// 내비게이션 바의 제목 컴포넌트입니다.
    ///
    /// 전달받은 스타일(variant)에 따라 타이포그래피가 동적으로 적용되며,
    /// 최대 한 줄로 제한된 제목 텍스트를 보여줍니다.
    ///
    /// ```swift
    /// TitleView(variant: .normal, title: "제목")
    /// ```
    public struct TitleView: View {
        let variant: Variant
        let title: String

        public init(
            variant: Variant = .normal,
            title: String
        ) {
            self.variant = variant
            self.title = title
        }
        
        public var body: some View {
            Text(title)
                .paragraph(
                    variant: variant.typoVariant,
                    weight: variant.typoWeight,
                    semantic: .labelStrong
                )
                .lineLimit(1)
        }
    }
    
    /// 내비게이션 바의 왼쪽(leading) 영역에 위치하는 기본 버튼입니다.
    ///
    /// 뒤로가기, 아이콘 버튼, 텍스트 버튼 등의 다양한 형태를 지원하며,
    /// 배경 및 대체 스타일도 옵션으로 제공합니다.
    ///
    /// ```swift
    /// LeadingButton(
    ///     .back { dismiss() },
    ///     true,   // alternative 스타일
    ///     false   // background 없음
    /// )
    /// ```
    ///
    /// 버튼이 없을 경우에는 투명한 공간을 차지하여 레이아웃이 유지됩니다.
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
    
    /// 내비게이션 바의 오른쪽(trailing)에 위치하는 텍스트 버튼입니다.
    ///
    /// 배경이 있는 스타일과 없는 스타일을 모두 지원하며,
    /// alternative 색상 스타일 및 disable 처리도 가능합니다.
    ///
    /// ```swift
    /// TrailingTextButton(
    ///     text: "확인",
    ///     background: true,
    ///     alternative: false,
    ///     disable: false
    /// ) {
    ///     // 버튼 액션
    /// }
    /// ```
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
                            .paragraph(
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
                    .disabled(disable)
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
    
    /// 내비게이션 바의 오른쪽(trailing)에 위치하는 아이콘 버튼입니다.
    ///
    /// 배경 스타일, alternative 색상, 비활성화(disable), 푸시 뱃지 등을 옵션으로 설정할 수 있습니다.
    ///
    /// ```swift
    /// TrailingIconButton(
    ///     icon: .bell,
    ///     background: true,
    ///     alternative: false,
    ///     showPushBadge: true
    /// ) {
    ///     // 버튼 액션
    /// }
    /// ```
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
    /// TopNavigation
    ///     .variant(.floating())
    ///     .title { ... }
    /// ```
    public enum Variant: Equatable {
        /// 기본 내비게이션 바 스타일
        case normal
        /// 확장된 내비게이션 바 스타일 (제목이 별도의 줄에 표시됨)
        case extended
        /// 플로팅 스타일의 내비게이션 바
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
        /// TopNavigation()
        ///     .leadingContent: { /* ... */ }
        ///
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
        ///     .trailingContents(
        ///         { TopNavigation.TrailingIconButton(icon: .search) { /* ... */ } },
        ///         { TopNavigation.TrailingTextButton(text: "완료") { /* ... */ } }
        ///     )
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
                switch (lhs, rhs) {
                case let (.icon(li, ld, ls, _), .icon(ri, rd, rs, _)):
                    return li == ri && ld == rd && ls == rs
                case let (.text(lt, ld, _), .text(rt, rd, _)):
                    return lt == rt && ld == rd
                default:
                    return false
                }
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
    ///             title: {
    ///                 TopNavigation.TitleView(title: "제목")
    ///             },
    ///             leadingContent: {
    ///                 TopNavigation.LeadingButton(.back(action: {}))
    ///             },
    ///             trailingContents: [
    ///                 {
    ///                     TopNavigation.TrailingIconButton(icon: .bell, action: {})
    ///                 }
    ///                 ...
    ///             ]
    ///         )
    ///     )
    /// ```
    struct TopNavigationModifier: ViewModifier {
        private let variant: Variant
        private let title: (() -> AnyView)
        private let backgroundColor: SwiftUI.Color?
        private let leadingContent: (() -> AnyView)
        private let trailingContents: [() -> AnyView]
        private let actionAreaModel: ActionArea.Model?
        
        /// TopNavigationModifier를 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 내비게이션 바의 외관 스타일
        ///   - title: 제목 영역
        ///   - backgroundColor: 배경색
        ///   - leadingContent: 좌측에 표시할 컴포넌트
        ///   - trailingContents: 우측에 표시할 컴포넌트 배열
        ///   - actionAreaModel: 액션 영역 모델
        init(
            variant: Variant,
            title: (() -> AnyView)? = nil,
            backgroundColor: SwiftUI.Color? = nil,
            leadingContent: (() -> AnyView)? = nil,
            trailingContents: [() -> AnyView] = [],
            actionAreaModel: ActionArea.Model? = nil
        ) {
            self.variant = variant
            self.title = title ?? { AnyView(EmptyView()) }
            self.backgroundColor = backgroundColor
            self.leadingContent = leadingContent ?? { AnyView(EmptyView()) }
            self.trailingContents = Array(trailingContents.prefix(3))
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
                            scrollOffset: scrollStatus.contentOffset.y,
                            backgroundColor: backgroundColor
                        )
                        .variant(variant)
                        .title { title() }
                        .leadingContent { leadingContent() }
                        .trailingContents(trailingContents)
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
    ///   - title: 표시할 제목 컴포넌트 클로저 (기본값: nil)
    ///   - backgroundColor: 배경색 (기본값: nil)
    ///   - leadingContent: 좌측에 표시할 컴포넌트 클로저 (기본값: nil)
    ///   - trailingContents: 우측에 표시할 컴포넌트 클로저 (기본값: [])
    ///   - model: 하단 액션 영역에 대한 모델 (기본값: nil)
    /// - Returns: TopNavigation이 적용된 뷰
    public func topNavigation(
        variant: TopNavigation.Variant = .normal,
        title: (() -> any View)? = nil,
        backgroundColor: SwiftUI.Color? = nil,
        leadingContent: (() -> any View)? = nil,
        trailingContents: [() -> any View] = [],
        withBottom model: ActionArea.Model? = nil
    ) -> some View {
        modifier(
            TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title.map { v in { AnyView(v()) } },
                backgroundColor: backgroundColor,
                leadingContent: leadingContent.map { v in { AnyView(v()) } },
                trailingContents: trailingContents.prefix(3).map { v in { AnyView(v()) } },
                actionAreaModel: model
            )
        )
    }

    /// 현재 뷰에 TopNavigation 바를 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 내비게이션 바의 외관 스타일 (기본값: .normal)
    ///   - title: 표시할 텍스트 타이틀 (기본값: nil)
    ///   - backgroundColor: 배경색 (기본값: nil)
    ///   - leadingContent: 좌측에 표시할 컴포넌트 클로저 (기본값: nil)
    ///   - trailingContents: 우측에 표시할 컴포넌트 클로저 (기본값: [])
    ///   - model: 하단 액션 영역에 대한 모델 (기본값: nil)
    /// - Returns: TopNavigation이 적용된 뷰
    public func topNavigation(
        variant: TopNavigation.Variant = .normal,
        title: String,
        backgroundColor: SwiftUI.Color? = nil,
        leadingContent: (() -> any View)? = nil,
        trailingContents: [() -> any View] = [],
        withBottom model: ActionArea.Model? = nil
    ) -> some View {
        modifier(
            TopNavigation.TopNavigationModifier(
                variant: variant,
                title:  { AnyView(TopNavigation.TitleView(variant: variant, title: title)) },
                backgroundColor: backgroundColor,
                leadingContent: leadingContent.map { v in { AnyView(v()) } },
                trailingContents: trailingContents.prefix(3).map { v in { AnyView(v()) } },
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
