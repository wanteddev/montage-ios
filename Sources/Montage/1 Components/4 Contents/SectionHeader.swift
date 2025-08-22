//
//  SectionHeader.swift
//  Montage
//
//  Created by 김삼열 on 1/17/25.
//

import SwiftUI

/// 섹션 제목과 부가 정보를 표시하는 헤더 컴포넌트입니다.
///
/// `SectionHeader`는 콘텐츠를 논리적으로 구분하는 섹션 제목을 표시하며,
/// 선택적으로 추가 액션이나 정보를 제공할 수 있습니다.
///
/// ```swift
/// // 기본 섹션 헤더
/// SectionHeader(title: "추천 콘텐츠")
///
/// // 부제목이 있는 섹션 헤더
/// SectionHeader(title: "인기 영화", subtitle: "이번 주 TOP 10")
///
/// // 더보기 버튼이 있는 섹션 헤더
/// SectionHeader(title: "최신 업데이트", hasMoreButton: true) {
///     print("더보기 버튼 클릭됨")
/// }
///
/// // 커스텀 트레일링 컨텐츠가 있는 섹션 헤더
/// SectionHeader(title: "카테고리") {
///     Text("필터")
///         .font(.caption)
///         .foregroundColor(.blue)
/// }
/// ```
///
/// - Note: 본 컴포넌트는 타이틀, 서브타이틀, 더보기 버튼, 커스텀 트레일링 콘텐츠를
///   조합하여 다양한 형태의 섹션 헤더를 구성할 수 있습니다.
public struct SectionHeader: View {
    // MARK: - Types
    
    /// 섹션 헤더의 크기를 정의하는 열거형입니다.
    ///
    /// 콘텐츠의 중요도나 시각적 계층 구조에 따라 4가지 크기 옵션을 제공합니다.
    /// 각 크기는 서로 다른 폰트 크기와 높이를 가지며, 콘텐츠 구조에 맞게 선택할 수 있습니다.
    ///
    /// ```swift
    /// SectionHeader(title: "주요 기능")
    ///     .size(.large) // 큰 크기의 헤더 사용
    /// ```
    public enum Size {
        /// 가장 작은 크기
        case xsmall
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 큰 크기
        case large
    }
    
    // MARK: - Initializer
    
    private let title: String
    
    /// 섹션 헤더를 초기화합니다.
    ///
    /// - Parameters:
    ///   - title: 표시할 섹션 제목
    public init(title: String) {
        self.title = title
    }
    
    // MARK: - Body
    @State private var contentSize: CGSize = .zero
    
    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 16) {
                    Text(title)
                        .paragraphNew(variant: variant, weight: .bold, color: titleColor)
                        .multilineTextAlignment(.leading)
                        .layoutPriority(1)
                    
                    if let headingContent {
                        AnyView(headingContent())
                    }
                }
                    
                if let trailingContent {
                    Spacer(minLength: 16)
                    
                    AnyView(trailingContent())
                } else {
                    Spacer(minLength: 0)
                }
            }
            .frame(minHeight: height)
        }
    }
    
    // MARK: - Modifiers
    
    private var size: Size = .medium
    private var titleColor: SwiftUI.Color = .semantic(.labelStrong)
    private var headingContent: (() -> any View)? = nil
    private var trailingContent: (() -> any View)? = nil
    
    /// 섹션 헤더의 크기를 설정합니다.
    ///
    /// 크기에 따라 폰트 크기와 높이가 자동으로 조정됩니다.
    /// `xsmall` 크기를 선택하면 타이틀 색상이 `.labelAlternative`로 변경됩니다.
    ///
    /// - Parameters:
    ///   - size: 적용할 헤더 크기
    /// - Returns: 수정된 SectionHeader 인스턴스
    ///
    /// - Note: 기본값은 `.medium`입니다.
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        if size == .xsmall {
            zelf.titleColor = .semantic(.labelAlternative)
        }
        return zelf
    }
    
    /// 타이틀 텍스트의 색상을 설정합니다.
    ///
    /// - Parameters:
    ///   - color: 적용할 텍스트 색상
    /// - Returns: 수정된 SectionHeader 인스턴스
    ///
    /// - Note: 기본값은 `.semantic(.labelStrong)`입니다.
    public func titleColor(_ color: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.titleColor = color
        return zelf
    }
    
    /// 헤더 타이틀 옆에 추가 콘텐츠를 표시합니다.
    ///
    /// 타이틀 텍스트 바로 옆(오른쪽)에 추가 콘텐츠나 뱃지를 표시할 때 사용합니다.
    ///
    /// - Parameters:
    ///   - content: 표시할 콘텐츠를 생성하는 클로저
    /// - Returns: 수정된 SectionHeader 인스턴스
    public func headingContent(_ content: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.headingContent = content
        return zelf
    }

    /// 헤더의 오른쪽에 추가적인 콘텐츠를 표시합니다.
    ///
    /// 더보기 버튼이나 필터 등의 추가 기능을 제공할 때 사용합니다.
    ///
    /// - Parameters:
    ///   - content: 표시할 콘텐츠를 생성하는 클로저
    /// - Returns: 수정된 SectionHeader 인스턴스
    public func trailingContent(_ content: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.trailingContent = content
        return zelf
    }

    // MARK: - private
    private var variant: Typography.Variant {
        switch size {
        case .xsmall:
            .label1
        case .small:
            .headline2
        case .medium:
            .heading2
        case .large:
            .title3
        }
    }
    
    private var height: CGFloat {
        switch size {
        case .xsmall:
            20
        case .small:
            24
        case .medium:
            28
        case .large:
            32
        }
    }
}
