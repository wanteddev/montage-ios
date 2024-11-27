//
//  ActionChipController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import SwiftUI
import Pretendard

extension Chip {
    public struct ActionChipController: UIViewRepresentable {
        public var variant: Action.Variant = .solid
        public var size: Action.Size = .normal
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String = ""
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var active: Bool = false
        public var iconColor: SwiftUI.Color? = nil
        public var backgroundColor: SwiftUI.Color? = nil
        public var fontColor: SwiftUI.Color? = nil
        public var activeColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Action
        
        public init(
            variant: Action.Variant = .solid,
            size: Action.Size = .normal,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            active: Bool = false,
            iconColor: SwiftUI.Color? = nil,
            backgroundColor: SwiftUI.Color? = nil,
            fontColor: SwiftUI.Color? = nil,
            activeColor: SwiftUI.Color? = nil,
            handler: ( () -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
            self.state = state
            self.disable = disable
            self.active = active
            self.iconColor = iconColor
            self.backgroundColor = backgroundColor
            self.fontColor = fontColor
            self.activeColor = activeColor
            self.handler = handler
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
            uiView.state = state
            uiView.disable = disable
            uiView.active = active
            if let iconColor {
                uiView.iconUIColor = iconColor.uiColor
            } else {
                uiView.iconUIColor = nil
            }
            if let backgroundColor {
                uiView.backgroundUIColor = backgroundColor.uiColor
            } else {
                uiView.backgroundUIColor = nil
            }
            if let fontColor {
                uiView.fontUIColor = fontColor.uiColor
            } else {
                uiView.fontUIColor = nil
            }
            if let activeColor {
                uiView.activeUIColor = activeColor.uiColor
            } else {
                uiView.activeUIColor = nil
            }
            uiView.handler = handler
        }
        
        public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
            CGSize(
                width: fillWidth ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillHeight ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        private var fillWidth: Bool = false
        private var fillHeight: Bool = false
        public func fill(width fillWidth: Bool, height fillHeight: Bool) -> Self {
            var zelf = self
            zelf.fillWidth = fillWidth
            zelf.fillHeight = fillHeight
            return zelf
        }
    }
}

var actionChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("Variant").montage(variant: .headline2)
            HStack {
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Disable").montage(variant: .headline2)
            HStack {
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    disable: false
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    disable: true
                )
            }
            HStack {
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    disable: false
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    disable: true
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Active").montage(variant: .headline2)
            HStack {
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    active: true
                )
            }
            HStack {
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    active: true
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Size").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .solid,
                    size: .xsmall,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    size: .small,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    size: .normal,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    size: .large,
                    text: "안녕하세요"
                )
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .xsmall,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .small,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .normal,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .large,
                    text: "안녕하세요"
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Icon").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .solid,
                    size: .xsmall,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    size: .small,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .normal,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .large,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
            }
        }
        
        VStack(alignment: .leading) {
            Text("Customize").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .solid,
                    size: .xsmall,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    iconColor: .alias(.accentViolet)
                )
                
                Chip.ActionChipController(
                    variant: .solid,
                    size: .small,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    backgroundColor: .alias(.accentRedOrange)
                )
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .normal,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    fontColor: .alias(.accentLightBlue)
                )
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .large,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    iconColor: .alias(.accentRedOrange),
                    backgroundColor: .alias(.accentLime),
                    fontColor: .alias(.accentLightBlue)
                )
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요"
                )
                Chip.ActionChipController(
                    variant: .solid,
                    text: "안녕하세요",
                    active: true,
                    activeColor: .alias(.accentCyan)
                )
            }
        }
    }
}

struct ActionChipController_Previews: PreviewProvider {
    static var previews: some View {
        actionChipControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
