//
//  Accordion.swift
//  Montage
//
//  Created by 김삼열 on 12/30/24.
//

import SwiftUI

/// 접을 수 있는 컨텐츠를 제공하는 아코디언 컴포넌트입니다.
///
/// `Accordion`은 제목과 함께 접을 수 있는 컨텐츠를 제공하는 컴포넌트입니다.
/// 제목을 탭하면 컨텐츠가 확장되거나 축소됩니다. 설명 텍스트와 커스텀 컨텐츠를 함께 표시할 수 있습니다.
///
/// 아코디언은 제한된 공간에서 많은 정보를 효율적으로 표시하기 위한 UI 패턴입니다.
/// 사용자는 관심 있는 항목만 확장하여 볼 수 있습니다.
///
/// ```swift
/// // 기본 사용법
/// Accordion(
///     title: "아코디언 제목",
///     description: "아코디언 설명 텍스트입니다."
/// )
///
/// // 커스텀 컨텐츠 추가
/// Accordion(
///     title: "커스텀 컨텐츠",
///     description: "설명 텍스트"
/// ) {
///     VStack(alignment: .leading, spacing: 8) {
///         Text("커스텀 컨텐츠 1")
///         Text("커스텀 컨텐츠 2")
///     }
/// }
///
/// // 스타일 커스터마이징
/// Accordion(title: "커스텀 스타일")
///     .title(.headline, weight: .semibold, color: .red)
///     .verticalPadding(.small)
///     .leadingIcon(.info)
///     .fillWidth()
/// ```
///
/// - Note: 아코디언은 기본적으로 하단에 구분선을 갖고 있으며, `hideDivider()` 수정자를 통해 제거할 수 있습니다.
public struct Accordion: View {
    // MARK: - Types
    
    /// 아코디언의 상하 여백을 나타내는 열거형입니다.
    ///
    /// 아코디언 헤더의 상하 패딩 값을 설정합니다.
    public enum VerticalPadding {
        /// 좁은 여백
        case small
        /// 중간 여백
        case medium
        /// 넓은 여백
        case large
        
        var length: CGFloat {
            switch self {
            case .small: 8
            case .medium: 12
            case .large: 16
            }
        }
    }
    
    // MARK: - Initializer
    
    private let title: String
    private let description: String?
    private let content: () -> AnyView
    
    /// 아코디언을 생성합니다.
    ///
    /// - Parameters:
    ///   - title: 아코디언의 제목
    ///   - description: 확장 시 표시될 설명 텍스트 (선택 사항)
    public init(
        title: String,
        description: String? = nil
    ) {
        self.title = title
        self.description = description
        self.content = { AnyView(EmptyView()) }
    }
    
    /// 아코디언을 생성합니다.
    ///
    /// - Parameters:
    ///   - title: 아코디언의 제목
    ///   - description: 확장 시 표시될 설명 텍스트 (선택 사항)
    ///   - content: 확장 시 표시될 커스텀 컨텐츠 뷰 (선택 사항)
    public init<V: View>(
        title: String,
        description: String? = nil,
        @ViewBuilder content: @escaping () -> V
    ) {
        self.title = title
        self.description = description
        self.content = { AnyView(content()) }
    }
    
    // MARK: - Modifiers
    
    private var titleTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (.body2, .bold, .semantic(.labelNormal))
    private var descriptionTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (.label1, .regular, .semantic(.labelNeutral))
    private var verticalPadding: VerticalPadding = .large
    private var fillWidth = false
    private var hideDivider = false
    private var leadingIcon: Icon? = nil
    private var leadingIconColor: SwiftUI.Color? = nil
    private var trailingContent: () -> AnyView = { AnyView(EmptyView()) }
    
    /// 타이틀 텍스트의 타이포그래피 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형 (기본값: .body2)
    ///   - weight: 텍스트 굵기 (기본값: .bold)
    ///   - color: 텍스트 색상 (기본값: .semantic(.labelNormal))
    /// - Returns: 수정된 아코디언 인스턴스
    public func title(
        _ variant: Typography.Variant = .body2,
        weight: Typography.Weight = .bold,
        color: SwiftUI.Color = .semantic(.labelNormal)
    ) -> Self {
        var zelf = self
        zelf.titleTypography.variant = variant
        zelf.titleTypography.weight = weight
        zelf.titleTypography.color = color
        return zelf
    }
    
