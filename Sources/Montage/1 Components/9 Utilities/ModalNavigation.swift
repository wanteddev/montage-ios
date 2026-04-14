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
/// ```swift
/// ModalNavigation()
///     .variant(.normal)
///     .titleView {
///         Text("제목").bold()
///     }
///     .leadingContent {
///         // 뒤로가기 동작 컴포넌트
///     }
///     .trailingContents(
///         { /* 컴포넌트1 */ },
///         { /* 컴포넌트2 */ }
///     )
/// ```
public struct ModalNavigation: View {
    // MARK: - Types
    
    /// 내비게이션 바의 외관을 정의하는 구조체입니다.
    public struct Variant: Equatable, CustomStringConvertible {
        fileprivate enum Kind: Equatable {
            case normal, display, extended, floating, emphasized
        }
        
        fileprivate let kind: Kind
        
        /// 기본 스타일의 내비게이션 바
        public static let normal = Variant(kind: .normal)
        /// 제목이 별도 줄에 표시되는 확장된 스타일
        public static let display = Variant(kind: .display)
        /// 플로팅 스타일 (그라디언트, Progressive Blur 적용)
        public static let floating = Variant(kind: .floating)
        /// 강조된 큰 제목 스타일
        public static let emphasized = Variant(kind: .emphasized)
        
        /// 제목이 별도 줄에 표시되는 확장된 스타일
        @available(*, deprecated, renamed: "display", message: "이름이 `display`로 변경되었습니다. 다음 메이저 업데이트 때 제거될 예정입니다.")
        public static let extended = Variant(kind: .extended)
        
        /// 플로팅 스타일
        @available(*, deprecated, message: "파라메터 제거되었습니다. `.floating`으로 사용하십시오. 다음 메이저 업데이트 때 제거될 예정입니다.")
        public static func floating(alternative: Bool = false, background: Bool = true) -> Variant {
            Variant(kind: .floating)
        }
        
        fileprivate var isFloating: Bool { kind == .floating }
        
        public var description: String {
            switch kind {
            case .normal: "normal"
            case .display: "display"
            case .extended: "extended"
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
                        .foregroundStyle(SwiftUI.Color.semantic(.fillStrong))
                        .frame(width: 40, height: 5)
                }
            }
            
            Contents(
                variant: variant,
                titleText: titleText,
                titleView: titleView,
                leadingContent: leadingContent,
                trailingContents: trailingContents
            )
            .padding(.top, variant.contentTopPadding)
            .padding(.bottom, variant.contentBottomPadding)
        }
        .background {
            ZStack {
                if isMaterialBackgroundDisabled {
                    SwiftUI.Color.semantic(.backgroundNormal)
                        .opacity(backgroundOpacity)
                } else {
                    Rectangle().fill(.ultraThinMaterial)
                        .opacity(backgroundOpacity)
                    SwiftUI.Color.semantic(.backgroundNormal)
                        .opacity(backgroundOpacity * 0.7)
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
    private var backgroundColor: SwiftUI.Color = SwiftUI.Color.semantic(.backgroundNormal)
    private var isMaterialBackgroundDisabled = false
    private var fixedBackgroundOpacity: CGFloat?
    private var needHandleArea = false
    private var titleText: String?
    private var titleView: () -> AnyView = { AnyView(EmptyView()) }
    private var leadingContent: () -> AnyView = { AnyView(EmptyView()) }
    private var trailingContents: [() -> AnyView] = []
    
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
    
    /// 내비게이션 바의 왼쪽 버튼 영역을 설정합니다.
    ///
    /// - Parameter content: 왼쪽에 노출될 컨텐츠
    /// - Returns: 수정된 내비게이션 바 뷰
    public func leadingContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.leadingContent = { AnyView(content()) }
        return zelf
    }
    
    /// 내비게이션 바의 오른쪽 버튼 영역을 설정합니다.
    ///
    /// 최대 3개까지의 뷰를 클로저 배열로 전달할 수 있으며,
    /// 각 클로저는 다양한 타입의 View를 반환할 수 있습니다 (`any View`).
    /// 내부적으로는 모든 View를 `AnyView`로 타입을 지운 후 렌더링합니다.
    ///
    /// - Parameter contents: 오른쪽에 노출될 컨텐츠 배열 (최대 3개까지 표시)
    /// - Returns: 수정된 내비게이션 바 뷰
    public func trailingContents(_ contents: [() -> any View]) -> Self {
        var zelf = self
        zelf.trailingContents = contents.prefix(3).map { content in { AnyView(content()) } }
        return zelf
    }
    
    /// 내비게이션 바의 오른쪽 버튼 영역을 설정합니다.
    ///
    /// 이 메서드는 배열 버전(`trailingContents(_:)`)에 대한 편의 오버로딩입니다.
    ///
    /// - Parameter contents: 오른쪽에 노출될 컨텐츠 클로저들 (최대 3개까지 표시)
    /// - Returns: 수정된 내비게이션 바 뷰
    public func trailingContents(_ contents: (() -> any View)...) -> Self {
        trailingContents(contents)
    }
    
    private struct Contents: View {
        var variant: Variant
        var titleText: String?
        var titleView: () -> AnyView
        var leadingContent: () -> AnyView
        var trailingContents: [() -> AnyView]
        
        var body: some View {
            switch variant.kind {
            case .normal, .display, .extended, .floating:
                TopNavigation.Contents(
                    variant: variant.topNavigationVariant,
                    titleText: titleText,
                    titleView: titleView,
                    leadingContent: leadingContent,
                    trailingContents: trailingContents
                )
            case .emphasized:
                ZStack {
                    HStack(spacing: 20) {
                        leadingContent()
                        titleContent
                        Spacer(minLength: 0)
                        Group {
                            ForEach(Array(trailingContents.enumerated()), id: \.offset) { _, makeView in
                                makeView()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        
        @ViewBuilder
        private var titleContent: some View {
            if let titleText {
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
                    semantic: .labelStrong
                )
                .lineLimit(1)
                .padding(.horizontal, 4)
        }
    }
}

private extension ModalNavigation {
    var backgroundOpacity: CGFloat {
        if variant.isFloating {
            return 1
        } else {
            let ratio = (scrollOffset / -32)
            return fixedBackgroundOpacity ?? max(0, min(1, ratio))
        }
    }
    
    var gradientMaskColors: [SwiftUI.Color] {
        [0, 0.7, 1].map { SwiftUI.Color.black.opacity($0) }
    }
}

private extension ModalNavigation.Variant {
    var contentTopPadding: CGFloat {
        switch kind {
        case .normal: 10
        case .display, .extended: 4
        case .emphasized: 20
        case .floating: 4
        }
    }
    
    var contentBottomPadding: CGFloat {
        switch kind {
        case .normal: 10
        case .display, .extended: 4
        case .emphasized: 20
        case .floating: 8
        }
    }
    
    var topNavigationVariant: TopNavigation.Variant {
        switch kind {
        case .normal: .normal
        case .display, .extended: .display
        case .floating: .floating
        case .emphasized: .normal
        }
    }
    
    var typoVariant: Typography.Variant {
        switch kind {
        case .normal: .headline2
        case .display, .extended: .title3
        case .floating: .headline2
        case .emphasized: .heading2
        }
    }
    
    var typoWeight: Typography.Weight {
        switch kind {
        case .normal: .bold
        case .display, .extended: .bold
        case .floating: .bold
        case .emphasized: .bold
        }
    }
}
