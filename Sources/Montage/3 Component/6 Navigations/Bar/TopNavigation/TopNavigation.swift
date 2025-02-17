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
        
        /// TopNavigation이 노출될 screenWidth입니다.
        @State private var screenWidth: CGFloat = .zero
        
        private let variant: Variant
        private let title: String
        private let scrollOffset: CGFloat
        private let left: Resource.Left?
        private let backgroundColorResolvable: ColorResolvable?
        private let actions: [Resource.Action]
        
        // MARK: - Computed properties
        
        private var screenWidthMeasurer: some View {
            GeometryReader { proxy in
                SwiftUI.Color.clear
                    .onAppear {
                        screenWidth = proxy.size.width
                    }
            }
        }

        private var scrolled: Bool { scrollOffset < .zero }
        private var isFloatingVariant: Bool {
            switch variant {
            case .floating: return true
            case .normal: fallthrough
            case .extended: return false
            }
        }
        
        private var needMaterial: Bool {
            scrolled && isFloatingVariant == false && (scrollOffset / -33) > 1
        }
        
        private var backgroundColor: SwiftUI.Color {
            if let backgroundColorResolvable {
                .init(uiColor: backgroundColorResolvable.resolve(.current)).opacity(0.88)
            } else {
                SwiftUI.Color.alias(.backgroundNormal).opacity(0.88)
            }
        }
        
        private var backgroundOpacity: CGFloat {
            let ratio = (scrollOffset / -32)
            return ratio > 1 ? 1 : ratio
        }

        // MARK: - Initialisers
       
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
                    screenWidth: $screenWidth,
                    variant: variant,
                    title: title,
                    left: left,
                    actions: actions
                )
                .padding(.all, 16)
                .background(
                    (scrolled && isFloatingVariant == false) ? backgroundColor
                        .opacity(backgroundOpacity) : .clear
                )
                .background(
                    (scrolled && isFloatingVariant == false) ?
                        Material.ultraThinMaterial.opacity(backgroundOpacity)
                        : Material.ultraThinMaterial.opacity(.zero)
                )
                .background(
                    screenWidthMeasurer
                )
                if scrolled && isFloatingVariant == false {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.alias(.lineNeutral).opacity(backgroundOpacity))
                        .frame(width: screenWidth, height: 0.5)
                }
            }
        }
        
        struct Contents: View {
            @State private var leftSize: CGSize = .zero
            @State private var actionSize: CGSize = .zero
            @Binding var screenWidth: CGFloat
            
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
            
            private var leftSizeMeasuerer: some View {
                GeometryReader { proxy in
                    SwiftUI.Color.clear
                        .onAppear {
                            leftSize = proxy.size
                        }
                }
            }
            
            private var actionSizeMeasurer: some View {
                GeometryReader { proxy in
                    SwiftUI.Color.clear
                        .onAppear {
                            actionSize = proxy.size
                        }
                }
            }
            
            var body: some View {
                switch variant {
                case .normal: 
                    ZStack {
                        HStack(spacing: .zero) {
                            NormalLeft(left)
                                .background(
                                    leftSizeMeasuerer
                                )
                            Spacer()
                            NormalAction(actions)
                                .background(
                                    actionSizeMeasurer
                                )
                        }
                        Text(title)
                            .montage(
                                variant: variant.typoVaraint,
                                weight: variant.typoWeight,
                                alias: .labelStrong
                            )
                            .paragraph(variant: variant.typoVaraint)
                            .lineLimit(1)
                            .frame(width: titleSize, height: 24)
                    }
                case .extended:
                    VStack(spacing: 20) {
                        HStack {
                            ExtendedLeft(left)
                            Spacer()
                            ExtendedAction(actions)
                        }
                        HStack {
                            Text(title)
                                .montage(
                                    variant: variant.typoVaraint,
                                    weight: variant.typoWeight,
                                    alias: .labelStrong
                                )
                                .paragraph(variant: variant.typoVaraint)
                                .lineLimit(1)
                                .frame(alignment: variant.textAlignment)
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                    }
                case let .floating(alternative, background):
                    HStack(spacing: .zero) {
                        FloatingLeft(left, alternative, background)
                        Spacer()
                        FloatingAction(actions, alternative, background)
                    }
                    .frame(height: 24)
                }
            }
        }
        
        private struct NormalLeft: View {
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
        
        private struct NormalAction: View {
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
                            .padding(.vertical, 4)
                        }
                    }
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
                            case let .text(t, action):
                                Button.TextButton(
                                    text: t,
                                    contentColor: .alias(.labelNormal)
                                ) {
                                    action()
                                }
                            }
                        }
                    }
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
                    Group {
                        if background {
                            if alternative {
                                switch left {
                                case .back(let action):
                                    Button.IconButton(
                                        variant: .background(size: 24, isAlternative: alternative),
                                        icon: .chevronLeftThick
                                    ) {
                                        action()
                                    }
                                case let .icon(i, action):
                                    Button.IconButton(
                                        variant: .background(size: 24, isAlternative: alternative),
                                        icon: i
                                    ) {
                                        action()
                                    }
                                case let .text(t, action):
                                    SwiftUI.Button {
                                        action()
                                    } label: {
                                        Text(t)
                                            .montage(variant: .body2, weight: .medium, alias: .staticWhite)
                                            .paragraph(variant: .body2)
                                            .opacity(0.88)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                    }
                                    .background(
                                        SwiftUI.Color.atomic(.globalCoolNeutral30).opacity(0.61)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                                }
                            } else {
                                switch left {
                                case .back(let action):
                                    Button.IconButton(
                                        variant: .background(size: 24, isAlternative: alternative),
                                        icon: .chevronLeftThick
                                    ) {
                                        action()
                                    }
                                case let .icon(i, action):
                                    Button.IconButton(
                                        variant: .background(size: 24, isAlternative: alternative),
                                        icon: i
                                    ) {
                                        action()
                                    }
                                case let .text(t, action):
                                    SwiftUI.Button {
                                        action()
                                    } label: {
                                        Text(t)
                                            .montage(
                                                variant: .body2,
                                                weight: .medium,
                                                alias: .labelAlternative
                                            )
                                            .blendMode(.plusDarker)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                    }
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                                }
                            }
                        } else {
                            switch left {
                            case .back(let action):
                                Button.IconButton(
                                    variant: .default,
                                    icon: .chevronLeftThick
                                ) {
                                    action()
                                }
                            case let .icon(i, action):
                                Button.IconButton(
                                    variant: .default,
                                    icon: i
                                ) {
                                    action()
                                }
                            case let .text(t, action):
                                SwiftUI.Button {
                                    action()
                                } label: {
                                    Text(t)
                                        .montage(variant: .headline2, weight: .medium, alias: .labelNormal)
                                }
                            }
                        }
                    }
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
                            case let .text(t, action):
                                if background {
                                    SwiftUI.Button {
                                        action()
                                    } label: {
                                        ActionText(t, alternative)
                                    }
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
        case floating(alternative: Bool = false, background: Bool = true)
    }
    
    /// TopNavigation의 좌/우에 표시될 Resource들의 Namespace입니다.
    public enum Resource {
        /// TopNavigation의 좌측에 표시될 내용들의 열거형입니다.
        public enum Left {
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
        case .floating: .regular
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
        @Environment(\.safeAreaInsets) private var safeAreaInsets

        @State private var scrollOffset: CGFloat = .zero
        @State private var containerSize: CGSize = .zero
        @State private var innerContentSize: CGSize = .zero
        @State private var navigationHeight: CGFloat = .zero
        @State private var originBottomActionHeight: CGFloat = .zero
        @State private var currentBottomActionHeight: CGFloat = .zero
        @State private var isBottomActionAreaSticky: Bool

        private let variant: Variant
        private let title: String
        private let showIndicator: Bool
        private let left: Resource.Left?
        private let actions: [Resource.Action]
        private let backgroundColorResolvable: ColorResolvable?
        private let model: ActionArea.Model?

        /// 무시할 SafeAreaEdge입니다.
        /// > ActionArea/Bottom이 존재하는 경우에 bottom SafeArea를 무시합니다.
        private var ignoreSafeAreaEdge: Edge.Set {
            model != nil ? .bottom : []
        }

        /// Scroll 영역 전체에 삽입될 background 입니다.
        /// > backgroundColorResolvable을 전달한 경우에 해당 컬러가 background에 적용되며,
        /// > backgroundColorResolvable가 없는 경우 .clear 컬러가 적용됩니다.
        private var backgroundColor: SwiftUI.Color {
            if let backgroundColorResolvable {
                .init(uiColor: backgroundColorResolvable.resolve(.current))
            } else {
                .clear
            }
        }

        /// Scroll 영역이 가지는 bottom padding입니다.
        ///
        /// Scroll 영역이 ActionArea/Bottom에 가려지는것을 방지하기 위해 사용합니다.
        /// > ActionArea/Bottom과 함께 사용하는 경우에 ActionArea/Bottom의 variant에 의해 결정됩니다.
        private var scrollViewBottomPadding: CGFloat {
            if model != nil {
                currentBottomActionHeight + (model?.variant == .extra ? +10 : .zero)
            } else {
                .zero
            }
        }
        
        public init(
            variant: Variant,
            title: String,
            showIndicator: Bool = true,
            left: Resource.Left?,
            backgroundColorResolvable: ColorResolvable? = nil,
            actions: [Resource.Action],
            model: ActionArea.Model? = nil
        ) {
            self.variant = variant
            self.title = title
            self.showIndicator = showIndicator
            self.left = left
            self.backgroundColorResolvable = backgroundColorResolvable
            self.actions = actions
            self.model = model

            isBottomActionAreaSticky = model != nil ? true : false
        }
        
        public func body(content: Content) -> some View {
            ZStack {
                ScrollView {
                    GeometryReader { proxy in
                        SwiftUI.Color.clear.preference(
                            key: OffsetPreferenceKey.self,
                            value: proxy.frame(
                                in: .named("ScrollViewOrigin")
                            ).origin
                        )
                    }
                    .frame(width: 0, height: 0)
                    content
                        .onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { innerContentSize = $0 }
                        )
                        .padding(.top, navigationHeight)
                }
                .padding(.bottom, scrollViewBottomPadding)
                .background(
                    backgroundColor
                )
                .coordinateSpace(name: "ScrollViewOrigin")
                .onPreferenceChange(
                    OffsetPreferenceKey.self,
                    perform: {
                        scrollOffset = $0.y
                        calculateSticky()
                    }
                )
                VStack(alignment: .leading, spacing: .zero) {
                    Bar.TopNavigation(
                        variant: variant,
                        title: title,
                        scrollOffset: scrollOffset,
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
                if let model {
                    VStack(alignment: .leading, spacing: .zero) {
                        Spacer()
                        ActionArea.Component(
                            model: .init(
                                variant: model.variant,
                                priority: model.priority,
                                sticky: isBottomActionAreaSticky,
                                caption: model.caption,
                                extraContents: model.extraContents
                            )
                        )
                        .onGeometryChange(
                            for: CGFloat.self,
                            of: { $0.size.height },
                            action: {
                                currentBottomActionHeight = $0
                                originBottomActionHeight = $0
                            }
                        )
                        .onChange(
                            of: isBottomActionAreaSticky,
                            perform: { isSticky in
                                currentBottomActionHeight += isSticky ? -20 : +20
                            }
                        )
                        .animation(.easeInOut, value: isBottomActionAreaSticky)
                    }
                }
            }
            .ignoresSafeArea(.container, edges: ignoreSafeAreaEdge)
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { containerSize = $0 })
        }
    }
}

extension Bar.TopNavigation.TopNavigationModifier {
    /// 스크롤 offset에 따른 sticky 판단
    /// > 기본적으로 스크롤이 컨텐츠의 끝(전체 컨텐츠 크기 - offset)에 도달했을 때 sticky를 사용하지 않습니다.
    private func calculateSticky() {
        // ActionArea의 추가 영역
        let actionAreaExtraArea: CGFloat = (model?.variant == .extra) ? 70 : .zero
        // 전체 컨텐츠 크기 (내부 컨텐츠 사이즈 + ActionArea + (스티키인 경우 gradient 영역))
        let totalContentHeight = innerContentSize.height + originBottomActionHeight
        // 계산하기 편리하게 처리된 현재 스크롤 Offset
        let currentScrollOffsetForCalculate = containerSize.height + abs(scrollOffset.rounded())

        let newValue = totalContentHeight - actionAreaExtraArea >= currentScrollOffsetForCalculate
        guard isBottomActionAreaSticky != newValue else { return }
        isBottomActionAreaSticky = newValue
    }
}

struct TopNavigation_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Bar.TopNavigation(
                title: "제목"
            )
            Divider()
            
            Bar.TopNavigation(
                title: "제목",
                left: .text("행동", action: {})
            )
            .background(SwiftUI.Color.teal)
            Divider()
            
            Bar.TopNavigation(
                title: "제목",
                left: .back(action: {})
            )
            .background(SwiftUI.Color.green)
            
            Bar.TopNavigation(
                variant: .floating(),
                title: "제목",
                left: .back(action: {}),
                actions: [
                    .text("행동", action: {}),
                    .text("행동", action: {}),
                ]
            )
            .background(SwiftUI.Color.red)
            
            Bar.TopNavigation(
                variant: .floating(),
                title: "제목",
                left: .text("뒤로", action: {}),
                actions: [
                    .text("행동", action: {}),
                    .text("행동", action: {}),
                ]
            )
            Divider()
            
            Bar.TopNavigation(
                title: "제목",
                left: .back(action: {}),
                actions: [
                    .icon(.android, action: {}),
                    .icon(.android, action: {}),
                    .icon(.android, action: {}),
                ]
            )
            Bar.TopNavigation(
                title: "제목",
                left: .back(action: {}),
                actions: [
                    .text("행동", action: {})
                ]
            )
            
            Divider()
            
            Bar.TopNavigation(
                variant: .extended,
                title: "제목",
                left: .back(action: {})
            )
            .background(SwiftUI.Color.yellow)
            Bar.TopNavigation(
                variant: .extended,
                title: "제목dasfsdasdasdhadjahshdashdkahkjhfajsadhhkfjash",
                left: .back(action: {}),
                actions: [.text("행동", action: {})]
            )

            Divider()
            
            Bar.TopNavigation(
                variant: .floating(),
                title: "제목",
                left: .back(action: {})
            )
            Bar.TopNavigation(
                variant: .floating(),
                title: "제목",
                left: .back(action: {}),
                actions: [
                    .text("행동", action: {}),
                    .text("행동", action: {}),
                ]
            )
            Bar.TopNavigation(
                variant: .floating(alternative: true),
                title: "제목",
                left: .back(action: {}),
                actions: [
                    .icon(.android, action: {}),
                    .icon(.android, action: {}),
                    .icon(.android, action: {}),
                ]
            )
        }
    }
}
