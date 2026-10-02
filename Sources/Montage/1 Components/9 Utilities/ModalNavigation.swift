//
//  ModalNavigation.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

/// 모달 내에서 사용하는 내비게이션 바 컴포넌트입니다.
///
/// 모달 상단에 제목, 뒤로가기 버튼, 추가 버튼 등을 포함하는
/// 내비게이션 바를 제공합니다. 스크롤에 따라 배경 불투명도가 자동으로 조절되며
/// 다양한 스타일을 지원합니다.
///
/// 좌우에 놓는 요소는 ``Resource/Leading``·``Resource/Trailing`` 프리셋에서 고릅니다.
/// 오른쪽은 왼쪽부터 순서대로 배치하므로 닫기 버튼을 마지막에 둡니다.
///
/// ```swift
/// ModalNavigation()
///     .variant(.emphasized)
///     .title("제목")
///     .leading(.back(action: goBack))
///     .trailings(
///         .icon(.share, action: share),
///         .close(action: dismiss)
///     )
/// ```
///
/// 프리셋에 없는 구성은 `slot(_:)`으로 직접 그립니다.
///
/// ```swift
/// ModalNavigation()
///     .leading(.slot { Avatar(url: profileURL) })
/// ```
///
/// 검색 입력을 받을 때는 ``Variant/search``를 쓰고 ``searchField(placeholder:searchTerm:focused:onSubmit:onTextChange:onFocusChange:)``로
/// 검색 필드를 설정합니다.
///
/// ```swift
/// ModalNavigation()
///     .variant(.search)
///     .searchField(placeholder: "검색어를 입력해 주세요.", searchTerm: $keyword)
///     .trailings(.text("취소", action: dismiss))
/// ```
public struct ModalNavigation: View {
    // MARK: - Types
    
    /// 내비게이션 바의 외관을 정의하는 구조체입니다.
    public struct Variant: Equatable, CustomStringConvertible {
        fileprivate enum Kind: Equatable {
            case normal, floating, emphasized, search
        }

        fileprivate let kind: Kind

        /// 제목을 가운데 두는 스타일. 전체 화면 모달에서만 씁니다.
        public static let normal = Variant(kind: .normal)
        /// 플로팅 스타일 (그라디언트, Progressive Blur 적용)
        ///
        /// ``Popup``·``BottomSheet``에서 높이를 차지하지 않고 콘텐츠 위에 뜹니다.
        /// 콘텐츠가 모달 위쪽 끝에서 시작하므로 이미지를 상단까지 채울 때 씁니다.
        /// 스크롤 오프셋이 0(스크롤이 최상단)일 때는 배경이 없고, 스크롤하면 그라디언트 블러 배경이 나타납니다.
        /// 여백은 ``search``와 같이 올라온 모달을 따릅니다.
        public static let floating = Variant(kind: .floating)
        /// 제목을 왼쪽에 두는 스타일. ``Popup``·``BottomSheet``의 기본값입니다.
        ///
        /// 여백은 ``search``와 같이 올라온 모달을 따릅니다.
        public static let emphasized = Variant(kind: .emphasized)
        /// 제목 대신 검색 필드를 두는 스타일.
        ///
        /// ``Popup``·``BottomSheet``·전체 화면 모달 어디서나 씁니다. 검색 필드는
        /// ``ModalNavigation/searchField(placeholder:searchTerm:focused:onSubmit:onTextChange:onFocusChange:)``로 설정하고,
        /// ``ModalNavigation/title(_:)``·``ModalNavigation/titleView(_:)``는 무시합니다.
        ///
        /// 여백은 올라온 모달을 따릅니다. ``Popup``·``BottomSheet``·모달 밖은 24, ``BottomSheet``의
        /// 전체 화면 모드는 20입니다. `fullScreenCover`에 직접 넣으면 모달 밖으로 보고 24가 됩니다.
        public static let search = Variant(kind: .search)

