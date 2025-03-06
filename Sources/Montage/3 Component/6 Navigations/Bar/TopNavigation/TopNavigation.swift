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
        private let left: Resource.Left?
        private let backgroundColorResolvable: ColorResolvable?
        private let actions: [Resource.Action]
        
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
            left: Resource.Left? = nil,
            backgroundColorResolvable: ColorResolvable? = nil,
            actions: [Resource.Action] = []
        ) {
            self.variant = variant
            self.title = title
            self.scrollOffset = scrollOffset
            self.left = left
            self.backgroundColorResolvable = backgroundColorResolvable
            self.actions = Array(actions.prefix(3))
        }
        
        public var body: some View {
            ZStack(alignment: .bottom) {
                Contents(
                    variant: variant,
                    title: title,
                    left: left,
                    actions: actions
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
            @State private var leftSize: CGSize = .zero
            @State private var actionSize: CGSize = .zero
            @State private var screenWidth: CGFloat = 0
            
            var variant: Variant
            var title: String
            var left: Resource.Left? = nil
            var actions: [Resource.Action]

            private var titleSize: CGFloat {
                let componentSize: CGFloat = max(leftSize.width, actionSize.width)
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
                            NormalLeft(left)
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { leftSize = $0 }
                                )
                            Spacer()
                            NormalAction(actions)
                                .onGeometryChange(
                                    for: CGSize.self,
                                    of: { $0.size },
                                    action: { actionSize = $0 }
                                )
                        }
                        titleView
                            .frame(width: titleSize, height: 24)
                    case .extended:
                        VStack(spacing: 20) {
                            HStack {
                                ExtendedLeft(left)
                                Spacer()
                                ExtendedAction(actions)
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
                                FloatingLeft(left, alternative, background)
                                    .onGeometryChange(
                                        for: CGSize.self,
                                        of: { $0.size },
                                        action: { leftSize = $0 }
                                    )
                                Spacer()
                                FloatingAction(actions, alternative, background)
                                    .onGeometryChange(
                                        for: CGSize.self,
                                        of: { $0.size },
                                        action: { actionSize = $0 }
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
        
        struct NormalLeft: View {
            let left: Resource.Left?
            
            init(_ left: Resource.Left?) {
                self.left = left
            }
            
            var body: some View {
                if let left {
                    Group {
                        switch left {
                        case .back(let action):
                            Button.IconButton(icon: .chevronLeft) {
                                action()
                            }
                            .frame(width: 24, height: 24)
                        case let .icon(i, action):
                            Button.IconButton(icon: i) {
                                action()
                            }
                            .frame(width: 24, height: 24)
                        case let .text(t, action):
                            Button.TextButton(
                                text: t,
                                contentColor: .alias(.labelNormal)
                            ) {
                                action()
                            }
                            .frame(height: 24)
                        }
                    }
                } else {
                    SwiftUI.Color.clear
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        struct NormalAction: View {
            let actions: [Resource.Action]
            
            init(_ actions: [Resource.Action]) {
                self.actions = actions
            }
            
            var body: some View {
                if actions.isEmpty == false {
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(actions, id: \.self) {
                            switch $0 {
                            case let .icon(i, s, action):
                                Button.IconButton(icon: i, showPushBadge: s) {
                                    action()
                                }
                                .frame(width: 24, height: 24)
                            case let .text(t, action):
                                Button.TextButton(
                                    text: t,
                                    contentColor: .alias(.labelNormal)
                                ) {
                                    action()
                                }
                                .frame(height: 24)
                            }
                        }
                    }
                } else {
                    SwiftUI.Color.clear
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        struct ExtendedLeft: View {
            let left: Resource.Left?
            
            init(_ left: Resource.Left?) {
                self.left = left
            }
            
            var body: some View {
                if let left {
                    Group {
                        switch left {
                        case .back(let action):
                            Button.IconButton(icon: .chevronLeft) {
                                action()
                            }
                            .frame(width: 24, height: 24)
                        case let .icon(i, action):
                            Button.IconButton(icon: i) {
                                action()
                            }
                            .frame(width: 24, height: 24)
                        case let .text(t, action):
                            Button.TextButton(
                                text: t,
                                contentColor: .alias(.labelNormal)
                            ) {
                                action()
                            }
                            .frame(height: 24)
                        }
                    }
                } else {
                    SwiftUI.Color.clear
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        struct ExtendedAction: View {
            private let actions: [Resource.Action]
            
            init(_ actions: [Resource.Action]) {
                self.actions = actions
            }
            
            var body: some View {
                if actions.isEmpty == false {
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(actions, id: \.self) {
                            switch $0 {
                            case let .icon(i, s, action):
                                Button.IconButton(icon: i, showPushBadge: s) {
                                    action()
                                }
                                .frame(width: 24, height: 24)
                            case let .text(t, action):
                                Button.TextButton(
                                    text: t,
                                    contentColor: .alias(.labelNormal)
                                ) {
                                    action()
                                }
                                .frame(height: 24)
                            }
                        }
                    }
                } else {
                    SwiftUI.Color.clear
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        private struct FloatingLeft: View {
            let left: Resource.Left?
            let alternative: Bool
            let background: Bool
            
            init(
                _ left: Resource.Left?,
                _ alternative: Bool,
                _ background: Bool
            ) {
                self.left = left
                self.alternative = alternative
                self.background = background
            }
            
            var body: some View {
                if let left {
                    switch left {
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
                        SwiftUI.Button {
                            action()
                        } label: {
                            Text(t)
                                .montage(
                                    variant: background ? .headline2 : .body2,
                                    weight: .medium,
                                    alias: background
                                        ? .labelNormal
                                        : (alternative ? .staticWhite : .labelAlternative)
                                )
                                .if(background) {
                                    $0.paragraph(variant: .body2)
                                        .if(alternative) {
                                            $0.opacity(0.88)
                                        } else: {
                                            $0.blendMode(.plusDarker)
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                } else: {
                                    $0
                                }
                        }
                        .modifying { original in
                            Group {
                                if background {
                                    Group {
                                        if alternative {
                                            original
                                                .background(
                                                    SwiftUI.Color.atomic(.globalCoolNeutral30)
                                                        .opacity(0.61)
                                                )
                                        } else {
                                            original.background(.regularMaterial)
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                                } else {
                                    original
                                }
                            }
                        }
                        .frame(height: 24)
                    }
                } else {
                    SwiftUI.Color.clear
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        private struct FloatingAction: View {
            let actions: [Resource.Action]
            let alternative: Bool
            let background: Bool
            
            init(
                _ actions: [Resource.Action],
                _ alternative: Bool,
                _ background: Bool
            ) {
                self.actions = actions
                self.alternative = alternative
                self.background = background
            }

            var body: some View {
                if actions.isEmpty == false {
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(actions, id: \.self) {
                            switch $0 {
                            case let .icon(i, s, action):
                                ActionIcon(i, s, alternative, background, action)
                                    .frame(width: 24, height: 24)
                            case let .text(t, action):
                                if background {
                                    SwiftUI.Button {
                                        action()
                                    } label: {
                                        ActionText(t, alternative)
                                    }
                                    .frame(height: 24)
                                } else {
                                    SwiftUI.Button {
                                        action()
                                    } label: {
                                        Text(t)
                                            .montage(
                                                variant: .headline2,
                                                weight: .medium,
                                                alias: .labelNormal
                                            )
                                    }
                                    .frame(height: 24)
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            
            private struct ActionIcon: View {
                let i: Icon
                let showPushBadge: Bool
                let alternative: Bool
                let background: Bool
                let action: () -> Void
                
                init(
                    _ i: Icon,
                    _ showPushBadge: Bool,
                    _ alternative: Bool,
                    _ background: Bool,
                    _ action: @escaping (() -> Void)
                ) {
                    self.i = i
                    self.showPushBadge = showPushBadge
                    self.alternative = alternative
                    self.background = background
                    self.action = action
                }
                
                private var variant: Button.IconButton.Variant {
                    background ? .background(size: 24, isAlternative: alternative) : .default
                }
                
                var body: some View {
                    Button.IconButton(
                        variant: variant,
                        icon: i,
                        showPushBadge: showPushBadge
                    ) {
                        action()
                    }
                }
            }
            
            private struct ActionText: View {
                let t: String
                let alternative: Bool
                
                init(_ t: String, _ alternative: Bool) {
                    self.t = t
                    self.alternative = alternative
                }

                var body: some View {
                    Group {
                        if alternative {
                            text()
                                .background(
                                    SwiftUI.Color.atomic(.globalCoolNeutral30).opacity(0.61)
                                )
                        } else {
                            text()
                                .background(
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
                
                @ViewBuilder
                private func text() -> some View {
                    Text(t)
                        .montage(
                            variant: .body2,
                            weight: .medium,
                            alias: alternative ? .staticWhite : .labelAlternative
                        )
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
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
        public enum Left: CaseDescribable {
            case back(action: () -> Void)
            case icon(Icon, action: () -> Void)
            case text(String, action: () -> Void)
        }
        
        /// TopNavigation의 우측에 표시될 내용들의 열거형입니다.
        public enum Action: Hashable {
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
                lhs: Bar.TopNavigation.Resource.Action,
                rhs: Bar.TopNavigation.Resource.Action
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
        private let left: Resource.Left?
        private let actions: [Resource.Action]
        private let backgroundColorResolvable: ColorResolvable?
        private let actionAreaModel: ActionAreaModifier.Model?
        
        public init(
            variant: Variant,
            title: String,
            showIndicator: Bool = true,
            left: Resource.Left?,
            backgroundColorResolvable: ColorResolvable? = nil,
            actions: [Resource.Action],
            actionAreaModel: ActionAreaModifier.Model? = nil
        ) {
            self.variant = variant
            self.title = title
            self.showIndicator = showIndicator
            self.left = left
            self.backgroundColorResolvable = backgroundColorResolvable
            self.actions = actions
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
                            left: left,
                            backgroundColorResolvable: backgroundColorResolvable,
                            actions: actions
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
