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
        public var variant: Action.Variant = .filled
        public var size: Action.Size = .normal
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String = ""
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var active: Bool = false
        public var iconColorResolver: ColorResolvable? = nil
        public var backgroundColorResolver: ColorResolvable? = nil
        public var fontColorResolver: ColorResolvable? = nil
        public var activeColorResolver: ColorResolvable? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Action
        
        public init(
            variant: Action.Variant = .filled,
            size: Action.Size = .normal,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            active: Bool = false,
            iconColorResolver: ColorResolvable? = nil,
            backgroundColorResolver: ColorResolvable? = nil,
            fontColorResolver: ColorResolvable? = nil,
            activeColorResolver: ColorResolvable? = nil,
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
            self.iconColorResolver = iconColorResolver
            self.backgroundColorResolver = backgroundColorResolver
            self.fontColorResolver = fontColorResolver
            self.activeColorResolver = activeColorResolver
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
            uiView.iconColorResolver = iconColorResolver
            uiView.backgroundColorResolver = backgroundColorResolver
            uiView.fontColorResolver = fontColorResolver
            uiView.activeColorResolver = activeColorResolver
            uiView.handler = handler
        }
    }
}

var actionChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("Variant").montage(variant: .headline2)
            HStack {
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Disable").montage(variant: .headline2)
            HStack {
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
            HStack {
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Active").montage(variant: .headline2)
            HStack {
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
            }
            HStack {
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    text: "안녕하세요",
                    active: true
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Size").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .filled,
                    size: .xsmall,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    size: .normal,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    size: .large,
                    text: "안녕하세요"
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .xsmall,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .normal,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .large,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Icon").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .filled,
                    size: .xsmall,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    size: .small,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .normal,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .large,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
            }
        }
        
        VStack(alignment: .leading) {
            Text("Customize").montage(variant: .headline2)
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .filled,
                    size: .xsmall,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    iconColorResolver: Color.Alias.accentViolet
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .filled,
                    size: .small,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    backgroundColorResolver: Color.Alias.accentRedOrange
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .normal,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    fontColorResolver: Color.Alias.accentLightBlue
                ).fixedSize()
                
                Chip.ActionChipController(
                    variant: .outlined,
                    size: .large,
                    leftIcon: .bell,
                    rightIcon: .apps,
                    text: "안녕하세요",
                    iconColorResolver: Color.Alias.accentRedOrange,
                    backgroundColorResolver: Color.Alias.accentLime,
                    fontColorResolver: Color.Alias.accentLightBlue
                ).fixedSize()
            }
            HStack(alignment: .center) {
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요"
                ).fixedSize()
                Chip.ActionChipController(
                    variant: .filled,
                    text: "안녕하세요",
                    active: true,
                    activeColorResolver: Color.Alias.accentCyan
                ).fixedSize()
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
