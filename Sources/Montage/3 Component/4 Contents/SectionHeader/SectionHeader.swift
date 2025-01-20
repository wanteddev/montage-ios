//
//  SectionHeader.swift
//  Montage
//
//  Created by 김삼열 on 1/17/25.
//

import SwiftUI

public struct SectionHeader<C: View>: View {
    // MARK: - Types
    
    /// 사이즈를 나타내는 열거형입니다.
    public enum Size: String, CaseIterable {
        case xsmall, small, medium, large
    }
    
    // MARK: - Initializer
    
    private let title: String
    @ViewBuilder private let content: () -> C
    public init(title: String, content: @escaping () -> C = { EmptyView() }) {
        self.title = title
        self.content = content
    }
    
    // MARK: - Body
    @State private var contentSize: CGSize = .zero
    
    public var body: some View {
        ZStack {
            content()
                .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
                .opacity(0)
            HStack(spacing: 0) {
                Text(title)
                    .montage(
                        variant: titleTypography.variant ?? variant,
                        weight: titleTypography.weight,
                        color: titleTypography.color
                    )
                    .paragraph(variant: variant)
                    .multilineTextAlignment(.leading)
                if contentSize == .zero {
                    Spacer(minLength: 0)
                } else {
                    content()
                        .padding(.leading, 10)
                }
            }
            .frame(minHeight: height)
        }
    }
    
    // MARK: - Modifiers
    
    private var size: Size = .medium {
        didSet {
            titleTypography.variant = variant
        }
    }
    private var titleTypography: (
        variant: Typography.Variant?,
        weight: Typography.Weight,
        color: SwiftUI.Color
    ) = (nil, .bold, .alias(.labelStrong))
    
    /// 사이즈를 조정합니다.
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 타이틀 텍스트의 `variant`, `weight`, `color` 속성을 조정합니다. 기본값은 각각 `.body2`, `.regular`, `.alias(.labelNormal)`입니다.
    public func title(
        _ variant: Typography.Variant? = nil,
        weight: Typography.Weight = .bold,
        color: SwiftUI.Color = .alias(.labelStrong)
    ) -> Self {
        var zelf = self
        zelf.titleTypography.variant = variant
        zelf.titleTypography.weight = weight
        zelf.titleTypography.color = color
        return zelf
    }

    // MARK: - private
    private var variant: Typography.Variant {
        switch size {
        case .xsmall:
            return .label1
        case .small:
            return .headline2
        case .medium:
            return .heading2
        case .large:
            return .title3
        }
    }
    
    private var height: CGFloat {
        switch size {
        case .xsmall:
            return 20
        case .small:
            return 24
        case .medium:
            return 28
        case .large:
            return 32
        }
    }
}
