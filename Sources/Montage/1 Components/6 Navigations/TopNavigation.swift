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
///     scrollOffset: 0,
///     backgroundColor: .white
/// )
/// .variant(.normal)
/// .title("제목")
/// .leadingContent { /* 왼쪽 영역 컴포넌트 */ }
/// .trailingContents(
///     { /* 컴포넌트1 */ },
///     { /* 컴포넌트2 */ }
/// )
/// ```
/// ```swift
/// TopNavigation(
///     scrollOffset: 0,
///     backgroundColor: .white
/// )
/// .variant(.floating)
/// .titleView { /* 제목 컴포넌트 */ }
/// .leadingContent { /* 왼쪽 영역 컴포넌트 */ }
/// .trailingContents(
///     { /* 컴포넌트1 */ },
///     { /* 컴포넌트2 */ }
/// )
/// ```
public struct TopNavigation: View {
    
    /// TopNavigation의 외관을 결정하는 열거형입니다.
    ///
    /// 내비게이션 바의 다양한 레이아웃과 시각적 스타일을 정의합니다.
    ///
    /// ```swift
    /// TopNavigation
    ///     .variant(.floating)
    ///     .titleView { ... }
    /// ```
    public enum Variant: Equatable {
        /// 기본 내비게이션 바 스타일
        case normal
        /// 타이틀이 크게 표시되는 내비게이션 바 스타일
        case display
        /// 검색 내비게이션 바 스타일
        case search
        /// 플로팅 내비게이션 바 스타일
        case floating
        
        fileprivate var isFloating: Bool {
            self == .floating
        }
    }
    
    // MARK: - Initializers
    
    private let scrollOffset: CGFloat
    private let backgroundColor: SwiftUI.Color?

    /// TopNavigation을 초기화합니다.
    ///
    /// - Parameters:
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
    private var titleText: String?
    private var titleView: () -> AnyView  = { AnyView(EmptyView()) }
    private var leadingContent: () -> AnyView  = { AnyView(EmptyView()) }
    private var trailingContents: [() -> AnyView] = []
    private var searchFieldPlaceholder: String?
    private var searchTerm: Binding<String>?
    private var searchFieldFocused: Binding<Bool>?
    private var onSearch: (() -> Void)?
    
    /// 내비게이션 바의 스타일(Variant)을 설정합니다.
    ///
    /// `.normal`, `.display`, `.search`, `.floating` 중 하나의 스타일을 지정할 수 있으며,
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
    /// - Parameters:
    ///   - text: 타이틀에 표시할 문자열
    /// - Returns: 수정된 내비게이션 바 인스턴스
    ///
    /// - Note: titleView(_:)와 함께 사용될 경우 이 메서드로 설정된 텍스트만 표시됩니다.
    public func title(_ text: String) -> Self {
        var zelf = self
        zelf.titleText = text
        return zelf
    }
    