        fileprivate var isFloating: Bool { kind == .floating }

        public var description: String {
            switch kind {
            case .normal: "normal"
            case .floating: "floating"
            case .emphasized: "emphasized"
            case .search: "search"
            }
        }
    }
    
    // MARK: - Initialisers
    
    @Binding private var scrollOffset: CGFloat
    @Environment(\.modalKind) private var modalKind
    
    /// 내비게이션 바를 초기화합니다.
    ///
    /// - Parameters:
    ///   - scrollOffset: 스크롤 오프셋 바인딩, 생략하면 기본값으로 `.constant(0)` 적용
    public init(scrollOffset: Binding<CGFloat> = .constant(0)) {
        _scrollOffset = scrollOffset
    }
    
    // MARK: - Body
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(spacing: 0) {
            if needHandleArea {
                ZStack(alignment: .bottom) {
                    SwiftUI.Color.clear
                        .frame(height: 12)
                    RoundedRectangle(cornerRadius: 1000)
                        .foregroundStyle(SwiftUI.Color.semantic(.surfaceNeutralStrong))
                        .frame(width: 40, height: 5)
                }
            }
            
            Contents(
                variant: variant,
                titleText: titleText,
                titleView: titleView,
                leading: leading,
                trailings: trailings,
                hasIconButtonBackground: hasIconButtonBackground,
                horizontalPadding: variant.contentHorizontalPadding(in: modalKind),
                searchField: searchFieldConfiguration
            )
            .padding(.top, variant.contentTopPadding(in: modalKind))
            .padding(.bottom, variant.contentBottomPadding(in: modalKind))
        }
        .background {
            Group {
                if isMaterialBackgroundDisabled {
                    backgroundColor
                        .opacity(backgroundOpacity)
                } else {
                    MaterialBackground(
                        materialOpacity: backgroundOpacity,
                        tint: backgroundColor.opacity(backgroundOpacity * 0.88)
                    )
                }
            }
            .if(variant.isFloating) {
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
    
    // MARK: - Modifiers
    
    private var variant: Variant = .normal
    private var backgroundColor: SwiftUI.Color = SwiftUI.Color.semantic(.backgroundNeutralPrimary)
    private var isMaterialBackgroundDisabled = false
    private var fixedBackgroundOpacity: CGFloat?
    private var needHandleArea = false
    private var titleText: String?
    private var titleView: () -> AnyView = { AnyView(EmptyView()) }
    private var leading: Resource.Leading?
    private var trailings: [Resource.Trailing] = []
    private var hasIconButtonBackground = false
    private var searchFieldConfiguration = SearchFieldConfiguration()
    
    /// 내비게이션 바의 스타일을 설정합니다.
    ///
    /// - Parameter variant: 내비게이션 바 스타일
    /// - Returns: 수정된 내비게이션 바 뷰
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    /// 스크롤 오프셋을 설정합니다.
    ///
    /// - Parameter scrollOffset: 스크롤 오프셋에 대한 바인딩
    /// - Returns: 수정된 내비게이션 바 뷰
    public func scrollOffset(_ scrollOffset: Binding<CGFloat>) -> Self {
        var zelf = self
        zelf._scrollOffset = scrollOffset
        return zelf
    }
    
    /// 내비게이션 바의 배경색을 설정합니다.
    ///
    /// - Parameter backgroundColor: 배경색
    /// - Returns: 수정된 내비게이션 바 뷰
    public func backgroundColor(_ backgroundColor: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.backgroundColor = backgroundColor
        return zelf
    }
    
    /// 내비게이션 바의 배경에 머티리얼 효과를 적용하지 않습니다.
    ///
    /// - Returns: 수정된 내비게이션 바 뷰
    public func noMaterialBackground() -> Self {
        var zelf = self
        zelf.isMaterialBackgroundDisabled = true
        return zelf
    }
    
    /// 내비게이션 바의 배경 불투명도를 고정값으로 설정합니다. 스크롤에 따른 자동 조절을 비활성화하고 항상 일정한 불투명도를 유지합니다.
    ///
    /// - Parameter fixedBackgroundOpacity: 고정 배경 불투명도 (0에서 1 사이의 값)
    /// - Returns: 수정된 내비게이션 바 뷰
    public func fixedBackgroundOpacity(_ fixedBackgroundOpacity: CGFloat) -> Self {
        var zelf = self
        zelf.fixedBackgroundOpacity = fixedBackgroundOpacity
        return zelf
    }
    
    /// 바텀 시트의 핸들 영역 필요 여부를 설정합니다.
    ///
    /// - Parameter needHandleArea: 핸들 영역 필요 여부
    /// - Returns: 수정된 내비게이션 바 뷰
    ///
    /// - Note: titleView(_:)와 함께 사용될 경우 이 메서드로 설정된 텍스트만 표시됩니다.
    public func needHandleArea(_ needHandleArea: Bool) -> Self {
        var zelf = self
        zelf.needHandleArea = needHandleArea
        return zelf
    }
    
    /// 내비게이션 바의 타이틀을 설정합니다.
    ///
    /// - Parameter text: 타이틀
    /// - Returns: 수정된 내비게이션 바 뷰
    public func title(_ text: String) -> Self {
        var zelf = self
        zelf.titleText = text
        return zelf
    }
    
    /// 내비게이션 바의 타이틀 영역을 설정합니다.
    ///
    /// - Parameter content: 타이틀 영역에 표시될 콘텐츠
    /// - Returns: 수정된 내비게이션 바 뷰
    ///
    /// - Note: title(_:)와 함께 사용될 경우 title(_:) 메서드로 설정된 텍스트만 표시됩니다.
    public func titleView<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.titleView = { AnyView(content()) }
        return zelf
    }
    
    /// 내비게이션 바 왼쪽에 놓을 요소를 설정합니다.
    ///
    /// - Parameter leading: 왼쪽에 놓을 ``Resource/Leading``. `nil`이면 비워 둡니다
    /// - Returns: 수정된 내비게이션 바 뷰
    public func leading(_ leading: Resource.Leading?) -> Self {
        var zelf = self
        zelf.leading = leading
        return zelf
    }

    /// 내비게이션 바 오른쪽에 놓을 요소들을 설정합니다.
    ///
    /// 왼쪽부터 순서대로 배치하므로 닫기 버튼은 배열의 마지막에 둡니다.
    ///
    /// - Parameter trailings: 오른쪽에 놓을 ``Resource/Trailing`` 목록 (최대 3개까지 표시)
    /// - Returns: 수정된 내비게이션 바 뷰
    public func trailings(_ trailings: [Resource.Trailing]) -> Self {
        var zelf = self
        zelf.trailings = Array(trailings.prefix(3))
        return zelf
    }

    /// 내비게이션 바 오른쪽에 놓을 요소들을 설정합니다.
    ///
    /// 배열 버전 ``trailings(_:)-swift.method``에 대한 편의 오버로딩입니다.
    ///
    /// - Parameter trailings: 오른쪽에 놓을 ``Resource/Trailing`` 목록 (최대 3개까지 표시)
    /// - Returns: 수정된 내비게이션 바 뷰
    public func trailings(_ trailings: Resource.Trailing...) -> Self {
        self.trailings(trailings)
    }

    /// 아이콘 버튼에 원형 배경을 넣을지 설정합니다.
    ///
    /// 상단에 이미지를 깔아 버튼이 묻히는 자리에 씁니다. `floating` variant에서만 동작하고,
    /// 텍스트 버튼에는 적용되지 않습니다.
    ///
    /// - Parameter hasBackground: 원형 배경 사용 여부
    /// - Returns: 수정된 내비게이션 바 뷰
    public func iconButtonBackground(_ hasBackground: Bool = true) -> Self {
        var zelf = self
        zelf.hasIconButtonBackground = hasBackground
        return zelf
    }

    /// 검색 필드의 속성과 동작을 설정합니다. variant가 ``Variant/search``일 때만 적용됩니다.
    ///
    /// - Parameters:
    ///   - placeholder: 검색 필드에 표시할 플레이스홀더 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - searchTerm: 검색어 바인딩 변수
    ///   - focused: 검색 필드의 포커스 상태 바인딩 변수, 생략하면 기본값으로 `nil` 적용
    ///   - onSubmit: 검색어 제출 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - onTextChange: 검색어 텍스트 변경 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    ///   - onFocusChange: 검색 필드 포커스 변경 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 수정된 내비게이션 바 뷰
    public func searchField(
        placeholder: String? = nil,
        searchTerm: Binding<String>,
        focused: Binding<Bool>? = nil,
        onSubmit: (() -> Void)? = nil,
        onTextChange: ((String) -> Void)? = nil,
        onFocusChange: ((Bool) -> Void)? = nil
    ) -> Self {
        var zelf = self
        zelf.searchFieldConfiguration = SearchFieldConfiguration(
            placeholder: placeholder,
            searchTerm: searchTerm,
            focused: focused,
            onSubmit: onSubmit,
            onTextChange: onTextChange,
            onFocusChange: onFocusChange
        )
        return zelf
    }

    private struct SearchFieldConfiguration {
        var placeholder: String?
        var searchTerm: Binding<String>?
        var focused: Binding<Bool>?
        var onSubmit: (() -> Void)?
        var onTextChange: ((String) -> Void)?
        var onFocusChange: ((Bool) -> Void)?
    }

    private struct Contents: View {
        var variant: Variant
        var titleText: String?
        var titleView: () -> AnyView
        var leading: Resource.Leading?
        var trailings: [Resource.Trailing]
        var hasIconButtonBackground: Bool
        var horizontalPadding: CGFloat
        var searchField: SearchFieldConfiguration

        /// 아이콘 버튼이 차지하는 레이아웃 영역.
        ///
        /// 실제 버튼 컨테이너는 36이라 상하좌우로 6씩 이 영역을 넘어 그려진다.
        /// 넘치는 만큼까지 자리를 잡으면 제목과의 간격이 스펙보다 벌어진다.
        private static let actionItemSize: CGFloat = 24

        /// search를 뺀 variant의 콘텐츠 최소 높이. Figma는 24짜리 요소 위아래에 2씩 둬 28이다.
        private static let contentMinHeight: CGFloat = 28

        /// leading과 제목 사이, trailing 버튼 사이의 간격.
        private static let itemSpacing: CGFloat = 16

        /// search에서 검색 필드와 좌우 요소 사이의 간격. TopNavigation의 search와 같다.
        private static let searchItemSpacing: CGFloat = 12

        @State private var leadingWidth: CGFloat = 0
        @State private var trailingsWidth: CGFloat = 0
        @State private var internalSearchTerm = ""
        @State private var internalFocused = false

        var body: some View {
            Group {
                switch variant.kind {
                case .normal:
                    // 제목을 화면 가운데에 두려면 양쪽 여백이 같아야 하므로,
                    // leading과 trailing 중 넓은 쪽을 최소 여백으로 잡는다.
                    ZStack {
                        actionItems
                        HStack(spacing: 0) {
                            Spacer(minLength: max(leadingWidth, trailingsWidth))
                            titleContent
                            Spacer(minLength: max(leadingWidth, trailingsWidth))
                        }
                    }
                case .emphasized:
                    HStack(spacing: Self.itemSpacing) {
                        leadingView
                        titleContent
                        Spacer(minLength: 0)
                        trailingsView
                    }
                case .floating:
                    actionItems
                case .search:
                    HStack(spacing: Self.searchItemSpacing) {
                        leadingView
                        searchFieldView
                        if !trailings.isEmpty {
                            trailingsView
                        }
                    }
                }
            }
            .frame(minHeight: variant.kind == .search ? Self.actionItemSize : Self.contentMinHeight)
            .padding(.horizontal, horizontalPadding)
        }

        private var searchFieldView: some View {
            SearchField(text: searchField.searchTerm ?? $internalSearchTerm)
                .size(.medium)
                .placeholder(searchField.placeholder)
                // 내비게이션이 이미 머티리얼 배경을 깔기 때문에 검색 필드까지 머티리얼을 쌓으면
                // 흐림은 더해지지 않고 틴트만 중복돼 표면이 밝아진다.
                .disableMaterial()
                .focused(searchField.focused ?? $internalFocused)
                .onSubmit { searchField.onSubmit?() }
                .onTextChange { searchField.onTextChange?($0) }
                .onFocusChange { searchField.onFocusChange?($0) }
        }

        private var actionItems: some View {
            HStack(spacing: 0) {
                leadingView
                    .onGeometryChange(
                        for: CGFloat.self, of: { $0.size.width }, action: { leadingWidth = $0 }
                    )
                Spacer(minLength: 0)
                trailingsView
                    .onGeometryChange(
                        for: CGFloat.self, of: { $0.size.width }, action: { trailingsWidth = $0 }
                    )
            }
        }

        @ViewBuilder
        private var leadingView: some View {
            if let leading {
                leading.view(hasBackground: hasIconButtonBackground && variant.isFloating)
            }
        }

        private var trailingsView: some View {
            HStack(spacing: Self.itemSpacing) {
                ForEach(Array(trailings.enumerated()), id: \.offset) { _, trailing in
                    trailing.view(hasBackground: hasIconButtonBackground && variant.isFloating)
                }
            }
        }

        @ViewBuilder
        private var titleContent: some View {
            if variant.isFloating {
                EmptyView()
            } else if let titleText {
                TitleView(variant: variant, title: titleText)
            } else {
                titleView()
            }
        }
    }
}

extension ModalNavigation {
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
                    semantic: .foregroundNeutralStrong
                )
                .lineLimit(1)
                .padding(.horizontal, 4)
        }
    }
}

