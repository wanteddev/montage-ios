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
///     .variant(.full)
/// ```
public struct Accordion: View {
    // MARK: - Types
    
    /// 아코디언이 놓이는 리스트(컨테이너)의 가장자리를 기준으로 한 아코디언의 형태입니다.
    ///
    /// 좌우 여백과 인터랙션 배경의 확장 폭·모서리 둥글기를 하나로 묶은 값으로, 세 값을 따로 지정할 수는 없습니다.
    /// 두 형태 모두 콘텐츠는 리스트 기준 같은 자리에 놓이고, 인터랙션 배경이 리스트 좌우 끝까지 닿는지만 달라집니다.
    public enum Variant: Equatable {
        /// 인터랙션 배경이 리스트 좌우 끝에 닿지 않고 안쪽에 둥글게 그려지는 형태입니다.
        ///
        /// 아코디언은 콘텐츠 폭을 그대로 쓰고 좌우 여백은 리스트가 줍니다.
        /// 인터랙션 배경만 헤더보다 좌우로 12 넓어지고 모서리가 12 둥글게 처리됩니다.
        case inset
        /// 인터랙션 배경이 리스트 좌우 끝까지 각지게 채우는 형태입니다.
        ///
        /// 아코디언이 리스트 폭을 채우고 좌우 여백 20을 직접 가지며, 인터랙션 배경은 헤더와 같은 크기로 그려집니다.
        case full

        /// 헤더와 펼친 콘텐츠의 좌우 여백.
        var horizontalPadding: CGFloat {
            switch self {
            case .inset: 0
            case .full: 20
            }
        }

        /// 인터랙션 배경이 헤더 경계 바깥으로 확장되는 좌우 크기.
        var interactionOutset: CGFloat {
            switch self {
            case .inset: 12
            case .full: 0
            }
        }

