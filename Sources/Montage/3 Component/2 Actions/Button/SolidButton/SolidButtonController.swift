//
//  SolidButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import Pretendard
import SwiftUI

extension Button {
    public struct SolidButtonController: UIViewRepresentable {
        public var variant: SolidButton.Variant = .primary
        public var size: SolidButton.Size = .medium
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String
        public var uniqueIcon: Icon?
        public var iconOnly = false
        public var state: Decorate.Interaction.State = .normal
        public var disable = false
        public var contentColor: SwiftUI.Color? = nil
        public var backgroundColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = SolidButton
        
        public init(
            variant: SolidButton.Variant = .primary,
            size: SolidButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String = "",
            uniqueIcon: Icon? = nil,
            iconOnly: Bool = false,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            contentColor: SwiftUI.Color? = nil,
            backgroundColor: SwiftUI.Color? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
            self.uniqueIcon = uniqueIcon
            self.iconOnly = iconOnly
            self.state = state
            self.disable = disable
            self.contentColor = contentColor
            self.backgroundColor = backgroundColor
            self.handler = handler
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
            uiView.uniqueIcon = uniqueIcon
            uiView.iconOnly = iconOnly
            uiView.state = state
            uiView.disable = disable
            uiView.contentUIColor = contentColor?.uiColor
            uiView.backgroundUIColor = backgroundColor?.uiColor
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

struct SolidButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("State").montage()
            
            HStack {
                Button.SolidButtonController(
                    size: .medium,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요"
                ) {
                    debugPrint(">>> hello world!")
                }
                
                Button.SolidButtonController(
                    size: .medium,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                )
                
                Button.SolidButtonController(
                    uniqueIcon: .android,
                    iconOnly: true
                )
                
                Button.SolidButtonController(
                    uniqueIcon: .android,
                    iconOnly: true,
                    disable: true
                )
            }
            
            Text("Size").montage()
            
            VStack(alignment: .leading) {
                HStack {
                    Button.SolidButtonController(
                        size: .small,
                        text: "안녕하세요"
                    )
                    
                    Button.SolidButtonController(
                        size: .medium,
                        text: "안녕하세요"
                    )
                }
                
                HStack {
                    Button.SolidButtonController(
                        size: .large,
                        text: "안녕하세요"
                    )
                    
                    Button.SolidButtonController(
                        size: .large,
                        text: "안녕하세요",
                        uniqueIcon: .apps,
                        iconOnly: true
                    )
                }
                
                HStack {
                    Button.SolidButtonController(
                        size: .large,
                        uniqueIcon: .chat,
                        iconOnly: true
                    )
                    
                    Button.SolidButtonController(
                        size: .medium,
                        uniqueIcon: .chat,
                        iconOnly: true
                    )
                    
                    Button.SolidButtonController(
                        size: .small,
                        uniqueIcon: .chat,
                        iconOnly: true
                    )
                    
                    Button.SolidButtonController(
                        size: .large,
                        uniqueIcon: .eye,
                        iconOnly: true,
                        disable: true
                    )
                    
                    Button.SolidButtonController(
                        size: .medium,
                        uniqueIcon: .eye,
                        iconOnly: true,
                        disable: true
                    )
                    
                    Button.SolidButtonController(
                        size: .small,
                        uniqueIcon: .eye,
                        iconOnly: true,
                        disable: true
                    )
                }
            }
            
            Text("Icon").montage()
            
            HStack {
                Button.SolidButtonController(
                    size: .small,
                    leftIcon: .apps,
                    text: "안녕하세요"
                )
                
                Button.SolidButtonController(
                    size: .small,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
                
                Button.SolidButtonController(
                    size: .small,
                    leftIcon: .apps,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
            }
            
            Text("Custom").montage()
            
            HStack {
                Button.SolidButtonController(
                    size: .small,
                    text: "content",
                    contentColor: .alias(.accentRedOrange)
                )
                
                Button.SolidButtonController(
                    size: .small,
                    text: "background",
                    backgroundColor: .alias(.accentPurple)
                )
            }
        }
    }
}

struct RoundButtonController_Previews: PreviewProvider {
    static var previews: some View {
        SolidButtonControllerPreview()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