extension ModalNavigation {
    /// 콘텐츠 위에 떠 있어 레이아웃 높이를 차지하지 않는지 여부.
    ///
    /// Figma의 `floating`은 높이가 0이라 콘텐츠가 모달 위쪽 끝에서 시작한다.
    /// ``Popup``·``BottomSheet``는 이 값을 보고 내비게이션 자리를 비워 두지 않는다.
    var overlaysContent: Bool { variant.isFloating }
}

private extension ModalNavigation {
    /// 스크롤에 따른 배경 불투명도. 스크롤 오프셋이 0(스크롤이 최상단)이면 배경이 없고 32pt 스크롤하면 불투명해진다.
    /// `floating`도 같다. 콘텐츠 위에 떠 있어 스크롤 오프셋이 0일 때 배경이 있으면 아래 이미지를 가린다.
    var backgroundOpacity: CGFloat {
        let ratio = (scrollOffset / -32)
        return fixedBackgroundOpacity ?? max(0, min(1, ratio))
    }
    
    var gradientMaskColors: [SwiftUI.Color] {
        [0, 0.7, 1].map { SwiftUI.Color.black.opacity($0) }
    }
}

private extension ModalNavigation.Variant {
    /// 내비게이션 상하 여백.
    ///
    /// `normal`은 전체 화면 모달에서만 쓰므로 항상 전체 화면 모달 여백(20)을 쓴다.
    /// 나머지는 여러 모달에서 쓰므로 올라온 모달 종류로 고른다(``Popup``·``BottomSheet``·모달 밖 24, 전체 화면 20).
    func contentTopPadding(in modalKind: ModalKind) -> CGFloat {
        switch kind {
        case .normal: ModalKind.full.navigationPadding
        case .emphasized, .floating, .search: modalKind.navigationPadding
        }
    }

