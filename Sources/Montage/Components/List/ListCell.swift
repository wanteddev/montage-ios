//
//  ListCell.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

extension List {
    /// 셀 형태를 가진 리스트입니다.
    public struct Cell: View {
        /// List/Cell의 상하 여백을 나타내는 열거형입니다.
        public enum Padding {
            case normal
            case small
            case medium
            
            public var length: CGFloat {
                switch self {
                case .normal: 12
                case .small: 8
                case .medium: 16
                }
            }
        }
        
        @State private var isPressed: Bool = false
        @State private var contentSize: CGSize = .zero
        
        /// List/Cell의 상하 여백입니다.
        private let padding: Padding
        
        /// List/Cell의 좌/우 inset 여부입니다.
        private let paddingInset: Bool

        /// List/Element의 외형입니다.
        private let variant: List.Element.Variant
        
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

        /// List/Cell의 divider 여부입니다.
        private let divider: Bool
        
        /// List/Element의 좌측 영역에 표시될 요소입니다.
        private let leftContent: List.Element.LeftContent?

        /// List/Element의 우측 영역에 표시될 요소입니다.
        private let rightContent: List.Element.RightContent?
        
        /// List/Cell의 handler입니다.
        private let handler: (() -> Void)?

        public init(
            padding: Padding = .normal,
            paddingInset: Bool = false,
            variant: List.Element.Variant = .normal,
            title: String,
            caption: String? = nil,
            bold: Bool = false,
            disable: Bool = false,
            divider: Bool = false,
            leftContent: List.Element.LeftContent? = nil,
            rightContent: List.Element.RightContent? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.padding = padding
            self.paddingInset = paddingInset
            self.variant = variant
            self.title = title
            self.caption = caption
            self.bold = bold
            self.disable = disable
            self.divider = divider
            self.leftContent = leftContent
            self.rightContent = rightContent
            self.handler = handler
        }
        
        public init(model: CellModel) {
            self.init(
                padding: model.padding,
                paddingInset: model.paddingInset,
                variant: model.variant,
                title: model.title,
                caption: model.caption,
                bold: model.bold,
                disable: model.disable,
                divider: model.divider,
                leftContent: model.leftContent,
                rightContent: model.rightContent,
                handler: model.handler
            )
        }
        
        private var contentSizeMeasurer: some View {
            GeometryReader { proxy in
                Text("")
                    .onAppear {
                        contentSize = proxy.size
                    }
            }
        }
        
        public var body: some View {
            SwiftUI.Button {
                handler?()
            } label: {
                ZStack(alignment: .bottom) {
                    ZStack {
                        List.Element(
                            variant: variant,
                            title: title,
                            caption: caption,
                            bold: bold,
                            disable: disable,
                            leftContent: leftContent,
                            rightContent: rightContent
                        )
                    }
                    .background(contentSizeMeasurer)
                    .padding(.horizontal, paddingInset ? 20 : 12)
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
            .buttonStyle(.interaction)
            .allowsHitTesting(disable == false)
        }
    }
}

extension List.Cell {
    public struct Configration {
        public let padding: Padding
        public let paddingInset: Bool
        public let divider: Bool
        
        public init(
            padding: Padding = .normal,
            paddingInset: Bool = false,
            divider: Bool = false
        ) {
            self.padding = padding
            self.paddingInset = paddingInset
            self.divider = divider
        }
    }
    
    public struct CellModel {
        public let padding: Padding
        public let paddingInset: Bool
        public let variant: List.Element.Variant
        public let title: String
        public let caption: String?
        public let bold: Bool
        public let disable: Bool
        public let divider: Bool
        public let leftContent: List.Element.LeftContent?
        public let rightContent: List.Element.RightContent?
        public let handler: (() -> Void)?
        
        public init(
            padding: Padding = .normal,
            paddingInset: Bool = false,
            variant: List.Element.Variant = .normal,
            title: String,
            caption: String? = nil,
            bold: Bool = false,
            disable: Bool = false,
            divider: Bool = false,
            leftContent: List.Element.LeftContent? = nil,
            rightContent: List.Element.RightContent? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.padding = padding
            self.paddingInset = paddingInset
            self.variant = variant
            self.title = title
            self.caption = caption
            self.bold = bold
            self.disable = disable
            self.divider = divider
            self.leftContent = leftContent
            self.rightContent = rightContent
            self.handler = handler
        }

        public init(
            configuration: Configration,
            elementModel: List.Element.ElementModel
        ) {
            self.init(
                padding: configuration.padding,
                paddingInset: configuration.paddingInset,
                variant: elementModel.variant,
                title: elementModel.title,
                caption: elementModel.caption,
                bold: elementModel.bold,
                disable: elementModel.disable,
                divider: configuration.divider,
                leftContent: elementModel.leftContent,
                rightContent: elementModel.rightContent,
                handler: elementModel.handler
            )
        }
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        List.Cell(
            padding: .normal,
            paddingInset: false,
            variant: .normal,
            title: "텍스트",
            caption: "캡션",
            bold: false,
            disable: false,
            leftContent: .radio(false),
            rightContent: .badge(.filled, size: .small, color: .neutral, text: "텍스트")
        ) {
            print("helloworld")
        }
    }
}
