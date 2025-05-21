//
//  TopNavigation.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/8/24.
//

import SwiftUI

/// 상단에 표시되는 내비게이션 바 컴포넌트입니다.
///
/// 제목, 뒤로가기 버튼, 추가 액션 버튼 등을 포함할 수 있으며, 다양한 외관 스타일을 지원합니다.
/// 스크롤 시 배경색과 구분선의 불투명도가 자동으로 조절됩니다.
///
/// ```swift
/// TopNavigation(
///     variant: .normal,
///     title: "제목",
///     leadingButton: .back {
///         // 뒤로가기 동작
///     },
///     trailingButtons: [
///         .icon(.search) {
///             // 검색 동작
///         }
///     ]
/// )
/// ```
///
/// - SeeAlso: `TopNavigation.Variant`, `TopNavigation.Resource`
public struct TopNavigation: View {
    // MARK: - Uninitialised properties
    
    private let variant: Variant
    private let title: String
    private let scrollOffset: CGFloat
    private let backgroundColorResolvable: ColorResolvable?
    private let leadingButton: Resource.LeadingButton?
    private let trailingButtons: [Resource.TrailingButton]
    
    // MARK: - Computed properties

    private var scrolled: Bool { scrollOffset < .zero }
    
    private var backgroundColor: SwiftUI.Color {
        if let backgroundColorResolvable {
            .init(uiColor: backgroundColorResolvable.resolve(.current))
        } else {
            SwiftUI.Color.semantic(.backgroundNormal)
        }
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
    ///   - backgroundColorResolvable: 배경색 리졸버
    ///   - leadingButton: 좌측에 표시할 버튼
    ///   - trailingButtons: 우측에 표시할 버튼 배열 (최대 3개까지 표시)
    public init(
        variant: Variant = .normal,
        title: String = "",
        scrollOffset: CGFloat = .zero,
        backgroundColorResolvable: ColorResolvable? = nil,
        leadingButton: Resource.LeadingButton? = nil,
        trailingButtons: [Resource.TrailingButton] = []
    ) {
        self.variant = variant
        self.title = title
        self.scrollOffset = scrollOffset
        self.backgroundColorResolvable = backgroundColorResolvable
        self.leadingButton = leadingButton
        self.trailingButtons = Array(trailingButtons.prefix(3))
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Contents(
                variant: variant,
                title: title,
                leadingButton: leadingButton,
                trailingButtons: trailingButtons
            )
            .padding(.all, 16)
            .background {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial)
                        .opacity(backgroundOpacity)
                    backgroundColor
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
    }
    
    struct Contents: View {
        @State private var leadingButtonSize: CGSize = .zero
        @State private var totalSizeOfTrailingButtons: CGSize = .zero
        @State private var screenWidth: CGFloat = 0
        
        var variant: Variant
        var title: String
        var leadingButton: Resource.LeadingButton? = nil
        var trailingButtons: [Resource.TrailingButton]

        private var titleSize: CGFloat {
            let componentSize: CGFloat = max(leadingButtonSize.width, totalSizeOfTrailingButtons.width)
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
                        LeadingButton(leadingButton)
                            .onGeometryChange(
                                for: CGSize.self,
                                of: { $0.size },
                                action: { leadingButtonSize = $0 }
                            )
                        Spacer()
                        TrailingButtons(trailingButtons)
                            .onGeometryChange(
                                for: CGSize.self,
                                of: { $0.size },
                                action: { totalSizeOfTrailingButtons = $0 }
                            )
                    }
                    titleView
                        .frame(width: titleSize, height: 24)
                case .extended:
                    VStack(spacing: 20) {
                        HStack {
                            LeadingButton(leadingButton)
                            Spacer()
                            TrailingButtons(trailingButtons)
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
                            LeadingButton(leadingButton, alternative, background)
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { leadingButtonSize = $0 }
                                )
                            Spacer()
                            TrailingButtons(trailingButtons, alternative, background)
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { totalSizeOfTrailingButtons = $0 }
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
                .montage(
                    variant: variant.typoVaraint,
                    weight: variant.typoWeight,
                    semantic: .labelStrong
                )
                .paragraph(variant: variant.typoVaraint)
                .lineLimit(1)
        }
    }
    
    struct LeadingButton: View {
        let action: Resource.LeadingButton?
        let alternative: Bool
        let background: Bool
        
        init(
            _ action: Resource.LeadingButton?,
            _ alternative: Bool = false,
            _ background: Bool = false
        ) {
            self.action = action
            self.alternative = alternative
            self.background = background
        }
        
        var body: some View {
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
                            action: action,
                            background: background,
                            alternative: alternative
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
    
    struct TrailingButtons: View {
        let buttons: [Resource.TrailingButton]
        let alternative: Bool
        let background: Bool
        
        init(
            _ buttons: [Resource.TrailingButton],
            _ alternative: Bool = false,
            _ background: Bool = false
        ) {
            self.buttons = buttons
            self.alternative = alternative
            self.background = background
        }

        var body: some View {
            if buttons.isEmpty == false {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(buttons, id: \.self) { button in
                        Group {
                            switch button {
                            case let .icon(i, d, s, action):
                                IconButton(
                                    variant: background ?
                                        .background(size: 24, isAlternative: alternative) : .default,
                                    icon: i
                                ) {
                                    action()
                                }
                                .disable(d)
                                .showPushBadge(s)
                                .frame(width: 24, height: 24)
                            case let .text(t, d, action):
                                TrailingTextButton(
                                    text: t,
                                    action: action,
                                    background: background,
                                    alternative: alternative,
                                    disable: d
                                )
                                .frame(height: 24)
                            }
                        }
                    }
                }
                .contentShape(Rectangle().scale(2), eoFill: true)
            } else {
                SwiftUI.Color.clear
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private struct TrailingTextButton: View {
        private let text: String
        private let action: () -> Void
        private let background: Bool
        private let alternative: Bool
        private let disable: Bool
        
        init(
            text: String,
            action: @escaping () -> Void,
            background: Bool,
            alternative: Bool,
            disable: Bool = false
        ) {
            self.text = text
            self.action = action
            self.background = background
            self.alternative = alternative
            self.disable = disable
        }

        var body: some View {
            if background {
                SwiftUI.Button {
                    action()
                } label: {
                    Text(text)
                        .montage(
                            variant: .body2,
                            weight: .medium,
                            semantic: disable ? .labelDisable : (alternative ? .staticWhite : .labelAlternative)
                        )
                        .paragraph(variant: .body2)
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
        public enum LeadingButton {
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
        public enum TrailingButton: Hashable {
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
                case let .icon(i, d, _, _):
                    hasher.combine(i)
                    hasher.combine(d)
                case let .text(t, d, _):
                    hasher.combine(t)
                    hasher.combine(d)
                }
            }
            
            public static func == (
                lhs: TopNavigation.Resource.TrailingButton,
                rhs: TopNavigation.Resource.TrailingButton
            ) -> Bool {
                lhs.hashValue == rhs.hashValue
            }
        }
    }
}

extension TopNavigation.Variant {
    var typoVaraint: Typography.Variant {
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
        private let backgroundColorResolvable: ColorResolvable?
        private let leadingButton: Resource.LeadingButton?
        private let trailingButtons: [Resource.TrailingButton]
        private let actionAreaModel: ActionArea.Model?
        
        /// TopNavigationModifier를 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 내비게이션 바의 외관 스타일
        ///   - title: 표시할 제목
        ///   - showIndicator: 인디케이터 표시 여부
        ///   - backgroundColorResolvable: 배경색 리졸버
        ///   - leadingButton: 좌측에 표시할 버튼
        ///   - trailingButtons: 우측에 표시할 버튼 배열
        ///   - actionAreaModel: 액션 영역 모델
        init(
            variant: Variant,
            title: String,
            showIndicator: Bool = true,
            backgroundColorResolvable: ColorResolvable? = nil,
            leadingButton: Resource.LeadingButton?,
            trailingButtons: [Resource.TrailingButton],
            actionAreaModel: ActionArea.Model? = nil
        ) {
            self.variant = variant
            self.title = title
            self.showIndicator = showIndicator
            self.backgroundColorResolvable = backgroundColorResolvable
            self.leadingButton = leadingButton
            self.trailingButtons = trailingButtons
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
                        backgroundColor
                    )
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        TopNavigation(
                            variant: variant,
                            title: title,
                            scrollOffset: scrollStatus.contentOffset.y,
                            backgroundColorResolvable: backgroundColorResolvable,
                            leadingButton: leadingButton,
                            trailingButtons: trailingButtons
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
        
        private var backgroundColor: SwiftUI.Color {
            if let backgroundColorResolvable {
                .init(uiColor: backgroundColorResolvable.resolve(.current))
            } else {
                .clear
            }
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
    ///   - backgroundColorResolvable: 배경색 리졸버 (기본값: nil)
    ///   - leadingButton: 좌측에 표시할 버튼 (기본값: nil)
    ///   - trailingButtons: 우측에 표시할 버튼 배열 (기본값: [])
    ///   - model: 하단 액션 영역에 대한 모델 (기본값: nil)
    /// - Returns: TopNavigation이 적용된 뷰
    public func topNavigation(
        variant: TopNavigation.Variant = .normal,
        title: String,
        backgroundColorResolvable: ColorResolvable? = nil,
        leadingButton: TopNavigation.Resource.LeadingButton? = nil,
        trailingButtons: [TopNavigation.Resource.TrailingButton] = [],
        withBottom model: ActionArea.Model? = nil
    ) -> some View {
        modifier(
            TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title,
                backgroundColorResolvable: backgroundColorResolvable,
                leadingButton: leadingButton,
                trailingButtons: trailingButtons,
                actionAreaModel: model
            )
        )
    }
}