    func contentBottomPadding(in modalKind: ModalKind) -> CGFloat {
        contentTopPadding(in: modalKind)
    }

    /// 내비게이션 좌우 여백. 상하 여백과 같은 값을 쓴다.
    func contentHorizontalPadding(in modalKind: ModalKind) -> CGFloat {
        contentTopPadding(in: modalKind)
    }

    var typoVariant: Typography.Variant {
        switch kind {
        case .normal: .headline2
        case .floating: .headline2
        case .emphasized: .heading2
        case .search: .headline2
        }
    }

    var typoWeight: Typography.Weight {
        switch kind {
        case .normal: .bold
        case .floating: .bold
        case .emphasized: .bold
        case .search: .bold
        }
    }
}

// MARK: - Resource

extension ModalNavigation {
    /// 내비게이션 바 좌우에 놓을 수 있는 요소의 프리셋입니다.
    public enum Resource {
        /// 내비게이션 바 왼쪽에 놓는 요소입니다.
        public enum Leading {
            /// 뒤로 가기 버튼입니다.
            /// - Parameter action: 탭했을 때 실행할 동작
            case back(action: () -> Void)
            /// 아이콘을 직접 지정하는 아이콘 버튼입니다.
            ///
            /// 아이콘만으로는 동작을 알 수 없으므로 `accessibilityLabel`을 채워 주세요.
            /// 생략하면 VoiceOver가 아이콘 이름만 읽습니다.
            ///
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - accessibilityLabel: VoiceOver가 읽을 동작 이름, 생략하면 기본값으로 `nil` 적용
            ///   - action: 탭했을 때 실행할 동작
            case icon(_ icon: Icon, accessibilityLabel: String? = nil, action: () -> Void)
            /// 텍스트 버튼입니다.
            /// - Parameters:
            ///   - text: 표시할 텍스트
            ///   - action: 탭했을 때 실행할 동작
            case text(_ text: String, action: () -> Void)
            /// 프리셋에 없는 구성을 직접 그릴 때 씁니다. ``slot(_:)``으로 만듭니다.
            case slotView(() -> AnyView)

