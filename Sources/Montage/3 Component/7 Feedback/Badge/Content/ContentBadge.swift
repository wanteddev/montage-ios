//
//  ContentBadge.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import SwiftUI

public struct ContentBadge: View {
    /// 뱃지의 외관을 결정하는 열거형 타입입니다.
    public enum Variant {
        case solid, outlined
    }
    
    /// 뱃지의 사이즈를 결정하는 열거형입니다.
    public enum Size: String, CaseIterable {
        case xsmall, small, medium
    }
    
    /// 뱃지의 색상을 결정하는 열거형입니다.
    public enum ColorStyle: Equatable, Hashable, CaseDescribable {
        case neutral(_ contentColor: SwiftUI.Color? = nil)
        case accent(_ contentColor: SwiftUI.Color, background: SwiftUI.Color? = nil)
    }
    
    private let variant: Variant
    
    public init(variant: Variant = .solid, text: String) {
        self.variant = variant
        self.text = text
    }
    
    // MARK: - Modifiers
    
    private var size: Size = .small
    private var colorStyle: ColorStyle = .neutral()
    private var leadingIcon: Icon? = nil
    private var trailingIcon: Icon? = nil
    private var text: String
    
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    public func colorStyle(_ colorStyle: ColorStyle) -> Self {
        var zelf = self
        zelf.colorStyle = colorStyle
        return zelf
    }
    
    public func leadingIcon(_ leadingIcon: Icon) -> Self {
        var zelf = self
        zelf.leadingIcon = leadingIcon
        return zelf
    }
    
    public func trailingIcon(_ trailingIcon: Icon) -> Self {
        var zelf = self
        zelf.trailingIcon = trailingIcon
        return zelf
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: contentItemSpacing) {
            if let leadingIcon {
                Image.montage(leadingIcon)
                    .resizable()
                    .foregroundStyle(contentColor)
                    .frame(width: iconSize.width, height: iconSize.height)
            }
            Text(text)
                .montage(variant: typoVariant, weight: .medium, color: contentColor)
            if let trailingIcon {
                Image.montage(trailingIcon)
                    .resizable()
                    .foregroundStyle(contentColor)
                    .frame(width: iconSize.width, height: iconSize.height)
            }
        }
        .padding(contentEdgeInsets)
        .background {
            if variant == .solid {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            }
        }
    }
}

private extension ContentBadge {
    var iconSize: CGSize {
        switch size {
        case .xsmall:
            .init(width: 12, height: 12)
        case .small:
            .init(width: 14, height: 14)
        case .medium:
            .init(width: 16, height: 16)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .xsmall:
            .caption2
        case .small:
            .caption1
        case .medium:
            .label2
        }
    }
    
    var contentColor: SwiftUI.Color {
        switch colorStyle {
        case .neutral(let contentColor):
            return contentColor ?? .semantic(.labelAlternative)
        case let .accent(contentColor, _):
            return contentColor
        }
    }
    
    var backgroundColor: SwiftUI.Color {
        switch colorStyle {
        case .neutral:
            return variant == .solid ? .semantic(.fillNormal) : .clear
        case let .accent(contentColor, backgroundColor):
            return (backgroundColor ?? contentColor).opacity(0.08)
        }
    }
    
    var contentEdgeInsets: EdgeInsets {
        switch size {
        case .xsmall:
            .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        case .small:
            .init(top: 4, leading: 6, bottom: 4, trailing: 6)
        case .medium:
            .init(top: 5, leading: 8, bottom: 5, trailing: 8)
        }
    }
    
    var contentItemSpacing: CGFloat {
        switch size {
        case .xsmall:
            2
        case .small:
            3
        case .medium:
            4
        }
    }
    
    var borderColor: SwiftUI.Color {
        switch colorStyle {
        case .neutral:
            return variant == .solid ? .clear : .semantic(.lineNormal)
        case let .accent(contentColor, backgroundColor):
            return (backgroundColor ?? contentColor).opacity(0.43)
        }
    }
    
    var borderWidth: CGFloat {
        variant == .outlined ? 1 : 0
    }
    
    var cornerRadius: CGFloat {
        switch size {
        case .xsmall:
            6.0
        case .small:
            6.0
        case .medium:
            8.0
        }
    }
}
