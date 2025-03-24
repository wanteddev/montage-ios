//
//  OutlineButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import Foundation

import Pretendard
import SwiftUI

extension Button {
    public struct OutlinedButton: UIViewRepresentable {
        public var variant: OutlinedUIButton.Variant = .primary
        public var size: OutlinedUIButton.Size = .medium
        public var leadingIcon: Icon?
        public var trailingIcon: Icon?
        public var text: String
        public var uniqueIcon: Icon?
        public var iconOnly = false
        public var state: Decorate.Interaction.State = .normal
        public var disable = false
        public var contentColor: SwiftUI.Color? = nil
        public var backgroundColor: SwiftUI.Color? = nil
        public var borderColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = OutlinedUIButton
        
        public init(
            variant: OutlinedUIButton.Variant = .primary,
            size: OutlinedUIButton.Size = .medium,
            leadingIcon: Icon? = nil,
            trailingIcon: Icon? = nil,
            text: String = "",
            uniqueIcon: Icon? = nil,
            iconOnly: Bool = false,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            contentColor: SwiftUI.Color? = nil,
            backgroundColor: SwiftUI.Color? = nil,
            borderColor: SwiftUI.Color? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.leadingIcon = leadingIcon
            self.trailingIcon = trailingIcon
            self.text = text
            self.state = state
            self.uniqueIcon = uniqueIcon
            self.iconOnly = iconOnly
            self.disable = disable
            self.contentColor = contentColor
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.handler = handler
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.leadingIcon = leadingIcon
            uiView.trailingIcon = trailingIcon
            uiView.text = text
            uiView.uniqueIcon = uniqueIcon
            uiView.iconOnly = iconOnly
            uiView.state = state
            uiView.disable = disable
            uiView.contentUIColor = contentColor?.uiColor
            uiView.backgroundUIColor = backgroundColor?.uiColor
            uiView.borderUIColor = borderColor?.uiColor
            uiView.handler = handler
        }
        
        public func sizeThatFits(
            _ proposal: ProposedViewSize,
            uiView: UIViewType,
            context _: Context
        ) -> CGSize? {
            CGSize(
                width: fillHorizontal ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillVertical ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        private var fillHorizontal = false
        private var fillVertical = false
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
    }
}