            /// 프리셋에 없는 구성을 직접 그립니다.
            ///
            /// - Parameter content: 왼쪽에 놓을 콘텐츠
            /// - Returns: 해당 콘텐츠를 그리는 ``Leading``
            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Leading {
                .slotView { AnyView(content()) }
            }
        }

        /// 내비게이션 바 오른쪽에 놓는 요소입니다.
        public enum Trailing {
            /// 모달을 닫는 버튼입니다.
            /// - Parameter action: 탭했을 때 실행할 동작
            case close(action: () -> Void)
            /// 아이콘을 직접 지정하는 아이콘 버튼입니다.
            ///
            /// 아이콘만으로는 동작을 알 수 없으므로 `accessibilityLabel`을 채워 주세요.
            /// 생략하면 VoiceOver가 아이콘 이름만 읽습니다.
            ///
            /// - Parameters:
            ///   - icon: 표시할 아이콘
            ///   - accessibilityLabel: VoiceOver가 읽을 동작 이름, 생략하면 기본값으로 `nil` 적용
            ///   - action: 탭했을 때 실행할 동작
            case icon(_ icon: Icon, accessibilityLabel: String? = nil, action: () -> Void)
            /// 텍스트 버튼입니다.
            /// - Parameters:
            ///   - text: 표시할 텍스트
            ///   - action: 탭했을 때 실행할 동작
            case text(_ text: String, action: () -> Void)
            /// 프리셋에 없는 구성을 직접 그릴 때 씁니다. ``slot(_:)``으로 만듭니다.
            case slotView(() -> AnyView)