    /// 설명 텍스트의 타이포그래피 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형 (기본값: .label1)
    ///   - weight: 텍스트 굵기 (기본값: .regular)
    ///   - color: 텍스트 색상 (기본값: .semantic(.labelNeutral))
    /// - Returns: 수정된 아코디언 인스턴스
    public func description(
        _ variant: Typography.Variant = .label1,
        weight: Typography.Weight = .regular,
        color: SwiftUI.Color = .semantic(.labelNeutral)
    ) -> Self {
        var zelf = self
        zelf.descriptionTypography.variant = variant
        zelf.descriptionTypography.weight = weight
        zelf.descriptionTypography.color = color
        return zelf
    }
    
    /// 아코디언 헤더의 상하 여백 크기를 조정합니다.
    ///
    /// - Parameter verticalPadding: 상하 여백 크기 (기본값: .large)
    /// - Returns: 수정된 아코디언 인스턴스
    public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
    /// 아코디언이 부모 컨테이너의 너비를 채우도록 설정합니다.
    ///
    /// 이 수정자를 적용하면 좌우 20pt의 여백이 추가됩니다.
    ///
    /// - Parameter fillWidth: 너비를 채울지 여부
    /// - Returns: 수정된 아코디언 인스턴스
    public func fillWidth(_ fillWidth: Bool = true) -> Self {
        var zelf = self
        zelf.fillWidth = fillWidth
        return zelf
    }
    
    /// 아코디언 하단의 구분선을 숨깁니다.
    ///
    /// - Parameter hideDivider: 구분선을 숨길지 여부 (기본값: `true`)
    /// - Returns: 수정된 아코디언 인스턴스
    public func hideDivider(_ hideDivider: Bool = true) -> Self {
        var zelf = self
        zelf.hideDivider = hideDivider
        return zelf
    }
    
    /// 아코디언 제목 앞에 아이콘을 추가합니다.
    ///
    /// - Parameters:
    ///   - leadingIcon: 표시할 아이콘
    ///   - color: 아이콘 색상 (기본값: nil - 기본 색상 사용)
    /// - Returns: 수정된 아코디언 인스턴스
    public func leadingIcon(_ leadingIcon: Icon? = nil, color: SwiftUI.Color? = nil) -> Self {
        var zelf = self
        zelf.leadingIcon = leadingIcon
        zelf.leadingIconColor = color
        return zelf
    }
    
    /// 아코디언 헤더 우측에 커스텀 컨텐츠를 추가합니다.
    ///
    /// 이 수정자를 사용하면 기본 화살표 아이콘이 대체됩니다.
    ///
    /// - Parameter trailingContent: 표시할 커스텀 컨텐츠 뷰
    /// - Returns: 수정된 아코디언 인스턴스
    public func trailingContent<V: View>(@ViewBuilder _ trailingContent: @escaping () -> V) -> Self {
        var zelf = self
        zelf.trailingContent = { AnyView(trailingContent()) }
        return zelf
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    @State private var isExpanded = false
    @State private var trailingContentEmpty = true
    @State private var isContentEmpty = true
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 8) {
                    if let leadingIcon {
                        Image.icon(leadingIcon)
                            .resizable()
                            .if(leadingIconColor != nil) {
                                $0.foregroundStyle(leadingIconColor!)
                            }
                            .padding(2)
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(title)
                        .paragraphNew(
                            variant: titleTypography.variant,
                            weight: titleTypography.weight,
                            color: titleTypography.color
                        )
                    Spacer(minLength: 0)
                    
                    trailingContent()
                        .ifEmptyView { trailingContentEmpty = $0 }
                    
                    if trailingContentEmpty {
                        Image.icon(.chevronDown)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(2)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .frame(minHeight: 24)
                .padding(.vertical, verticalPadding.length)
                .contentShape(Rectangle())
                .padding(.horizontal, fillWidth ? 20 : 0)
                .modifier(CellInteractionModifier(
                    pressed: $isPressed,
                    fillWidth: fillWidth,
                    interactionPadding: 12
                ))
                .modifier(PressActionDetectingModifier(isPressed: $isPressed) {
                    withAnimation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.3)) {
                        isExpanded.toggle()
                    }
                })
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        if let description, !description.isEmpty {
                            Text(description)
                                .paragraphNew(
                                    variant: descriptionTypography.variant,
                                    weight: descriptionTypography.weight,
                                    color: descriptionTypography.color
                                )
                        }
                        
                        if !description.isNilOrEmpty && !isContentEmpty {
                            Spacer(minLength: 12)
                        }
                        
                        content()
                            .ifEmptyView { isContentEmpty = $0 }
                    }
                    .padding(.bottom, description.isNilOrEmpty && isContentEmpty ? 0 : 16)
                    .padding(.horizontal, fillWidth ? 20 : 0)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(SwiftUI.Color.semantic(.lineAlternative))
                .background()
                .if(!hideDivider)
        }
    }
}
