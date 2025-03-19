//
//  Cell.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

public struct Cell: View {
    // MARK: - Types
    /// 좌우 컨텐츠 크기를 나타내는 열거형입니다.
    public enum ContentHeight {
        case pt24
        case pt40
        case pt56
        
        public var maxHeight: CGFloat {
            switch self {
            case .pt24: 24
            case .pt40: 40
            case .pt56: 56
            }
        }
    }
    
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
                HStack(alignment: textEllipsis ? .center : .top, spacing: 8) {
                    leadingContent()
                        .frame(
                            height: extraContentMaxHeight.maxHeight
                        )
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Group {
                            Text(title)
                                .montage(
                                    variant: titleTypography.variant,
                                    weight: titleTypography.weight,
                                    alias: normalTitleColor
                                )
                                .paragraph(variant: titleTypography.variant)
                        }
                        .if(textEllipsis) {
                            $0.lineLimit(2)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let caption {
                            Text(caption)
                                .montage(
                                    variant: .label2,
                                    alias: disable ? .labelDisable : .labelAlternative
                                )
                                .paragraph(variant: .label2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    trailingContent()
                        .frame(
                            height: extraContentMaxHeight.maxHeight
                        )
                        .clipped()
                    
                    VStack {
                        Image.montage(.chevronRightTightSmall)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(SwiftUI.Color.alias(.labelAssistive))
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
                .foregroundStyle(SwiftUI.Color.alias(.lineAlternative))
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
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPressed = value.translation == .zero
                }
                .onEnded { value in
                    isPressed = false
                    if value.translation == .zero {
                        onTap?()
                    }
                }
        )
    }
    
    // MARK: - Modifiers
    
    private var titleTypography: (variant: Typography.Variant, weight: Typography.Weight) = (.body1, .regular)
    private var verticalPadding: VerticalPadding = .pt12
    private var fillWidth = false
    private var textEllipsis = false
    private var caption: String? = nil
    private var disable = false
    private var active = false
    private var divider = false
    private var chevron = false
    private var extraContentMaxHeight: ContentHeight = .pt24
    private var leadingContent: () -> AnyView = { AnyView(EmptyView()) }
    private var trailingContent: () -> AnyView = { AnyView(EmptyView()) }
    private var interactionPadding: CGFloat = 12
    
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
    
    /// 텍스트의 생략 여부를 조정합니다. 기본값은 `false`입니다. `false`인 경우 죄우 컨텐츠는 상단 정렬됩니다.
    public func textEllipsis(_ textEllipsis: Bool = true) -> Self {
        var zelf = self
        zelf.textEllipsis = textEllipsis
        return zelf
    }
    
    /// 캡션을 추가합니다.
    public func caption(_ caption: String) -> Self {
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
    
    /// 좌우 컨텐츠의 높이를 조정합니다. 기본값은 `.pt24`입니다. 컨텐츠의 높이가 더 큰 경우는 가운데 정렬 상태에서 위, 아래가 클립되어 표시됩니다. 좌우는 클립되지 않고 컨텐츠 너비만큼 표시됩니다.
    public func contentHeight(_ contentHeight: ContentHeight) -> Self {
        var zelf = self
        zelf.extraContentMaxHeight = contentHeight
        return zelf
    }
    
    /// 좌측 컨텐츠를 지정합니다.
    public func leadingContent(_ contents: @escaping () -> some View) -> Self {
        var zelf = self
        zelf.leadingContent = { AnyView(contents()) }
        return zelf
    }
    
    /// 우측 컨텐츠를 지정합니다.
    public func trailingContent(_ contents: @escaping (Bool) -> some View) -> Self {
        var zelf = self
        zelf.trailingContent = { AnyView(contents(active)) }
        return zelf
    }
    
    /// 인터랙션 효과의 좌우 패딩을 조정합니다. 기본값은 12입니다.
    public func interactionPadding(_ padding: CGFloat) -> Self {
        var zelf = self
        zelf.interactionPadding = padding
        return zelf
    }
}

// MARK: - Private
extension Cell {
    private var normalTitleColor: Color.Alias {
        if disable {
            .labelDisable
        } else {
            active ? .primaryNormal : .labelNormal
        }
    }
}
