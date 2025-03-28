//
//  Cell.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

public struct Cell: View {
    // MARK: - Types
    /// 상하 여백을 나타내는 열거형입니다.
    public enum VerticalPadding: String, CaseIterable {
        case none
        case small
        case medium
        case large
        
        public var length: CGFloat {
            switch self {
            case .none: 0
            case .small: 8
            case .medium: 12
            case .large: 16
            }
        }
    }
    
    // MARK: - Initializer
    
    private let title: String
    private let onTap: (() -> Void)?
    
    public init(
        title: String,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.onTap = onTap
    }
    
    // MARK: - Body
    @State private var isPressed = false
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                HStack(alignment: verticalAlignment, spacing: 8) {
                    if let leadingContent {
                        AnyView(leadingContent())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Group {
                            titleView
                        }
                        .frame(minHeight: 24)
                        .if(textEllipsis) {
                            $0.lineLimit(2)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let caption {
                            Text(caption)
                                .montage(
                                    variant: .label2,
                                    semantic: disable ? .labelDisable : .labelAlternative
                                )
                                .paragraph(variant: .label2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if let trailingContent {
                        AnyView(trailingContent(active))
                    }
                    
                    VStack {
                        Image.montage(.chevronRightTightSmall)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                            .frame(width: 8, height: 16)
                            .padding(.vertical, 4)
                    }
                    .frame(maxHeight: .infinity)
                    .if(chevron)
                }
            }
            .padding(.vertical, verticalPadding.length)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(SwiftUI.Color.semantic(.lineAlternative))
                .background()
                .if(divider)
        }
        .padding(.horizontal, fillWidth ? 20 : 0)
        .modifier(CellInteractionModifier(
            pressed: $isPressed,
            fillWidth: fillWidth,
            interactionPadding: interactionPadding
        ))
        .contentShape(Rectangle())
        .allowsHitTesting(disable == false)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPressed = value.translation == .zero
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .onTapGesture {
            onTap?()
        }
    }
    
    // MARK: - Modifiers
    
    private var titleTypography: (variant: Typography.Variant, weight: Typography.Weight) = (.body1, .regular)
    private var verticalPadding: VerticalPadding = .medium
    private var fillWidth = false
    private var textEllipsis = false
    private var caption: String? = nil
    private var disable = false
    private var active = false
    private var divider = false
    private var chevron = false
    private var leadingContent: (() -> any View)? = nil
    private var trailingContent: ((Bool) -> any View)? = nil
    private var interactionPadding: CGFloat = 12
    private var verticalAlignment: VerticalAlignment = .top
    private var highlightText: String? = nil
    
    /// 타이틀 텍스트의 `variant` 속성을 조정합니다. 기본값은 `.body1`입니다.
    public func titleVariant(_ variant: Typography.Variant) -> Self {
        var zelf = self
        zelf.titleTypography.variant = variant
        return zelf
    }
    
    /// 타이틀 텍스트의 `weight` 속성을 조정합니다. 기본값은 `.regular`입니다.
    public func titleWeight(_ weight: Typography.Weight) -> Self {
        var zelf = self
        zelf.titleTypography.weight = weight
        return zelf
    }
    
    /// 상하 여백의 크기를 조정합니다. 기본값은 `.medium` 입니다.
    public func verticalPadding(_ verticalPadding: VerticalPadding) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
    /// 상단 정렬을 조정합니다. 기본값은 `.center`입니다.
    public func verticalAlign(_ verticalAlignment: VerticalAlignment) -> Self {
        var zelf = self
        zelf.verticalAlignment = verticalAlignment
        return zelf
    }
    
    /// 좌우 여백 여부를 조정합니다. 기본값은 `false`입니다.
    public func fillWidth(_ fillWidth: Bool = true) -> Self {
        var zelf = self
        zelf.fillWidth = fillWidth
        return zelf
    }
    
    /// 텍스트의 생략 여부를 조정합니다. 기본값은 `false`입니다. `false`인 경우 죄우 컨텐츠는 상단 정렬됩니다.
    public func textEllipsis(_ textEllipsis: Bool = true) -> Self {
        var zelf = self
        zelf.textEllipsis = textEllipsis
        return zelf
    }
    
    /// 캡션을 추가합니다.
    public func caption(_ caption: String? = nil) -> Self {
        var zelf = self
        zelf.caption = caption
        return zelf
    }
    
    /// 비활성화 여부를 조정합니다. 기본값은 `false`입니다.
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }

    /// 활성화 상태로 만듭니다. 타이틀 텍스트의 색상을 `primaryNormal`로 변경하고 `trailingContent(_ contents: @escaping (Bool) -> some View)`의 입력 클로져의 파라메터로 활성화 여부를 받을 수 있습니다.
    public func active(_ active: Bool = true) -> Self {
        var zelf = self
        zelf.active = active
        return zelf
    }
    
    /// 아래에 구분선을 추가합니다. 기본값은 `false`입니다.
    public func divider(_ divider: Bool = true) -> Self {
        var zelf = self
        zelf.divider = divider
        return zelf
    }
    
    /// 우측에 chevron 을 추가합니다.
    public func chevron(_ chevron: Bool = true) -> Self {
        var zelf = self
        zelf.chevron = chevron
        return zelf
    }
    
    /// 좌측 컨텐츠를 지정합니다.
    public func leadingContent(_ contents: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.leadingContent = contents
        return zelf
    }
    
    /// 우측 컨텐츠를 지정합니다.
    public func trailingContent(_ contents: ((Bool) -> any View)? = nil) -> Self {
        var zelf = self
        zelf.trailingContent = contents
        return zelf
    }
    
    /// 인터랙션 효과의 좌우 패딩을 조정합니다. 기본값은 12입니다.
    public func interactionPadding(_ padding: CGFloat) -> Self {
        var zelf = self
        zelf.interactionPadding = padding
        return zelf
    }
    
    /// 타이틀의 특정 텍스트를 bold로 강조합니다. 첫 번째 매칭되는 부분만 강조됩니다.
    public func highlight(_ text: String) -> Self {
        var zelf = self
        zelf.highlightText = text
        return zelf
    }
}

// MARK: - Private
extension Cell {
    private var normalTitleColor: Color.Semantic {
        if disable {
            .labelDisable
        } else {
            active ? .primaryNormal : .labelNormal
        }
    }
    
    private var titleView: some View {
        if let highlightText {
            let attributedString: AttributedString = {
                var string = AttributedString(stringLiteral: title)
                string.font = .montage(variant: titleTypography.variant, weight: active ? .medium : titleTypography.weight)
                string.foregroundColor = .semantic(normalTitleColor)
                guard let range = string.range(of: highlightText, options: .caseInsensitive) else {
                    return string
                }
                string[range].font = .montage(variant: titleTypography.variant, weight: .bold)
                string[range].foregroundColor = .semantic(normalTitleColor)
                return string
            }()
            
            return Text(attributedString)
                .paragraph(variant: titleTypography.variant)
        } else {
            return Text(title)
                .montage(
                    variant: titleTypography.variant,
                    weight: active ? .medium : titleTypography.weight,
                    semantic: normalTitleColor
                )
                .paragraph(variant: titleTypography.variant)
        }
    }
}
