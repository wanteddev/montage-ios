//
//  TopNavigation.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/8/24.
//

import SwiftUI

extension Bar {
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
                SwiftUI.Color.alias(.backgroundNormal)
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
                        .foregroundStyle(SwiftUI.Color.alias(.lineNeutral).opacity(backgroundOpacity))
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
                        alias: .labelStrong
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
                    switch action {
                    case .back(let action):
                        Button.IconButton(
                            variant: background
                                ? .background(size: 24, isAlternative: alternative)
                                : .default,
                            icon: background ? .chevronLeftThick : .chevronLeft
                        ) {
                            action()
                        }
                        .frame(width: 24, height: 24)
                    case let .icon(i, action):
                        Button.IconButton(
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
                                case let .icon(i, s, action):
                                    Button.IconButton(
                                        variant: background ?
                                            .background(size: 24, isAlternative: alternative) : .default,
                                        icon: i,
                                        showPushBadge: s
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
                        }
                    }
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
            
            init(text: String, action: @escaping () -> Void, background: Bool, alternative: Bool) {
                self.text = text
                self.action = action
                self.background = background
                self.alternative = alternative
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
                                alias: alternative ? .staticWhite : .labelAlternative
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
                                            SwiftUI.Color.atomic(.globalCoolNeutral30)
                                                .opacity(0.61)
                                        )
                                    } else {
                                        original.background(
                                            ZStack {
                                                SwiftUI.Color.alias(.staticBlack)
                                                    .opacity(0.05)
                                                SwiftUI.Color.alias(.staticWhite)
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
                    Button.TextButton(
                        text: text,
                        contentColor: .alias(.labelNormal),
                        fontVariant: .headline2,
                        fontWeight: .regular
                    ) {
                        action()
                    }
                }
            }
        }
    }
}

extension Bar.TopNavigation {
    /// TopNavigation의 외관을 결정하는 열거형입니다.
    public enum Variant: Equatable {
        case normal
        case extended
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
        public enum LeadingButton: CaseDescribable {
            case back(action: () -> Void)
            case icon(Icon, action: () -> Void)
            case text(String, action: () -> Void)
        }
        
        /// TopNavigation의 우측에 표시될 내용들의 열거형입니다.
        public enum TrailingButton: Hashable {
            /// icon 형태의 Action입니다.
            /// - Parameters:
            ///  - showPushBadge: PushBadge의 노출 여부를 결정합니다. 기본값은 false입니다.
            ///  - action: icon 클릭시 동작할 action입니다.
            case icon(Icon, showPushBadge: Bool = false, action: () -> Void)
            /// text 형태의 Action입니다.
            /// - Parameters:
            ///  - action: text 클릭시 동작할 action입니다.
            case text(String, action: () -> Void)
            
            public func hash(into hasher: inout Hasher) {
                switch self {
                case let .icon(i, _, _):
                    hasher.combine(i)
                case let .text(t, _):
                    hasher.combine(t)
                }
            }
            
            public static func == (
                lhs: Bar.TopNavigation.Resource.TrailingButton,
                rhs: Bar.TopNavigation.Resource.TrailingButton
            ) -> Bool {
                lhs.hashValue == rhs.hashValue
            }
        }
    }
}

extension Bar.TopNavigation.Variant {
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

extension Bar.TopNavigation {
    public struct TopNavigationModifier: ViewModifier {
        private let variant: Variant
        private let title: String
        private let showIndicator: Bool
        private let backgroundColorResolvable: ColorResolvable?
        private let leadingButton: Resource.LeadingButton?
        private let trailingButtons: [Resource.TrailingButton]
        private let actionAreaModel: ActionAreaModifier.Model?
        
        public init(
            variant: Variant,
            title: String,
            showIndicator: Bool = true,
            backgroundColorResolvable: ColorResolvable? = nil,
            leadingButton: Resource.LeadingButton?,
            trailingButtons: [Resource.TrailingButton],
            actionAreaModel: ActionAreaModifier.Model? = nil
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

        public func body(content: Content) -> some View {
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
                        Bar.TopNavigation(
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
