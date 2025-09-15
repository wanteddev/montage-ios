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
/// ModalNavigation(title: "제목")
///     .variant(.normal)
///     leading: {
///         // 뒤로가기 동작 컴포넌트
///     },
///     trailing: [
///         {
///           // 컴포넌트1
///         },
///         {
///           // 컴포넌트2
///         },
///         ...
///     ]
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
    
    private let title: String
    @Binding private var scrollOffset: CGFloat
    
    /// 내비게이션 바를 초기화합니다.
    ///
    /// - Parameters:
    ///   - title: 내비게이션 바에 표시할 제목
    ///   - scrollOffset: 스크롤 오프셋에 대한 바인딩 (기본값: .constant(0))
    public init(
        title: String,
        scrollOffset: Binding<CGFloat> = .constant(0),
        leading: (() -> any View)? = nil
    ) {
        self.title = title
        _scrollOffset = scrollOffset
        self.leading = leading.map { view in { AnyView(view()) } } ?? { AnyView(EmptyView()) }
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Contents(
                variant: variant,
                title: title,
                leading: leading,
                trailings: trailings
            )
            .if(needHandleArea) {
                $0.padding(.top, 10)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
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
    private var backgroundColor: SwiftUI.Color? = nil
    private var needHandleArea = false
    private var leading: () -> AnyView
    private var trailings: [() -> AnyView] = []
    
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
    
    /// 내비게이션 바의 왼쪽 버튼 영역을 설정합니다.
    ///
    /// - Parameter content: 왼쪽에 노출될 컨텐츠
    /// - Returns: 수정된 내비게이션 바 뷰
    public func leading<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.leading = leading
        return zelf
    }
    
    /// 내비게이션 바의 오른쪽 버튼 영역을 설정합니다.
    ///
    /// - Parameter contents: 오른쪽에 노출될 컨텐츠 배열 (최대 3개까지 표시)
    /// - Returns: 수정된 내비게이션 바 뷰
    public func trailings<V: View>(_ contents: [() -> V]) -> Self {
        var zelf = self
        zelf.trailings = contents.prefix(3).map { view in { AnyView(view()) } }
        return zelf
    }
    
    private struct Contents: View {
        var variant: Variant
        var title: String
        var leading: () -> AnyView
        var trailings: [() -> AnyView]
        
        var body: some View {
            switch variant {
            case .normal, .extended, .floating:
                TopNavigation.Contents(
                    variant: variant.topNavigationVariant,
                    title: title,
                    leading: leading,
                    trailings: trailings
                )
            case .emphasized:
                ZStack {
                    HStack(spacing: 20) {
                        leading()
                        Text(title)
                            .paragraphNew(
                                variant: variant.typoVariant,
                                weight: variant.typoWeight,
                                semantic: .labelStrong
                            )
                            .lineLimit(1)
                            .frame(height: 24, alignment: variant.textAlignment)
                        Spacer(minLength: 0)
                        Group {
                            ForEach(trailings.indices, id: \.self) { i in
                                trailings[i]()
                            }
                        }
                    }
                }
            }
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
    
    var textAlignment: Alignment {
        switch self {
        case .normal: .center
        case .extended: .leading
        case .floating: .center
        case .emphasized: .leading
        }
    }
}
