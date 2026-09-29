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
public struct ModalNavigation: View {
    // MARK: - Types
    
    /// 내비게이션 바의 외관을 정의하는 구조체입니다.
    public struct Variant: Equatable, CustomStringConvertible {
        fileprivate enum Kind: Equatable {
            case normal, floating, emphasized
        }

        fileprivate let kind: Kind

        /// 제목을 가운데 두는 스타일. 전체 화면 모달에서만 씁니다.
        public static let normal = Variant(kind: .normal)
        /// 플로팅 스타일 (그라디언트, Progressive Blur 적용)
        ///
        /// ``Popup``·``BottomSheet``에서 높이를 차지하지 않고 콘텐츠 위에 뜹니다.
        /// 콘텐츠가 모달 위쪽 끝에서 시작하므로 이미지를 상단까지 채울 때 씁니다.
        /// 스크롤 오프셋이 0(스크롤이 최상단)일 때는 배경이 없고, 스크롤하면 그라디언트 블러 배경이 나타납니다.
        public static let floating = Variant(kind: .floating)
        /// 제목을 왼쪽에 두는 스타일. ``Popup``·``BottomSheet``의 기본값입니다.
        public static let emphasized = Variant(kind: .emphasized)

        fileprivate var isFloating: Bool { kind == .floating }

        public var description: String {
            switch kind {
            case .normal: "normal"
            case .floating: "floating"
            case .emphasized: "emphasized"
            }
        }
    }
    
    // MARK: - Initialisers
    
    @Binding private var scrollOffset: CGFloat
    
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
                hasIconButtonBackground: hasIconButtonBackground
            )
            .padding(.top, variant.contentTopPadding)
            .padding(.bottom, variant.contentBottomPadding)
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

    private struct Contents: View {
        var variant: Variant
        var titleText: String?
        var titleView: () -> AnyView
        var leading: Resource.Leading?
        var trailings: [Resource.Trailing]
        var hasIconButtonBackground: Bool

        /// 아이콘 버튼이 차지하는 레이아웃 영역.
        ///
        /// 실제 버튼 컨테이너는 36이라 상하좌우로 6씩 이 영역을 넘어 그려진다.
        /// 넘치는 만큼까지 자리를 잡으면 제목과의 간격이 스펙보다 벌어진다.
        private static let actionItemSize: CGFloat = 24

        /// leading과 제목 사이, trailing 버튼 사이의 간격.
        private static let itemSpacing: CGFloat = 16

        @State private var leadingWidth: CGFloat = 0
        @State private var trailingsWidth: CGFloat = 0

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
                }
            }
            .frame(minHeight: Self.actionItemSize)
            .padding(.horizontal, variant.contentHorizontalPadding)
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
    /// `normal`은 전체 화면 모달에서만 쓰므로 화면 여백과 같은 20, `emphasized`는
    /// ``Popup``·``BottomSheet`` 안이라 24다. `floating`은 어느 모달에 얹히든 Figma 스펙인 24를 쓴다.
    var contentTopPadding: CGFloat {
        switch kind {
        case .normal: ModalKind.full.navigationPadding
        case .emphasized, .floating: ModalKind.popup.navigationPadding
        }
    }

    var contentBottomPadding: CGFloat {
        contentTopPadding
    }

    /// 내비게이션 좌우 여백. 상하 여백과 같은 값을 쓴다.
    var contentHorizontalPadding: CGFloat {
        contentTopPadding
    }

    var typoVariant: Typography.Variant {
        switch kind {
        case .normal: .headline2
        case .floating: .headline2
        case .emphasized: .heading2
        }
    }

    var typoWeight: Typography.Weight {
        switch kind {
        case .normal: .bold
        case .floating: .bold
        case .emphasized: .bold
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

    fileprivate static func textButton(
        _ text: String,
        action: @escaping () -> Void
    ) -> some View {
        TextButton(color: .assistive, size: .medium, text: text, handler: action)
    }
}