            /// 프리셋에 없는 구성을 직접 그립니다.
            ///
            /// - Parameter content: 오른쪽에 놓을 콘텐츠
            /// - Returns: 해당 콘텐츠를 그리는 ``Trailing``
            public static func slot<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Trailing {
                .slotView { AnyView(content()) }
            }
        }
    }
}

extension ModalNavigation.Resource.Leading {
    @ViewBuilder
    func view(hasBackground: Bool) -> some View {
        switch self {
        case .back(let action):
            ModalNavigation.Resource.iconButton(.chevronLeft, hasBackground: hasBackground, action: action)
                .accessibilityLabel(String(localized: "뒤로 가기", bundle: .module))
        case let .icon(icon, label, action):
            ModalNavigation.Resource.iconButton(
                icon, hasBackground: hasBackground, accessibilityLabel: label, action: action
            )
        case let .text(text, action):
            ModalNavigation.Resource.textButton(text, action: action)
        case .slotView(let content):
            content()
        }
    }
}

extension ModalNavigation.Resource.Trailing {
    @ViewBuilder
    func view(hasBackground: Bool) -> some View {
        switch self {
        case .close(let action):
            ModalNavigation.Resource.iconButton(.close, hasBackground: hasBackground, action: action)
                .accessibilityLabel(String(localized: "닫기", bundle: .module))
        case let .icon(icon, label, action):
            ModalNavigation.Resource.iconButton(
                icon, hasBackground: hasBackground, accessibilityLabel: label, action: action
            )
        case let .text(text, action):
            ModalNavigation.Resource.textButton(text, action: action)
        case .slotView(let content):
            content()
        }
    }
}

