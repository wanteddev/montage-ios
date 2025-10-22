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
///     .title {
///         ModalNavigation.TitleView(variant: .normal, title: "제목")
///     }
///     .leadingContent {
///         // 뒤로가기 동작 컴포넌트
///     }
///     .trailingContents([
///         { /* 컴포넌트1 */ },
///         { /* 컴포넌트2 */ }
///     ])
/// ```
public struct ModalNavigation: View {
    // MARK: - Types
    
    /// 내비게이션 바의 외관을 정의하는 열거형입니다.
    public enum Variant: Equatable {
        /// 기본 스타일의 내비게이션 바
        case normal
        /// 제목이 별도 줄에 표시되는 확장된 스타일
        case extended
        /// 배경이 투명한 플로팅 스타일
        ///
        /// - Parameter alternative: 대체 아이콘 사용 여부 (기본값: false)
        /// - Parameter background: 배경 표시 여부 (기본값: true)
        case floating(alternative: Bool = false, background: Bool = true)
        /// 강조된 큰 제목 스타일
        case emphasized
        
        fileprivate var isFloating: Bool {
            switch self {
            case .floating: true
            case .normal, .extended, .emphasized: false
            }
        }
    }
    
    // MARK: - Initialisers

    @Binding private var scrollOffset: CGFloat
    
    /// 내비게이션 바를 초기화합니다.
    ///
    /// - Parameters:
    ///   - scrollOffset: 스크롤 오프셋 바인딩 (기본값: .constant(0))
    public init(scrollOffset: Binding<CGFloat> = .constant(0)) {
        _scrollOffset = scrollOffset
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
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
                    title: title,
                    leadingContent: leadingContent,
                    trailingContents: trailingContents
                )
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
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
    
    // MARK: - Modifiers
    
    private var variant: Variant = .normal
    private var backgroundColor: SwiftUI.Color = SwiftUI.Color.semantic(.backgroundNormal)
    private var needHandleArea = false
    private var title: () -> AnyView = { AnyView(EmptyView()) }
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
    
    /// 바텀 시트의 핸들 영역 필요 여부를 설정합니다.
    ///
    /// - Parameter needHandleArea: 핸들 영역 필요 여부
    /// - Returns: 수정된 내비게이션 바 뷰
    public func needHandleArea(_ needHandleArea: Bool) -> Self {
        var zelf = self
        zelf.needHandleArea = needHandleArea
        return zelf
    }
    
    /// 내비게이션 바의 타이틀 영역을 설정합니다.
    ///
    /// - Parameter content: 타이틀 영역에 표시될 콘텐츠
    /// - Returns: 수정된 내비게이션 바 뷰
    public func title<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.title = { AnyView(content()) }
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
        var title: () -> AnyView
        var leadingContent: () -> AnyView
        var trailingContents: [() -> AnyView]
        
        var body: some View {
            switch variant {
            case .normal, .extended, .floating:
                TopNavigation.Contents(
                    variant: variant.topNavigationVariant,
                    title: title,
                    leadingContent: leadingContent,
                    trailingContents: trailingContents
                )
            case .emphasized:
                ZStack {
                    HStack(spacing: 20) {
                        leadingContent()
                        title()
                        Spacer(minLength: 0)
                        Group {
                            ForEach(Array(trailingContents.enumerated()), id: \.offset) { _, makeView in
                                makeView()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ModalNavigation {
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
}

private extension ModalNavigation {
    var scrolled: Bool { scrollOffset < .zero }
    
    var backgroundOpacity: CGFloat {
        if variant.isFloating {
            return 0
        } else {
            let ratio = (scrollOffset / -32)
            return max(0, min(1, ratio))
        }
    }
}

private extension ModalNavigation.Variant {
    var topNavigationVariant: TopNavigation.Variant {
        switch self {
        case .normal: .normal
        case .extended: .extended
        case .floating(let alternative, let background): .floating(
            alternative: alternative,
            background: background
        )
        case .emphasized: .normal
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .normal: .headline2
        case .extended: .title3
        case .floating: .headline2
        case .emphasized: .heading2
        }
    }
    
    var typoWeight: Typography.Weight {
        switch self {
        case .normal: .bold
        case .extended: .bold
        case .floating: .bold
        case .emphasized: .bold
        }
    }
}