    /// 내비게이션 영역의 타이틀 뷰를 설정합니다.
    ///
    /// 타이틀에는 텍스트 또는 커스텀 뷰를 사용할 수 있으며, ViewBuilder를 통해 정의됩니다.
    ///
    /// - Parameter content: 표시할 타이틀 뷰를 반환하는 클로저
    /// - Returns: 수정된 인스턴스를 반환합니다.
    ///
    /// - Note: title(_:)와 함께 사용될 경우 title(_:) 메서드로 설정된 텍스트만 표시됩니다.
    public func titleView<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.titleView = { AnyView(content()) }
        return zelf
    }
    
    /// 내비게이션 영역의 왼쪽(leadingContent) 영역에 표시할 뷰를 설정합니다.
    ///
    /// 주로 아이콘이나 취소 버튼 등을 배치할 수 있으며, ViewBuilder를 통해 정의됩니다.
    ///
    /// - Parameter content: leadingContent 영역에 표시할 뷰를 반환하는 클로저
    /// - Returns: 수정된 인스턴스를 반환합니다.
    public func leadingContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
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
        var zelf = self
        zelf.trailingContents = contents.prefix(3).map { content in { AnyView(content()) } }
        return zelf
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
        trailingContents(contents)
    }
    
    /// 검색 필드의 속성과 동작을 설정합니다. variant가 `.search`일 때만 적용됩니다.
    ///
    /// - Parameters:
    ///   - placeholder: 검색 필드에 표시할 플레이스홀더 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - searchTerm: 검색어 바인딩 변수
    ///   - focused: 검색 필드의 포커스 상태 바인딩 변수, 생략하면 기본값으로 `nil` 적용
    ///   - onSubmit: 검색어 제출 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 수정된 인스턴스를 반환합니다.
    public func searchField(
        placeholder: String? = nil,
        searchTerm: Binding<String>,
        focused: Binding<Bool>? = nil,
        onSubmit: (() -> Void)? = nil
    ) -> Self {
        var zelf = self
        zelf.searchFieldPlaceholder = placeholder
        zelf.searchTerm = searchTerm
        zelf.searchFieldFocused = focused
        zelf.onSearch = onSubmit
        return zelf
    }
    
    // MARK: - Body
    
    @State private var defaultSearchTerm: String = ""
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .bottom) {
            Contents(
                variant: variant,
                titleText: titleText,
                titleView: titleView,
                leadingContent: leadingContent,
                trailingContents: trailingContents,
                searchPlaceholder: searchFieldPlaceholder,
                searchTerm: searchTerm ?? $defaultSearchTerm,
                focused: searchFieldFocused,
                onSubmit: onSearch
            )
            .background {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial)
                        .opacity(backgroundOpacity)
                    backgroundView
                        .opacity(backgroundOpacity * 0.7)
                }
                .if(variant == .floating) {
                    $0.mask {
                        LinearGradient(
                            colors: gradientMaskColors,
                            startPoint: .init(x: 0, y: 1),
                            endPoint: .init(x: 0, y: 0)
                        )
                    }
                }
                .ignoresSafeArea(.container, edges: .top)
            }
        }
    }
    
    // MARK: - Computed properties
    
    private var backgroundView: SwiftUI.Color {
        backgroundColor ?? SwiftUI.Color.semantic(.backgroundNormal)
    }
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets: EdgeInsets
    
    private var backgroundOpacity: CGFloat {
        if variant.isFloating {
            return 1
        } else {
            guard safeAreaInsets.top > 0 else { return 0 }
            let ratio = (scrollOffset / -safeAreaInsets.top)
            return max(0, min(1, ratio))
        }
    }
    
    private var gradientMaskColors = [0, 0.7, 1].map { SwiftUI.Color.black.opacity($0) }
    
    // MARK: - Inner Views
    
    struct Contents: View {
        
        private let variant: Variant
        private let titleText: String?
        private let titleView: () -> AnyView
        private let leadingContent: () -> AnyView
        private let trailingContents: [() -> AnyView]
        private let searchPlaceholder: String?
        private let externalSearchTerm: Binding<String>?
        private let externalFocused: Binding<Bool>?
        private let onSubmit: (() -> Void)?
        
        init(
            variant: Variant,
            titleText: String? = nil,
            titleView: @escaping () -> AnyView,
            leadingContent: @escaping () -> AnyView,
            trailingContents: [() -> AnyView],
            searchPlaceholder: String? = nil,
            searchTerm: Binding<String>? = nil,
            focused: Binding<Bool>? = nil,
            onSubmit: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.titleText = titleText
            self.titleView = titleView
            self.leadingContent = leadingContent
            self.trailingContents = trailingContents
            self.searchPlaceholder = searchPlaceholder
            self.externalSearchTerm = searchTerm
            self.externalFocused = focused
            self.onSubmit = onSubmit
        }
        
        private var actionItemsMaxWidth: CGFloat {
            max(leadingSize.width, totalSizeOfTrailings.width)
        }
        
        @State private var leadingSize: CGSize = .zero
        @State private var totalSizeOfTrailings: CGSize = .zero
        @State private var internalSearchTerm = ""
        @State private var internalFocused = false
        @FocusState private var focusState: Bool
        
        private var searchTerm: Binding<String> {
            externalSearchTerm ?? $internalSearchTerm
        }
        
        private var focused: Binding<Bool> {
            externalFocused ?? $internalFocused
        }
        
        var body: some View {
            Group {
                switch variant {
                case .normal:
                    ZStack {
                        actionItems
                        
                        HStack(spacing: 6) {
                            Spacer(minLength: actionItemsMaxWidth)
                            titleContent
                                .frame(height: 24)
                                .padding(.vertical, 10)
                            Spacer(minLength: actionItemsMaxWidth)
                        }
                        .frame(height: 44)
                    }
                case .display:
                    ZStack {
                        actionItems
                        
                        HStack(spacing: 6) {
                            titleContent
                                .frame(height: 32, alignment: variant.textAlignment)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 16)
                            Spacer(minLength: actionItemsMaxWidth)
                        }
                        .frame(height: 64)
                    }
                case .search:
                    HStack(spacing: 12) {
                        leadingContent()
                        
                        searchField
                        
                        if trailingContents.isNotEmpty {
                            TrailingContents(trailingContents)
                        }
                    }
                case .floating:
                    actionItems
                        .frame(height: 24)
                        .padding(.top, 16)
                        .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 16)
        }
        
        @ViewBuilder
        private var titleContent: some View {
            if let titleText {
                TitleView(variant: variant, title: titleText)
            } else {
                titleView()
            }
        }
        
        @ViewBuilder
        private var actionItems: some View {
            HStack(spacing: .zero) {
                if variant != .display {
                    leadingContent()
                        .onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { leadingSize = $0 }
                        )
                }
                Spacer()
                TrailingContents(trailingContents)
                    .onGeometryChange(
                        for: CGSize.self,
                        of: { $0.size },
                        action: { totalSizeOfTrailings = $0 }
                    )
            }
        }
        
        @ViewBuilder
        private var searchField: some View {
            HStack(alignment: .center, spacing: 4) {
                Image.icon(.search)
                    .resizable()
                    .foregroundStyle(SwiftUI.Color.semantic( .labelAssistive))
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 2)
                
                ZStack(alignment: .trailing) {
                    SwiftUI.TextField(
                        "",
                        text: searchTerm,
                        prompt: {
                            if let searchPlaceholder {
                                Text(searchPlaceholder)
                                    .typography(variant: .body1, weight: .regular, semantic: .labelAssistive)
                            } else {
                                nil
                            }
                        }()
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                    .onSubmit(onSubmit ?? {})
                    .font(.font(variant: .body1, weight: .regular))
                    .foregroundStyle(SwiftUI.Color.semantic( .labelNormal))
                    .frame(height: 24)
                    .frame(maxWidth: .infinity)
                    .focused($focusState)
                    .onChange(of: focused.wrappedValue) {
                        if focusState != $0 {
                            focusState = $0
                        }
                    }
                    .onChange(of: $focusState.wrappedValue) {
                        if focused.wrappedValue != $0 {
                            focused.wrappedValue = $0
                        }
                    }
                    
                    if searchTerm.wrappedValue.isNotEmpty {
                        SwiftUI.Button {
                            searchTerm.wrappedValue = ""
                        } label: {
                            Image.icon(.circleCloseFill)
                                .resizable()
                                .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(SwiftUI.Color.semantic(.fillNormal))
            }
            .padding(.vertical, 8)
        }
    }
    
    struct TitleView: View {
        let variant: Variant
        let title: String
        
        init(
            variant: Variant = .normal,
            title: String
        ) {
            self.variant = variant
            self.title = title
        }
        
        var body: some View {
            Text(title)
                .paragraph(
                    variant: variant.typoVariant,
                    weight: variant.typoWeight,
                    semantic: .labelStrong
                )
                .lineLimit(1)
        }
    }
    
    struct TrailingContents: View {
        let contents: [() -> AnyView]
        
        init(_ contents:  [() -> AnyView]) {
            self.contents = contents
        }
        
        var body: some View {
            HStack(alignment: .center, spacing: 16) {
                ForEach(contents.indices, id: \.self) { index in
                    contents[index]()
                        .contentShape(Rectangle().scale(2), eoFill: true) // 터치영역 확장
                }
            }
        }
    }
}

// MARK: - Resource Views

extension TopNavigation {
    /// 내비게이션 바의 왼쪽(leading) 영역에 위치하는 기본 버튼입니다.
    ///
    /// 뒤로가기, 아이콘 버튼, 텍스트 버튼 등의 다양한 형태를 제공합니다.
    ///
    /// ```swift
    /// LeadingButton(
    ///     .back { dismiss() }
    /// )
    /// ```
    ///
    /// 버튼이 없을 경우에는 투명한 공간을 차지하여 레이아웃이 유지됩니다.
    public struct LeadingButton: View {
        let action: Resource.LeadingButtonInfo?
        
        /// 내비게이션 바의 왼쪽(leading) 영역에 위치하는 기본 버튼을 초기화합니다.
        ///
        /// - Parameters:
        ///   - action: 버튼 액션
        /// - Returns: LeadingButton 인스턴스
        public init(_ action: Resource.LeadingButtonInfo?) {
            self.action = action
        }
        
        /// 뷰의 내용과 동작을 정의합니다.
        public var body: some View {
            if let action {
                Group {
                    switch action {
                    case .back(let action):
                        IconButton(icon: .chevronLeft) {
                            action()
                        }
                        .frame(width: 24, height: 24)
                    case let .icon(i, action):
                        IconButton(icon: i) {
                            action()
                        }
                        .frame(width: 24, height: 24)
                    case let .text(t, action):
                        TrailingTextButton(
                            text: t,
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
    /// ```swift
    /// TrailingTextButton(
    ///     text: "확인",
    ///     disable: false
    /// ) {
    ///     // 버튼 액션
    /// }
    /// ```
    public struct TrailingTextButton: View {
        private let text: String
        private let disable: Bool
        private let action: () -> Void
        
        /// 내비게이션 바의 오른쪽(trailing)에 위치하는 텍스트 버튼을 초기화합니다.
        ///
        /// - Parameters:
        ///   - text: 버튼에 표시할 텍스트
        ///   - disable: 버튼 비활성화 여부, 생략하면 기본값으로 `false` 적용
        ///   - action: 버튼 액션
        /// - Returns: TrailingTextButton 인스턴스
        public init(
            text: String,
            disable: Bool = false,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.disable = disable
            self.action = action
        }

        /// 뷰의 내용과 동작을 정의합니다.
        public var body: some View {
            TextButton(text: text) {
                action()
            }
            .disable(disable)
            .contentColor(.semantic(.labelNormal))
            .fontVariant(.headline2)
            .fontWeight(.regular)
            .frame(height: 24)
        }
    }
    
    /// 내비게이션 바의 오른쪽(trailing)에 위치하는 아이콘 버튼입니다.
    ///
    /// 비활성화(disable), 푸시 뱃지 등을 옵션으로 설정할 수 있습니다.
    ///
    /// ```swift
    /// TrailingIconButton(
    ///     icon: .bell,
    ///     showPushBadge: true
    /// ) {
    ///     // 버튼 액션
    /// }
    /// ```
    public struct TrailingIconButton: View {
        private let icon: Icon
        private let disable: Bool
        private let showPushBadge: Bool
        private let action: () -> Void
        
        /// 내비게이션 바의 오른쪽(trailing)에 위치하는 아이콘 버튼을 초기화합니다.
        ///
        /// - Parameters:
        ///   - icon: 아이콘 버튼의 아이콘
        ///   - disable: 버튼 비활성화 여부, 생략하면 기본값으로 `false` 적용
        ///   - showPushBadge: PushBadge의 노출 여부, 생략하면 기본값으로 `false` 적용
        ///   - action: 아이콘 버튼 클릭시 동작할 액션
        /// - Returns: TrailingIconButton 인스턴스
        public init(
            icon: Icon,
            disable: Bool = false,
            showPushBadge: Bool = false,
            action: @escaping () -> Void
        ) {
            self.icon = icon
            self.disable = disable
            self.showPushBadge = showPushBadge
            self.action = action
        }
        
        /// 뷰의 내용과 동작을 정의합니다.
        public var body: some View {
            IconButton(icon: icon) {
                action()
            }
            .disable(disable)
            .showPushBadge(showPushBadge)
            .frame(width: 24, height: 24)
        }
    }
}

extension TopNavigation {
    /// TopNavigation의 좌/우에 표시될 Resource들의 Namespace입니다.
    public enum Resource {
        /// TopNavigation의 좌측에 표시될 내용들의 열거형입니다.
        ///
        /// 뒤로가기 버튼, 아이콘 버튼, 텍스트 버튼을 지원합니다.
        ///
        /// ```swift
        /// TopNavigation()
        ///     .leadingContent { /* ... */ }
        ///
        /// ```
        public enum LeadingButtonInfo {
            /// 뒤로가기 버튼
            /// - Parameter action: 뒤로가기 버튼 클릭시 동작할 액션
            case back(action: () -> Void)
            /// 아이콘 버튼
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - action: 아이콘 버튼 클릭시 동작할 액션
            case icon(_ icon: Icon, action: () -> Void)
            /// 텍스트 버튼
            /// - Parameters:
            ///   - text: 버튼에 표시할 텍스트
            ///   - action: 텍스트 버튼 클릭시 동작할 액션
            case text(_ text: String, action: () -> Void)
        }
        
        /// TopNavigation의 우측에 표시될 내용들의 열거형입니다.
        ///
        /// 아이콘 버튼과 텍스트 버튼을 지원합니다.
        ///
        /// ```swift
        /// TopNavigation()
        ///     .trailingContents(
        ///         { TopNavigation.TrailingIconButton(icon: .search) { /* ... */ } },
        ///         { TopNavigation.TrailingTextButton(text: "완료") { /* ... */ } }
        ///     )
        /// ```
        public enum TrailingButtonInfo: Hashable {
            /// icon 형태의 Action입니다.
            /// - Parameters:
            ///   - icon: 아이콘 버튼의 아이콘
            ///   - disable: 버튼 비활성화 여부, 생략하면 기본값으로 `false` 적용
            ///   - showPushBadge: PushBadge의 노출 여부, 생략하면 기본값으로 `false` 적용
            ///   - action: 아이콘 클릭시 동작할 액션
            case icon(_ icon: Icon, disable: Bool = false, showPushBadge: Bool = false, action: () -> Void)
            /// text 형태의 Action입니다.
            /// - Parameters:
            ///   - text: 텍스트 버튼의 텍스트
            ///   - disable: 버튼 비활성화 여부, 생략하면 기본값으로 `false` 적용
            ///   - action: 텍스트 클릭시 동작할 액션
            case text(_ text: String, disable: Bool = false, action: () -> Void)
            
            /// 해시 값을 생성합니다.
            ///
            /// - Parameter hasher: 해시 값을 생성할 해시 값
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
            
            /// 두 개의 TrailingButtonInfo 인스턴스를 비교합니다.
            ///
            /// - Parameters:
            ///   - lhs: 비교할 첫 번째 TrailingButtonInfo 인스턴스
            ///   - rhs: 비교할 두 번째 TrailingButtonInfo 인스턴스
            /// - Returns: 두 인스턴스가 같은지 여부
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
        if case .display = self {
            .title3
        } else {
            .headline2
        }
    }
    
    var typoWeight: Typography.Weight {
        .bold
    }
    
    var textAlignment: Alignment {
        if case .display = self {
            .leading
        } else {
            .center
        }
    }
}

struct TopNavigationModifier: ViewModifier {
    private let variant: TopNavigation.Variant
    private let titleView: (() -> any View)?
    private let backgroundColor: SwiftUI.Color?
    private let leadingContent: (() -> any View)?
    private let trailingContents: [() -> any View]
    private let actionAreaModel: ActionArea.Model?
    private let searchPlaceholder: String?
    private let externalSearchTerm: Binding<String>?
    private let externalFocused: Binding<Bool>?
    private let onSubmit: (() -> Void)?
    
    init(
        variant: TopNavigation.Variant,
        titleView: (() -> any View)?,
        backgroundColor: SwiftUI.Color?,
        leadingContent: (() -> any View)?,
        trailingContents: [() -> any View],
        actionAreaModel: ActionArea.Model?,
        searchPlaceholder: String?,
        searchTerm: Binding<String>?,
        searchFocused: Binding<Bool>?,
        onSearch: (() -> Void)?
    ) {
        self.variant = variant
        self.titleView = titleView
        self.backgroundColor = backgroundColor
        self.leadingContent = leadingContent
        self.trailingContents = trailingContents
        self.actionAreaModel = actionAreaModel
        self.searchPlaceholder = searchPlaceholder
        self.externalSearchTerm = searchTerm
        self.externalFocused = searchFocused
        self.onSubmit = onSearch
    }
    
    // MARK: - Body
    
    @State private var scrollStatus: ScrollView.ScrollStatus = .init()
    @State private var navigationHeight: CGFloat = .zero
    @State private var internalSearchTerm = ""
    @State private var internalFocused = false
    
    private var searchTerm: Binding<String> {
        externalSearchTerm ?? $internalSearchTerm
    }
    
    private var focused: Binding<Bool> {
        externalFocused ?? $internalFocused
    }
    
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
                    .searchField(
                        placeholder: searchPlaceholder,
                        searchTerm: searchTerm,
                        focused: focused,
                        onSubmit: onSubmit
                    )
                    .modifying {
                        var mutated = $0
                        if let titleView {
                            mutated = mutated.titleView {
                                AnyView(titleView())
                            }
                        }
                        if let leadingContent {
                            mutated = mutated.leadingContent {
                                AnyView(leadingContent())
                            }
                        }
                        if trailingContents.isNotEmpty {
                            mutated = mutated.trailingContents(trailingContents)
                        }
                        return mutated
                    }
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
                    .caption(actionAreaModel.caption)
                    .extra(actionAreaModel.extra, divider: actionAreaModel.extraDivider)
                    .modifying {
                        if case .manual(let transparency) = actionAreaModel.backgroundTransparencyControl {
                            $0.transparentBackground(transparency)
                        } else {
                            $0.transparentBackground(scrollStatus.scrolledToMax)
                        }
                    }
            }
        }
    }
    
    private var background: SwiftUI.Color {
        backgroundColor ?? .clear
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 TopNavigation 바를 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 내비게이션 바의 외관 스타일, 생략하면 기본값으로 `.normal` 적용
    ///   - titleView: 표시할 제목 컴포넌트 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - backgroundColor: TopNavigation이 적용된 전체 뷰의 배경색, 생략하면 기본값으로 `nil` 적용
    ///   - leadingContent: 좌측에 표시할 컴포넌트 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - trailingContents: 우측에 표시할 컴포넌트 클로저, 생략하면 기본값으로 `[]` 적용
    ///   - model: 하단 액션 영역에 대한 모델, 생략하면 기본값으로 `nil` 적용
    ///   - searchPlaceholder: 검색 필드의 플레이스홀더 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - searchTerm: 검색어 바인딩, 생략하면 기본값으로 `nil` 적용
    ///   - searchFocused: 검색 필드 포커스 상태 바인딩, 생략하면 기본값으로 `nil` 적용
    ///   - onSearch: 검색 실행 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    /// - Returns: TopNavigation이 적용된 뷰
    public func topNavigation(
        variant: TopNavigation.Variant = .normal,
        titleView: (() -> any View)? = nil,
        backgroundColor: SwiftUI.Color? = nil,
        leadingContent: (() -> any View)? = nil,
        trailingContents: [() -> any View] = [],
        withBottom model: ActionArea.Model? = nil,
        searchPlaceholder: String? = nil,
        searchTerm: Binding<String>? = nil,
        searchFocused: Binding<Bool>? = nil,
        onSearch: (() -> Void)? = nil
    ) -> some View {
        modifier(
            TopNavigationModifier(
                variant: variant,
                titleView: titleView.map { v in { AnyView(v()) } },
                backgroundColor: backgroundColor,
                leadingContent: leadingContent.map { v in { AnyView(v()) } },
                trailingContents: trailingContents.prefix(3).map { v in { AnyView(v()) } },
                actionAreaModel: model,
                searchPlaceholder: searchPlaceholder,
                searchTerm: searchTerm,
                searchFocused: searchFocused,
                onSearch: onSearch
            )
        )
    }

    /// 현재 뷰에 TopNavigation 바를 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 내비게이션 바의 외관 스타일, 생략하면 기본값으로 `.normal` 적용
    ///   - title: 표시할 텍스트 타이틀
    ///   - backgroundColor: 배경색, 생략하면 기본값으로 `nil` 적용
    ///   - leadingContent: 좌측에 표시할 컴포넌트 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - trailingContents: 우측에 표시할 컴포넌트 클로저, 생략하면 기본값으로 `[]` 적용
    ///   - model: 하단 액션 영역에 대한 모델, 생략하면 기본값으로 `nil` 적용
    ///   - searchPlaceholder: 검색 필드의 플레이스홀더 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - searchTerm: 검색어 바인딩, 생략하면 기본값으로 `nil` 적용
    ///   - searchFocused: 검색 필드 포커스 상태 바인딩, 생략하면 기본값으로 `nil` 적용
    ///   - onSearch: 검색 실행 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    /// - Returns: TopNavigation이 적용된 뷰
    public func topNavigation(
        variant: TopNavigation.Variant = .normal,
        title: String,
        backgroundColor: SwiftUI.Color? = nil,
        leadingContent: (() -> any View)? = nil,
        trailingContents: [() -> any View] = [],
        withBottom model: ActionArea.Model? = nil,
        searchPlaceholder: String? = nil,
        searchTerm: Binding<String>? = nil,
        searchFocused: Binding<Bool>? = nil,
        onSearch: (() -> Void)? = nil
    ) -> some View {
        modifier(
            TopNavigationModifier(
                variant: variant,
                titleView: { AnyView(TopNavigation.TitleView(variant: variant, title: title)) },
                backgroundColor: backgroundColor,
                leadingContent: leadingContent.map { v in { AnyView(v()) } },
                trailingContents: trailingContents.prefix(3).map { v in { AnyView(v()) } },
                actionAreaModel: model,
                searchPlaceholder: searchPlaceholder,
                searchTerm: searchTerm,
                searchFocused: searchFocused,
                onSearch: onSearch
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
