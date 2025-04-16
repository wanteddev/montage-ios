//
//  Accordion.swift
//  Montage
//
//  Created by 김삼열 on 12/30/24.
//

import SwiftUI

public struct Accordion: View {
    // MARK: - Types
    /// 상하 여백을 나타내는 열거형입니다.
    public enum VerticalPadding {
        case small
        case medium
        case large
        
        public var length: CGFloat {
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
    @ViewBuilder private let content: (() -> any View)?
    
    public init(
        title: String,
        description: String? = nil,
        content: (() -> any View)? = nil
    ) {
        self.title = title
        self.description = description
        self.content = content
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
    private var trailingContent: (() -> any View)? = nil
    
    /// 타이틀 텍스트의 `variant`, `weight`, `color` 속성을 조정합니다. 기본값은 각각 `.body2`, `.bold`, `.semantic(.labelNormal)`입니다.
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
    
    /// 타이틀 텍스트의 `variant`와 `weight` 속성을 조정합니다. 기본값은 각각 `.label1`, `.regular`입니다.
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
    
    /// 상하 여백의 크기를 조정합니다. 기본값은 `.large` 입니다.
    public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
    /// 좌우 여백 여부를 조정합니다. 기본값은 `false`입니다.
    public func fillWidth(_ fillWidth: Bool = true) -> Self {
        var zelf = self
        zelf.fillWidth = fillWidth
        return zelf
    }
    
    /// 아래에 구분선을 제거합니다. 기본값은 `false`입니다.
    public func hideDivider(_ hideDivider: Bool = true) -> Self {
        var zelf = self
        zelf.hideDivider = hideDivider
        return zelf
    }
    
    public func leadingIcon(_ leadingIcon: Icon? = nil, color: SwiftUI.Color? = nil) -> Self {
        var zelf = self
        zelf.leadingIcon = leadingIcon
        zelf.leadingIconColor = color
        return zelf
    }
    
    public func trailingContent(_ trailingContent: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.trailingContent = trailingContent
        return zelf
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    @State private var isExpanded = false
    @State private var trailingContentSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 8) {
                    if let leadingIcon {
                        Image.montage(leadingIcon)
                            .resizable()
                            .if(leadingIconColor != nil) {
                                $0.foregroundStyle(leadingIconColor!)
                            }
                            .padding(2)
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(title)
                        .montage(
                            variant: titleTypography.variant,
                            weight: titleTypography.weight,
                            color: titleTypography.color
                        )
                        .paragraph(variant: titleTypography.variant)
                    Spacer(minLength: 0)
                    
                    Group {
                        if let trailingContent {
                            AnyView(trailingContent())
                        }
                    }
                    .onGeometryChange(
                        for: CGSize.self,
                        of: { $0.size },
                        action: { trailingContentSize = $0 }
                    )
                    
                    if trailingContentSize == .zero {
                        Image.montage(.chevronDown)
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
                                .montage(
                                    variant: descriptionTypography.variant,
                                    weight: descriptionTypography.weight,
                                    color: descriptionTypography.color
                                )
                                .paragraph(variant: descriptionTypography.variant)
                        }
                        
                        Spacer().frame(height: 12)
                            .if(description.isNilOrEmpty == false && contentSize != .zero)
                        
                        Group {
                            if let content {
                                AnyView(content())
                            }
                        }
                        .onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { contentSize = $0 }
                        )
                    }
                    .padding(.bottom, description.isNilOrEmpty && contentSize == .zero ? 0 : 16)
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
