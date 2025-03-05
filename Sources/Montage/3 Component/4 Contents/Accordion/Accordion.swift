//
//  Accordion.swift
//  Montage
//
//  Created by 김삼열 on 12/30/24.
//

import SwiftUI

public struct Accordion<A: View, C: View>: View {
    // MARK: - Types
    /// 상하 여백을 나타내는 열거형입니다.
    public enum VerticalPadding {
        case pt8
        case pt12
        case pt16
        
        public var length: CGFloat {
            switch self {
            case .pt8: 8
            case .pt12: 12
            case .pt16: 16
            }
        }
    }
    
    // MARK: - Initializer
    
    private let title: String
    private let description: String
    @ViewBuilder private let accessory: () -> A
    @ViewBuilder private let content: () -> C
    public init(
        title: String,
        description: String = "",
        accessory: @escaping () -> A = { EmptyView() },
        content: @escaping () -> C = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.accessory = accessory
        self.content = content
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    @State private var isExpanded = false
    @State private var accessorySize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Text(title)
                        .montage(
                            variant: titleTypography.variant,
                            weight: titleTypography.weight,
                            color: titleTypography.color
                        )
                        .paragraph(variant: titleTypography.variant)
                    Spacer(minLength: 0)
                    
                    accessory()
                        .onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { accessorySize = $0 }
                        )
                    
                    if accessorySize == .zero {
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
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isPressed = value.translation == .zero
                        }
                        .onEnded { value in
                            isPressed = false
                            if value.translation == .zero {
                                withAnimation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.3)) {
                                    isExpanded.toggle()
                                }
                            }
                        }
                )
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        if !description.isEmpty {
                            Text(description)
                                .montage(
                                    variant: descriptionTypography.variant,
                                    weight: descriptionTypography.weight,
                                    color: descriptionTypography.color
                                )
                                .paragraph(variant: descriptionTypography.variant)
                        }
                        
                        Spacer().frame(height: 12)
                            .if(!description.isEmpty && contentSize != .zero)
                        
                        content().onGeometryChange(
                            for: CGSize.self,
                            of: { $0.size },
                            action: { contentSize = $0 }
                        )
                    }
                    .padding(.bottom, description.isEmpty && contentSize == .zero ? 0 : 16)
                    .padding(.horizontal, fillWidth ? 20 : 0)
                }
            }
                
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(SwiftUI.Color.alias(.lineAlternative))
                .background()
                .if(divider)
        }
    }
    
    // MARK: - Modifiers
    
    private var titleTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (.body2, .bold, .alias(.labelNormal))
    private var descriptionTypography: (
        variant: Typography.Variant,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (.label1, .regular, .alias(.labelNeutral))
    private var verticalPadding: VerticalPadding = .pt12
    private var fillWidth = false
    private var divider = false
    
    /// 타이틀 텍스트의 `variant`, `weight`, `color` 속성을 조정합니다. 기본값은 각각 `.body2`, `.bold`, `.alias(.labelNormal)`입니다.
    public func title(
        _ variant: Typography.Variant = .body2,
        weight: Typography.Weight = .bold,
        color: SwiftUI.Color = .alias(.labelNormal)
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
        color: SwiftUI.Color = .alias(.labelNeutral)
    ) -> Self {
        var zelf = self
        zelf.descriptionTypography.variant = variant
        zelf.descriptionTypography.weight = weight
        zelf.descriptionTypography.color = color
        return zelf
    }
    
    /// 상하 여백의 크기를 조정합니다. 기본값은 `.pt12` 입니다.
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
    
    /// 아래에 구분선을 추가합니다. 기본값은 `false`입니다.
    public func divider(_ divider: Bool = true) -> Self {
        var zelf = self
        zelf.divider = divider
        return zelf
    }
}
