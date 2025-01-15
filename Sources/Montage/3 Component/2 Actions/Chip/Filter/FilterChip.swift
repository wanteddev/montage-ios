//
//  Filter.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import Pretendard
import SwiftUI

extension Chip {
    public struct Filter: UIViewRepresentable {
        /// 칩의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case solid, outlined
        }
        
        /// 칩의 확장 상태를 나타내는 열거형입니다.
        public enum State {
            case normal
            case expand
        }
        
        /// 칩의 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case normal, xsmall, small, large
        }
        
        public var variant: Variant = .solid
        public var size: Size = .normal
        public var text = ""
        public var state: State = .normal
        public var interactionState: Decorate.Interaction.State = .normal
        public var active = false
        public var activeLabel: String? = nil
        public var disable = false
        public var iconColor: SwiftUI.Color? = nil
        public var fontColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = FilterUIView
        
        public init(
            variant: Variant = .solid,
            size: Size = .normal,
            text: String,
            state: State = .normal,
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

extension Chip.Filter.Variant {
    var backgroundColor: UIColor {
        switch self {
        case .solid:
            .component(.fillAlternative)
        case .outlined:
            .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .solid:
            .zero
        case .outlined:
            1
        }
    }
    
    var disableBackgroundColor: UIColor {
        switch self {
        case .solid:
            .alias(.interactionDisable)
        case .outlined:
            .clear
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self {
        case .solid:
            .alias(.inverseBackground)
        case .outlined:
            .alias(.primaryNormal).withAlphaComponent(0.05)
        }
    }
    
    var activeTextUIColor: UIColor {
        switch self {
        case .solid:
            .alias(.inverseLabel)
        case .outlined:
            .alias(.primaryNormal)
        }
    }
    
    var activeArrowColor: UIColor {
        switch self {
        case .solid:
            .alias(.inverseLabel)
        case .outlined:
            .alias(.labelNormal)
        }
    }
}

extension Chip.Filter.State {
    var icon: Icon {
        switch self {
        case .normal:
            .caretDown
        case .expand:
            .caretUp
        }
    }
}

extension Chip.Filter.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            .init(width: 16, height: 16)
        case .normal:
            .init(width: 16, height: 16)
        case .small:
            .init(width: 16, height: 16)
        case .xsmall:
            .init(width: 12, height: 12)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            .body2
        case .normal:
            .body2
        case .small:
            .label1
        case .xsmall:
            .caption1
        }
    }
    
    var contentsEdgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            .init(top: 9, left: 12, bottom: 9, right: 10)
        case .normal:
            .init(top: 7, left: 11, bottom: 7, right: 9)
        case .small:
            .init(top: 6, left: 8, bottom: 6, right: 6)
        case .xsmall:
            .init(top: 4, left: 7, bottom: 4, right: 5)
        }
    }
    
    var contentsGap: CGFloat {
        switch self {
        case .large:
            2.0
        case .normal:
            2.0
        case .small:
            1.0
        case .xsmall:
            1.0
        }
    }
    
    var contentsPadding: CGFloat {
        switch self {
        case .normal: 2.0
        case .small: 2.0
        case .large: 2.0
        case .xsmall: 1.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            10.0
        case .normal:
            10.0
        case .small:
            8.0
        case .xsmall:
            6.0
        }
    }
}
