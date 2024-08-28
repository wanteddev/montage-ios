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
        @State private var screenWidth: CGFloat = {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            return window?.screen.bounds.width ?? .zero
        }()
        
        private let variant: Variant
        private let title: String
        private let scrollOffset: CGFloat
        private let left: Resource.Left?
        private let backgroundColorResolvable: ColorResolvable?
        private let actions: [Resource.Action]
        
        // MARK: - Computed properties
        
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
                return .init(uiColor: backgroundColorResolvable.resolve(.current)).opacity(0.88)
            } else {
                return SwiftUI.Color.alias(.backgroundNormal).opacity(0.88)
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
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    (scrolled && isFloatingVariant == false) ? backgroundColor.opacity(backgroundOpacity) : .clear
                )
                .background(
                    .ultraThinMaterial.opacity(backgroundOpacity)
                )
                .readSize(onChange: { screenWidth = $0.width })
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
                            .montage(variant: variant.typoVaraint, weight: variant.typoWeight, alias: .labelStrong)
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
                                .montage(variant: variant.typoVaraint, weight: variant.typoWeight, alias: .labelStrong)
                                .paragraph(variant: variant.typoVaraint)
                                .lineLimit(1)
                                .frame(alignment: variant.textAlignment)
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                    }
                case .floating(let alternative):
                    ZStack {
                        HStack(spacing: .zero) {
                            FloatingLeft(left, alternative)
                            Spacer()
                            FloatingAction(actions, alternative)
                        }
                    }
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
                    HStack(alignment: .center, spacing: .zero) {
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
            
            init(_ left: Resource.Left?, _ alternative: Bool) {
                self.left = left
                self.alternative = alternative
            }
            
            var body: some View {
                if let left {
                    Group {
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
                                    variant: .background(size: 20, isAlternative: alternative),
                                    icon: .chevronLeftThick
                                ) {
                                    action()
                                }
                                .background(.regularMaterial)
                                .clipShape(Circle())
                            case let .icon(i, action):
                                Button.IconButton(
                                    variant: .background(size: 20, isAlternative: alternative),
                                    icon: i
                                ) {
                                    action()
                                }
                                .background(.thickMaterial)
                                .clipShape(Circle())
                            case let .text(t, action):
                                SwiftUI.Button {
                                    action()
                                } label: {
                                    Text(t)
                                        .montage(variant: .body2, weight: .medium, alias: .labelAlternative)
                                        .paragraph(variant: .body2)
                                        .blendMode(.plusDarker)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                }
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                            }
                        }
                    }
                }
            }
        }
        
        private struct FloatingAction: View {
            let actions: [Resource.Action]
            let alternative: Bool
            
            init(_ actions: [Resource.Action], _ alternative: Bool) {
                self.actions = actions
                self.alternative = alternative
            }
            
            var body: some View {
                if actions.isEmpty == false {
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(actions, id: \.self) {
                            switch $0 {
                            case let .icon(i, s, action):
                                Button.IconButton(
                                    variant: .background(size: 20, isAlternative: alternative),
                                    icon: i,
                                    showPushBadge: s
                                ) {
                                    action()
                                }
                            case let .text(t, action):
                                if alternative {
                                    Button.TextButton(
                                        text: t,
                                        contentColor: .alias(.staticWhite)
                                    ) {
                                        action()
                                    }
                                    .padding(.horizontal, 5)
                                    .background(SwiftUI.Color.atomic(.globalCoolNeutral30).opacity(0.61))
                                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                                } else {
                                    Button.TextButton(
                                        text: t,
                                        contentColor: .alias(.labelAlternative)
                                    ) {
                                        action()
                                    }
                                    .padding(.horizontal, 5)
                                    .background(
                                        ZStack {
                                            SwiftUI.Color.alias(.staticBlack)
                                                .opacity(0.05)
                                            SwiftUI.Color.alias(.staticWhite)
                                                .opacity(0.35)
                                        }
                                    )
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
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
        case floating(alternative: Bool = false)
    }
    
    /// TopNavigation의 좌/우에 표시될 Resource들의 Namespace입니다.
    public enum Resource {
        /// TopNavigation의 좌측에 표시될 내용들의 열거형입니다.
        public enum Left {
            case back(action: (()-> Void))
            case icon(Icon, action: (()-> Void))
            case text(String, action: (()-> Void))
        }
        
        
        
        /// TopNavigation의 우측에 표시될 내용들의 열거형입니다.
        public enum Action: Hashable {
            /// icon 형태의 Action입니다.
            /// - Parameters:
            ///  - showPushBadge: PushBadge의 노출 여부를 결정합니다. 기본값은 false입니다.
            ///  - action: icon 클릭시 동작할 action입니다.
            case icon(Icon, showPushBadge: Bool = false, action: (()-> Void))
            /// text 형태의 Action입니다.
            /// - Parameters:
            ///  - action: text 클릭시 동작할 action입니다.
            case text(String, action: (()-> Void))
            
            public func hash(into hasher: inout Hasher) {
                switch self {
                case let .icon(i, _, _):
                    hasher.combine(i)
                case let .text(t, _):
                    hasher.combine(t)
                }
            }
            
            public static func == (lhs: Bar.TopNavigation.Resource.Action, rhs: Bar.TopNavigation.Resource.Action) -> Bool {
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
        @State private var scrollOffset: CGFloat = .zero
        @State private var containerSize: CGSize = .zero
        @State private var innerContentSize: CGSize = .zero
        @State private var navigationHeight: CGFloat = .zero
        @State private var bottomActionHeight: CGFloat = .zero

        private let variant: Variant
        private let title: String
        private let showIndicator: Bool
        private let left: Resource.Left?
        private let actions: [Resource.Action]
        private let backgroundColorResolvable: ColorResolvable?
        private let model: ActionArea.Bottom.Model?
        
        /// TopNavigation의 사이즈를 측정하는 View입니다.
        private var navigationSizeMeasurer: some View {
            GeometryReader { proxy in
                SwiftUI.Color.clear
                    .onAppear {
                        navigationHeight = proxy.size.height
                    }
                    .onChange(of: variant) { _ in
                        navigationHeight = proxy.size.height
                    }
            }
        }
        /// ActionArea/Bottom의 사이즈를 측정하는 View입니다.
        private var bottomActionSizeMeasurer: some View {
            GeometryReader { proxy in
                SwiftUI.Color.clear
                    .onAppear {
                        bottomActionHeight = proxy.size.height
                    }
                    .onChange(of: variant) { _ in
                        bottomActionHeight = proxy.size.height
                    }
            }
        }
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
                return .init(uiColor: backgroundColorResolvable.resolve(.current))
            } else {
                return .clear
            }
        }
        /// ActionArea/Bottom의 sticky 속성을 결정하는 Property입니다.
        /// > 기본적으로 스크롤이 컨텐츠의 끝(전체 컨텐츠 크기 - offset)에 도달했을 때 sticky를 사용하지 않습니다.
        private var bottomActionSticky: Bool {
            let contentHeightOffset: CGFloat = (model?.variant == .extra) ? 70 : 20
            let totalContentHeight = innerContentSize.height + bottomActionHeight
            let currentScrollOffset = containerSize.height + abs(scrollOffset)
            return totalContentHeight - contentHeightOffset >= currentScrollOffset
        }
        /// Scroll 영역이 가지는 bottom padding입니다.
        ///
        /// Scroll 영역이 ActionArea/Bottom에 가려지는것을 방지하기 위해 사용합니다.
        /// > ActionArea/Bottom과 함께 사용하는 경우에 ActionArea/Bottom의 variant에 의해 결정됩니다.
        private var scrolLViewBottomPadding: CGFloat {
            if model != nil {
                return bottomActionHeight + (model?.variant == .extra ? +10 : .zero)
            } else {
                return .zero
            }
        }
        
        public init(
            variant: Variant,
            title: String,
            showIndicator: Bool = true,
            left: Resource.Left?,
            backgroundColorResolvable: ColorResolvable? = nil,
            actions: [Resource.Action],
            model: ActionArea.Bottom.Model? = nil
        ) {
            self.variant = variant
            self.title = title
            self.showIndicator = showIndicator
            self.left = left
            self.backgroundColorResolvable = backgroundColorResolvable
            self.actions = actions
            self.model = model
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
                    VStack(
                        alignment: .leading,
                        spacing: .zero
                    ) {
                        content
                    }
                    .readSize { innerContentSize = $0 }
                }
                .padding(.top, navigationHeight)
                .padding(.bottom, scrolLViewBottomPadding)
                .background(
                    backgroundColor
                )
                .coordinateSpace(name: "ScrollViewOrigin")
                .onPreferenceChange(
                    OffsetPreferenceKey.self,
                    perform: { scrollOffset = $0.y - navigationHeight }
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
                    .background(
                        navigationSizeMeasurer
                    )
                    Spacer()
                }
                if let model {
                    VStack(alignment: .leading, spacing: .zero) {
                        Spacer()
                        ActionArea.Bottom.Component(
                            model: .init(
                                variant: model.variant,
                                priority: model.priority,
                                sticky: bottomActionSticky,
                                caption: model.caption,
                                extraContents: model.extraContents
                            )
                        )
                        .animation(.easeInOut, value: bottomActionSticky)
                        .background(
                            bottomActionSizeMeasurer
                        )
                    }
                }
            }
            .ignoresSafeArea(.container, edges: ignoreSafeAreaEdge)
            .readSize { containerSize = $0 }
        }
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
