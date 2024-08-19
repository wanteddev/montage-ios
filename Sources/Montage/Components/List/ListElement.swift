//
//  ListElement.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

extension Montage.List {
    /// 셀 형태가 아닌 단일 형태를 가진 리스트입니다.
    public struct Element: View {
        /// List/Element의 외형을 나타내는 열거형입니다.
        public enum Variant {
            case normal
            case action
        }
        
        /// List/Element의 활성화 여부입니다.
        @State private var active: Bool = false
        
        /// List/Element의 외형입니다.
        private let variant: Variant
        
        /// List/Element의 제목입니다.
        private let title: String
        
        /// List/Element에 사용될 캡션입니다.
        /// > 내용이 없으면 노출되지 않습니다.
        /// >
        /// > normal variant에서만 적용됩니다.
        private let caption: String?
        
        /// List/Element의 텍스트 Bold 여부입니다.
        /// > 기본값은 false 입니다.
        /// >
        /// > normal variant에서만 적용됩니다.
        /// >
        /// > caption에는 적용되지 않습니다.
        private let bold: Bool
        
        /// List/Element의 사용가능 여부입니다.
        private let disable: Bool
        
        /// List/Element의 좌측 영역에 표시될 요소입니다.
        private let leftContent: LeftContent?

        /// List/Element의 우측 영역에 표시될 요소입니다.
        private let rightContent: RightContent?
        
        /// List/Element의 handler입니다.
        private let handler: (() -> Void)?
        
        public init(
            variant: Variant = .normal,
            title: String,
            caption: String? = nil,
            bold: Bool = false,
            disable: Bool = false,
            leftContent: LeftContent? = nil,
            rightContent: RightContent? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.title = title
            self.caption = caption
            self.bold = bold
            self.disable = disable
            self.leftContent = leftContent
            self.rightContent = rightContent
            self.handler = handler
        }
        
        public init(model: ElementModel) {
            self.init(
                variant: model.variant,
                title: model.title,
                caption: model.caption,
                bold: model.bold,
                disable: model.disable,
                leftContent: model.leftContent,
                rightContent: model.rightContent,
                handler: model.handler
            )
        }

        private var normalTitleColor: Color.Alias {
            if disable {
                .labelDisable
            } else {
                active ? .primaryNormal : .labelNormal
            }
        }
        
        public var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        if let leftContent {
                            leftComponent(leftContent)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            switch variant {
                            case .normal:
                                Text(title)
                                    .montage(
                                        variant: .body1,
                                        weight: bold ? .bold : .regular,
                                        color: normalTitleColor
                                    )
                                    .paragraph(variant: .body1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if let caption {
                                    Text(caption)
                                        .montage(
                                            variant: .label2,
                                            color: disable ? .labelDisable : .labelAlternative
                                        )
                                        .paragraph(variant: .label2)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                }
                                
                            case .action:
                                Text(title)
                                    .montage(
                                        variant: .body1,
                                        color: disable ? .labelDisable : .primaryNormal
                                    )
                                    .paragraph(variant: .body1)
                                    .frame(maxWidth: .infinity, alignment: .center)
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
                            color: .labelAlternative
                        )
                        .paragraph(variant: .body1)
                    Image.montage(.chevronRightTightSmall)
                        .frame(width: 8, height: 16)
                        .foregroundStyle(SwiftUI.Color.alias(.labelAssistive))
                }
            case let .iconButton(variant, icon):
                Button.IconButtonController(
                    variant: variant,
                    icon: icon,
                    iconColorResolver: Montage.Color.Alias.labelAlternative
                )
                .fixedSize()
            case let .textButton(variant, size, text):
                Button.TextButtonController(
                    variant: variant,
                    size: size,
                    text: text
                )
                .fixedSize()
            case .check:
                Image.montage(.check)
                    .resizable()
                    .foregroundStyle(SwiftUI.Color.alias(.primaryNormal))
                    .frame(width: 24, height: 24)
            case .switch(let on):
                Control.SwitchController(isOn: on)
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
}

extension Montage.List.Element {
    public enum LeftContent {
        case icon(Icon)
        case radio(Bool = false)
        case check(Bool = false)
    }
    
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
}

extension Montage.List.Element {
    public struct Configuration {
        public let variant: Variant
        public let caption: String?
        public let bold: Bool
        public let disable: Bool
        
        public init(
            variant: Variant = .normal,
            caption: String? = nil,
            bold: Bool = false,
            disable: Bool = false
        ) {
            self.variant = variant
            self.caption = caption
            self.bold = bold
            self.disable = disable
        }
    }
    
    public struct ElementModel {
        public let variant: Variant
        public let title: String
        public let caption: String?
        public let bold: Bool
        public let disable: Bool
        public let leftContent: LeftContent?
        public let rightContent: RightContent?
        public let handler: (() -> Void)?
        
        public init(
            variant: Variant = .normal,
            title: String,
            caption: String? = nil,
            bold: Bool = false,
            disable: Bool = false,
            leftContent: LeftContent? = nil,
            rightContent: RightContent? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.title = title
            self.caption = caption
            self.bold = bold
            self.disable = disable
            self.leftContent = leftContent
            self.rightContent = rightContent
            self.handler = handler
        }
        
        public init(
            configuration: Configuration = Configuration(),
            title: String,
            leftContent: LeftContent? = nil,
            rightContent: RightContent? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.init(
                variant: configuration.variant,
                title: title,
                caption: configuration.caption,
                bold: configuration.bold,
                disable: configuration.disable,
                leftContent: leftContent,
                rightContent: rightContent,
                handler: handler
            )
        }
    }
}

struct ListElement_Previews: PreviewProvider {
    static var previews: some View {
        List.Element(
            title: "텍스트",
            caption: "캡션",
            leftContent: .radio(false),
            rightContent: .badge(.filled, size: .small, color: .neutral, text: "텍스트")
        ) {
            print("helloworld")
        }
    }
}