extension ModalNavigation.Resource {
    /// 아이콘 버튼이 차지하는 레이아웃 영역. 버튼 컨테이너 36은 이 영역을 6씩 넘어 그려진다.
    fileprivate static let iconButtonLayoutSize: CGFloat = 24

    /// 원형 배경의 지름.
    private static let iconButtonBackgroundSize: CGFloat = 36

    @ViewBuilder
    fileprivate static func iconButton(
        _ icon: Icon,
        hasBackground: Bool,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        iconButtonBody(icon, hasBackground: hasBackground, action: action)
            // 레이블을 주지 않으면 IconButton이 붙인 "{아이콘 이름} 아이콘"이 그대로 읽힌다.
            .modifying { view in
                Group {
                    if let accessibilityLabel {
                        view.accessibilityLabel(accessibilityLabel)
                    } else {
                        view
                    }
                }
            }
    }

    @ViewBuilder
    private static func iconButtonBody(
        _ icon: Icon,
        hasBackground: Bool,
        action: @escaping () -> Void
    ) -> some View {
        if hasBackground {
            // 원형 배경은 IconButton `background` variant와 같은 스펙이다(지름 36 / 아이콘 24).
            IconButton(variant: .background(size: Int(iconButtonBackgroundSize)), icon: icon, handler: action)
                .frame(width: iconButtonLayoutSize, height: iconButtonLayoutSize)
        } else {
            IconButton(variant: .normal(size: .xlarge), icon: icon, handler: action)
                .interactionEffect(.dim)
                .frame(width: iconButtonLayoutSize, height: iconButtonLayoutSize)
        }
    }

    /// 텍스트 버튼. TopNavigation의 텍스트 버튼과 같은 스펙(Headline 2 Regular, Label/Normal)이다.
    /// 아이콘 버튼과 같은 24만 차지해 텍스트 버튼이 들어가도 바 높이가 달라지지 않는다.
    fileprivate static func textButton(
        _ text: String,
        action: @escaping () -> Void
    ) -> some View {
        TextButton(text: text, handler: action)
            .contentColor(.semantic(.foregroundNeutralPrimary))
            .fontVariant(.headline2)
            .fontWeight(.regular)
            .frame(height: iconButtonLayoutSize)
    }
}
