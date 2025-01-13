//
//  FilterChipController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import Pretendard
import SwiftUI

extension Chip {
    public struct FilterChipController: UIViewRepresentable {
        public var variant: Filter.Variant = .solid
        public var size: Filter.Size = .normal
        public var text = ""
        public var state: Filter.State = .normal
        public var interactionState: Decorate.Interaction.State = .normal
        public var active = false
        public var activeLabel: String? = nil
        public var disable = false
        public var iconColor: SwiftUI.Color? = nil
        public var fontColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Filter
        
        public init(
            variant: Filter.Variant = .solid,
            size: Filter.Size = .normal,
            text: String,
            state: Filter.State = .normal,
            interactionState: Decorate.Interaction.State = .normal,
            active: Bool = false,
            activeLabel: String? = nil,
            disable: Bool = false,
            iconColor: SwiftUI.Color? = nil,
            fontColor: SwiftUI.Color? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.text = text
            self.state = state
            self.interactionState = interactionState
            self.active = active
            self.activeLabel = activeLabel
            self.disable = disable
            self.iconColor = iconColor
            self.fontColor = fontColor
            self.handler = handler
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.text = text
            uiView.state = state
            uiView.interactionState = interactionState
            uiView.active = active
            uiView.activeLabel = activeLabel
            uiView.disable = disable
            if let iconColor {
                uiView.iconUIColor = iconColor.uiColor
            } else {
                uiView.iconUIColor = nil
            }
            if let fontColor {
                uiView.fontUIColor = fontColor.uiColor
            } else {
                uiView.fontUIColor = nil
            }
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