        /// 인터랙션 배경의 모서리 반경.
        var interactionRadius: CGFloat {
            switch self {
            case .inset: 12
            case .full: 0
            }
        }
    }
    
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
    ///   - description: 확장 시 표시될 설명 텍스트, 생략하면 기본값으로 `nil` 적용
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
    ///   - description: 확장 시 표시될 설명 텍스트, 생략하면 기본값으로 `nil` 적용
    ///   - content: 확장 시 표시될 커스텀 컨텐츠 뷰
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
    ) = (.body2, .bold, .semantic(.foregroundNeutralPrimary))
    private var descriptionTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (.label1, .regular, .semantic(.foregroundNeutralSecondary))
    private var verticalPadding: VerticalPadding = .large
    private var variant: Variant = .inset
    private var hideDivider = false
    private var leadingContent: (() -> AnyView)? = nil
    private var trailingContent: (Bool) -> AnyView = { _ in AnyView(EmptyView()) }
    
    /// 타이틀 텍스트의 타이포그래피 속성을 조정합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형, 생략하면 기본값으로 `.body2` 적용
    ///   - weight: 텍스트 굵기, 생략하면 기본값으로 `.bold` 적용
    ///   - color: 텍스트 색상, 생략하면 기본값으로 `.semantic(.foregroundNeutralPrimary)` 적용
    /// - Returns: 수정된 아코디언 인스턴스
    public func title(
        _ variant: Typography.Variant = .body2,
        weight: Typography.Weight = .bold,
        color: SwiftUI.Color = .semantic(.foregroundNeutralPrimary)
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
    ///   - variant: 텍스트 변형, 생략하면 기본값으로 `.label1` 적용
    ///   - weight: 텍스트 굵기, 생략하면 기본값으로 `.regular` 적용
    ///   - color: 텍스트 색상, 생략하면 기본값으로 `.semantic(.foregroundNeutralSecondary)` 적용
    /// - Returns: 수정된 아코디언 인스턴스
    public func description(
        _ variant: Typography.Variant = .label1,
        weight: Typography.Weight = .regular,
        color: SwiftUI.Color = .semantic(.foregroundNeutralSecondary)
    ) -> Self {
        var zelf = self
        zelf.descriptionTypography.variant = variant
        zelf.descriptionTypography.weight = weight
        zelf.descriptionTypography.color = color
        return zelf
    }
    
    /// 아코디언 헤더의 상하 여백 크기를 조정합니다.
    ///
    /// - Parameter verticalPadding: 상하 여백 크기, 생략하면 기본값으로 `.large` 적용
    /// - Returns: 수정된 아코디언 인스턴스
    public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
    /// 아코디언의 형태를 설정합니다.
    ///
    /// 아코디언의 좌우 여백과 인터랙션 효과(pressed 배경)의 확장 폭·모서리 둥글기가 함께 정해집니다.
    /// 두 형태의 차이는 ``Variant``를 참고하세요.
    ///
    /// ```swift
    /// // 리스트가 좌우 여백을 주는 경우 (기본값)
    /// Accordion(title: "아코디언 제목")
    ///
    /// // 아코디언이 리스트 폭을 채우는 경우
    /// Accordion(title: "아코디언 제목")
    ///     .variant(.full)
    /// ```
    ///
    /// - Parameter variant: 적용할 아코디언 형태, 생략하면 기본값으로 `.inset` 적용
    /// - Returns: 수정된 아코디언 인스턴스
    ///
    /// - Note: 4.0.0에서 제거된 `fillWidth(_:)`를 대체합니다.
    ///   `fillWidth(false)`는 ``Variant/inset``, `fillWidth(true)`는 ``Variant/full``에 대응합니다.
    public func variant(_ variant: Variant = .inset) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    /// 아코디언 하단의 구분선을 숨깁니다.
    ///
    /// - Parameter hideDivider: 구분선을 숨길지 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 아코디언 인스턴스
    public func hideDivider(_ hideDivider: Bool = true) -> Self {
        var zelf = self
        zelf.hideDivider = hideDivider
        return zelf
    }
    
    /// 아코디언 제목 앞에 아이콘을 추가합니다.
    ///
    /// `leadingContent { ... }`와 동일한 슬롯을 공유하므로, 두 모디파이어를 함께 호출하면 마지막에 호출된 쪽이 적용됩니다.
    ///
    /// - Parameters:
    ///   - leadingIcon: 표시할 아이콘, 생략하면 기본값으로 `nil` 적용
    ///   - color: 아이콘 색상, 생략하면 기본값으로 `nil` 적용 (기본 색상 사용)
    /// - Returns: 수정된 아코디언 인스턴스
    public func leadingIcon(_ leadingIcon: Icon? = nil, color: SwiftUI.Color? = nil) -> Self {
        var zelf = self
        if let leadingIcon {
            zelf.leadingContent = {
                AnyView(
                    Image.icon(leadingIcon)
                        .resizable()
                        .if(color != nil) { $0.foregroundStyle(color!) }
                        .padding(2)
                        .frame(width: 24, height: 24)
                )
            }
        } else {
            zelf.leadingContent = nil
        }
        return zelf
    }

    /// 아코디언 제목 앞에 커스텀 컨텐츠를 추가합니다.
    ///
    /// `leadingIcon`과 동일한 슬롯을 공유하므로, 두 모디파이어를 함께 호출하면 마지막에 호출된 쪽이 적용됩니다.
    ///
    /// - Parameter leadingContent: 표시할 커스텀 컨텐츠 뷰
    /// - Returns: 수정된 아코디언 인스턴스
    public func leadingContent<V: View>(@ViewBuilder _ leadingContent: @escaping () -> V) -> Self {
        var zelf = self
        zelf.leadingContent = { AnyView(leadingContent()) }
        return zelf
    }
    
    /// 아코디언 헤더 우측에 커스텀 컨텐츠를 추가합니다.
    ///
    /// 이 수정자를 사용하면 기본 화살표 아이콘이 대체됩니다.
    ///
    /// - Parameter trailingContent: 표시할 컨텐츠를 생성하는 클로저 (아코디언이 펼쳐진 상태를 파라미터로 받음)
    /// - Returns: 수정된 아코디언 인스턴스
    public func trailingContent<V: View>(@ViewBuilder _ trailingContent: @escaping (Bool) -> V) -> Self {
        var zelf = self
        zelf.trailingContent = { AnyView(trailingContent($0)) }
        return zelf
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    @State private var isExpanded = false
    @State private var trailingContentEmpty = true
    @State private var isContentEmpty = true
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 8) {
                    if let leadingContent {
                        leadingContent()
                    }

                    Text(title)
                        .paragraph(
                            variant: titleTypography.variant,
                            weight: titleTypography.weight,
                            color: titleTypography.color
                        )
                    Spacer(minLength: 0)
                    
                    trailingContent(isExpanded)
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
                .padding(.horizontal, variant.horizontalPadding)
                .modifier(ListCellInteractionModifier(
                    pressed: $isPressed,
                    outset: variant.interactionOutset,
                    radius: variant.interactionRadius
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
                                .paragraph(
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
                    .padding(.horizontal, variant.horizontalPadding)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(SwiftUI.Color.semantic(.lineNeutralTertiary))
                .background()
                .if(!hideDivider)
        }
    }
}
