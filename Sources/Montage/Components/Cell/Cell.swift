//
//  Cell.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

public struct Cell: View {
    /// Cell의 상하 여백을 나타내는 열거형입니다.
    public enum Padding {
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
    
    /// Cell의 왼쪽에 표시될 컨텐츠를 나타내는 열거형입니다.
    public enum LeftContent {
        case icon(Icon)
        case radio(Bool = false)
        case check(Bool = false)
    }
    
    /// Cell의 오른쪽에 표시될 컨텐츠를 나타내는 열거형입니다.
    public enum RightContent {
        case chevron(
            text: String
        )
        case iconButton(
            Button.IconButton.Variant,
            icon: Icon
        )
        case textButton(
            Button.TextButton.Variant,
            size: Button.TextButton.Size,
            text: String
        )
        case check
        case `switch`(
            Bool = false
        )
        case badge(
            Badge.Content.Variant,
            size: Badge.Content.Size,
            color: Badge.Content.ColorStyle,
            text: String,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil
        )
    }
    
    @State private var isPressed: Bool = false
    @State private var contentSize: CGSize = .zero
    
    private let title: String
    private var padding: Padding = .pt12
    private var fillWidth: Bool = false
    private var caption: String? = nil
    private var bold: Bool = false
    private var disable: Bool = false
    private var active: Bool = false
    private var divider: Bool = false
    private var leftContent: Cell.LeftContent? = nil
    private var rightContent: Cell.RightContent? = nil
    private let handler: (() -> Void)?
    
    public init(
        title: String,
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.handler = handler
    }
    
    public var body: some View {
        SwiftUI.Button {
            handler?()
        } label: {
            ZStack(alignment: .bottom) {
                ZStack {
                    HStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .top, spacing: 8) {
                            if let leftContent {
                                leftComponent(leftContent)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(title)
                                    .montage(
                                        variant: .body1,
                                        weight: bold ? .bold : .regular,
                                        alias: normalTitleColor
                                    )
                                    .paragraph(variant: .body1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if let caption {
                                    Text(caption)
                                        .montage(
                                            variant: .label2,
                                            alias: disable ? .labelDisable : .labelAlternative
                                        )
                                        .paragraph(variant: .label2)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                }
                            }
                        }
                        
                        if let rightContent {
                            rightComponent(rightContent)
                        }
                    }
                }
                .allowsHitTesting(disable == false)
                .onTapGesture {
                    handler?()
                }
                .readSize { contentSize = $0 }
                .padding(.horizontal, fillWidth ? 12 : 20)
                .padding(.vertical, padding.length)
                
                if divider {
                    Rectangle()
                        .frame(width: contentSize.width, height: 1)
                        .foregroundStyle(SwiftUI.Color.alias(.lineAlternative))
                        .background()
                }
            }
            .overlay(
                Decorate.InteractionController(
                    state: isPressed ? .pressed : .normal,
                    variant: .light,
                    color: .labelNormal
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            )
        }
        .buttonStyle(ButtonStyleForCellInteraction())
        .allowsHitTesting(disable == false)
    }
}

// MARK: - modifiers
extension Cell {
    /// 상하 여백의 크기를 조정합니다.
    public func padding(_ padding: Padding) -> Self {
        var zelf = self
        zelf.padding = padding
        return zelf
    }
    
    /// 좌우 여백 여부를 조정합니다.
    public func fillWidth(_ fillWidth: Bool = true) -> Self {
        var zelf = self
        zelf.fillWidth = fillWidth
        return zelf
    }
    
    /// 캡션을 추가합니다.
    public func caption(_ caption: String) -> Self {
        var zelf = self
        zelf.caption = caption
        return zelf
    }
    
    /// 타이틀의 bold 스타일 여부를 조정합니다.
    public func bold(_ bold: Bool = true) -> Self {
        var zelf = self
        zelf.bold = bold
        return zelf
    }
    
    /// Cell의 비활성화 여부를 조정합니다.
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }

    /// Cell을 active 상태로 만듭니다. title을 primaryNormal로 변경하고 rightContent를 .check로 설정한 경우 check 상태를 활성화합니다.
    public func active(_ active: Bool = true) -> Self {
        var zelf = self
        zelf.active = active
        return zelf
    }
    
    /// Cell 아래에 Cell 구분선을 추가합니다.
    public func divider(_ divider: Bool = true) -> Self {
        var zelf = self
        zelf.divider = divider
        return zelf
    }
    
    /// Cell의 왼쪽영역에 표시될 컨텐츠를 추가합니다.
    public func leftContent(_ leftContent: LeftContent) -> Self {
        var zelf = self
        zelf.leftContent = leftContent
        return zelf
    }
    
    /// Cell의 오른쪽영역에 표시될 컨텐츠를 추가합니다.
    public func rightContent(_ rightContent: RightContent) -> Self {
        var zelf = self
        zelf.rightContent = rightContent
        return zelf
    }
}

extension Cell {
    private struct ButtonStyleForCellInteraction: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .overlay(
                    Decorate.InteractionController(
                        state: configuration.isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .labelNormal
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                )
        }
    }
    
    private var normalTitleColor: Color.Alias {
        if disable {
            return .labelDisable
        } else {
            print("\(active)")
            return active ? .primaryNormal : .labelNormal
        }
    }
    
    @ViewBuilder
    private func leftComponent(_ content: LeftContent) -> some View {
        switch content {
        case .icon(let icon):
            Image.montage(icon)
                .resizable()
                .foregroundStyle(SwiftUI.Color.alias(.labelAlternative))
                .frame(width: 24, height: 24)
        case .check(let check):
            Control.CheckController(state: check ? .checked : .unchecked)
                .frame(width: 24, height: 24)
        case .radio(let on):
            Control.RadioController(state: on ? .checked : .unchecked)
                .frame(width: 24, height: 24)
        }
    }
    
    @ViewBuilder
    private func rightComponent(_ content: RightContent) -> some View {
        switch content {
        case .chevron(let text):
            HStack(spacing: 8) {
                Text(text)
                    .montage(
                        variant: .body1,
                        alias: .labelAlternative
                    )
                    .paragraph(variant: .body1)
                Image.montage(.chevronRightTightSmall)
                    .frame(width: 8, height: 16)
                    .foregroundStyle(SwiftUI.Color.alias(.labelAssistive))
            }
        case let .iconButton(variant, icon):
            Button.IconButton(
                variant: variant,
                icon: icon,
                iconColor: .alias(.labelAlternative)
            )
            .fixedSize()
        case let .textButton(variant, size, text):
            Button.TextButton(
                variant: variant,
                size: size,
                text: text
            )
            .fixedSize()
        case .check:
            Image.montage(.check)
                .resizable()
                .foregroundStyle(active ? SwiftUI.Color.alias(.primaryNormal) : .alias(.labelNormal))
                .frame(width: 24, height: 24)
        case .switch(let on):
            Control.SwitchController(.constant(on))
                .fixedSize()
        case let .badge(variant, size, color, text, leftIcon, rightIcon):
            Badge.ContentBadgeController(
                variant: variant,
                size: size,
                color: color,
                leftIcon: leftIcon,
                rightIcon: rightIcon,
                text: text
            )
            .fixedSize()
        }
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(title: "텍스트") {
            print("helloworld")
        }
        .caption("캡션")
        .bold()
        .padding(.pt12)
        .fillWidth()
        .active()
        .disable(false)
        .divider(false)
        .leftContent(.icon(.star))
        .rightContent(.check)
//        .border(SwiftUI.Color.red, width: 1)
    }
}
