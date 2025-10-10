//
//  ContentBadge.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import SwiftUI

/// 텍스트와 아이콘을 포함할 수 있는 뱃지 컴포넌트입니다.
///
/// 다양한 크기와 스타일, 색상을 제공하며 텍스트 앞뒤로 아이콘을 추가할 수 있습니다.
/// 솔리드와 아웃라인 스타일을 지원합니다.
///
/// ```swift
/// // 기본 솔리드 뱃지
/// ContentBadge(text: "New")
///
/// // 아웃라인 스타일 뱃지
/// ContentBadge(variant: .outlined, text: "Updated")
///     .size(.medium)
///     .colorStyle(.accent(SwiftUI.Color.blue))
///     .leadingIcon(.check)
/// ```
public struct ContentBadge: View {
    /// 뱃지의 외관을 결정하는 열거형 타입입니다.
    public enum Variant {
        /// 색상이 채워진 배경을 가진 뱃지
        case solid
        /// 테두리만 있는 뱃지
        case outlined
    }
    
    /// 뱃지의 사이즈를 결정하는 열거형입니다.
    ///
    /// - xsmall: 가장 작은 크기의 뱃지 (높이 22pt)
    /// - small: 중간 크기의 뱃지 (높이 24pt)
    /// - medium: 큰 크기의 뱃지 (높이 28pt)
    public enum Size {
        case xsmall, small, medium
    }
    
    /// 뱃지의 색상을 결정하는 열거형입니다.
    ///
    /// ```swift
    /// ContentBadge(text: "이벤트")
    ///     .colorStyle(.accent(SwiftUI.Color.red))
    /// ```
    public enum ColorStyle: Equatable, Hashable {
        /// 중립 색상 뱃지
        /// - Parameter contentColor: 콘텐츠 색상 (nil일 경우 기본 색상 사용)
        case neutral(_ contentColor: SwiftUI.Color? = nil)
        
        /// 강조 색상 뱃지
        /// - Parameters:
        ///   - contentColor: 콘텐츠 색상
        ///   - background: 배경 색상 (nil일 경우 contentColor의 투명도를 조절하여 사용)
        case accent(_ contentColor: SwiftUI.Color, background: SwiftUI.Color? = nil)
    }
    
    private let variant: Variant
    
    /// ContentBadge를 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 뱃지의 스타일 (solid 또는 outlined)
    ///   - text: 뱃지에 표시할 텍스트
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
    
    /// 뱃지의 크기를 설정합니다.
    ///
    /// - Parameter size: 뱃지 크기
    /// - Returns: 변경된 크기가 적용된 ContentBadge
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 뱃지의 색상 스타일을 설정합니다.
    ///
    /// - Parameter colorStyle: 색상 스타일
    /// - Returns: 변경된 색상 스타일이 적용된 ContentBadge
    public func colorStyle(_ colorStyle: ColorStyle) -> Self {
        var zelf = self
        zelf.colorStyle = colorStyle
        return zelf
    }
    
    /// 뱃지 텍스트 앞에 표시될 아이콘을 설정합니다.
    ///
    /// - Parameter leadingIcon: 선행 아이콘
    /// - Returns: 선행 아이콘이 추가된 ContentBadge
    public func leadingIcon(_ leadingIcon: Icon) -> Self {
        var zelf = self
        zelf.leadingIcon = leadingIcon
        return zelf
    }
    
    /// 뱃지 텍스트 뒤에 표시될 아이콘을 설정합니다.
    ///
    /// - Parameter trailingIcon: 후행 아이콘
    /// - Returns: 후행 아이콘이 추가된 ContentBadge
    public func trailingIcon(_ trailingIcon: Icon) -> Self {
        var zelf = self
        zelf.trailingIcon = trailingIcon
        return zelf
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: contentItemSpacing) {
            if let leadingIcon {
                Image.icon(leadingIcon)
                    .resizable()
                    .foregroundStyle(contentColor)
                    .frame(width: iconSize.width, height: iconSize.height)
            }
            Text(text)
                .typography(variant: typoVariant, weight: .medium, color: contentColor)
            if let trailingIcon {
                Image.icon(trailingIcon)
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
