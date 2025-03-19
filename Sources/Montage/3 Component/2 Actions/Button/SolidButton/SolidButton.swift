//
//  SolidButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import Pretendard
import SwiftUI

extension Button {
    public struct SolidButton: UIViewRepresentable {
        public var variant: SolidUIButton.Variant = .primary
        public var size: SolidUIButton.Size = .medium
        public var leadingIcon: Icon?
        public var trailingIcon: Icon?
        public var text: String
        public var uniqueIcon: Icon?
        public var iconOnly = false
        public var state: Decorate.Interaction.State = .normal
        public var disable = false
        public var contentColor: SwiftUI.Color? = nil
        public var backgroundColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = SolidUIButton
        
        public init(
            variant: SolidUIButton.Variant = .primary,
            size: SolidUIButton.Size = .medium,
            leadingIcon: Icon? = nil,
            trailingIcon: Icon? = nil,
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
            self.leadingIcon = leadingIcon
            self.trailingIcon = trailingIcon
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
            uiView.leadingIcon = leadingIcon
            uiView.trailingIcon = trailingIcon
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

struct SolidButtonPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("State").montage()
            
            HStack {
                Button.SolidButton(
                    size: .medium,
                    trailingIcon: .chevronRightThick,
                    text: "안녕하세요"
                ) {
                    debugPrint(">>> hello world!")
                }
                
                Button.SolidButton(
                    size: .medium,
                    trailingIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                )
                
                Button.SolidButton(
                    uniqueIcon: .android,
                    iconOnly: true
                )
                
                Button.SolidButton(
                    uniqueIcon: .android,
                    iconOnly: true,
                    disable: true
                )
            }
            
            Text("Size").montage()
            
            VStack(alignment: .leading) {
                HStack {
                    Button.SolidButton(
                        size: .small,
                        text: "안녕하세요"
                    )
                    
                    Button.SolidButton(
                        size: .medium,
                        text: "안녕하세요"
                    )
                }
                
                HStack {
                    Button.SolidButton(
                        size: .large,
                        text: "안녕하세요"
                    )
                    
                    Button.SolidButton(
                        size: .large,
                        text: "안녕하세요",
                        uniqueIcon: .apps,
                        iconOnly: true
                    )
                }
                
                HStack {
                    Button.SolidButton(
                        size: .large,
                        uniqueIcon: .chat,
                        iconOnly: true
                    )
                    
                    Button.SolidButton(
                        size: .medium,
                        uniqueIcon: .chat,
                        iconOnly: true
                    )
                    
                    Button.SolidButton(
                        size: .small,
                        uniqueIcon: .chat,
                        iconOnly: true
                    )
                    
                    Button.SolidButton(
                        size: .large,
                        uniqueIcon: .eye,
                        iconOnly: true,
                        disable: true
                    )
                    
                    Button.SolidButton(
                        size: .medium,
                        uniqueIcon: .eye,
                        iconOnly: true,
                        disable: true
                    )
                    
                    Button.SolidButton(
                        size: .small,
                        uniqueIcon: .eye,
                        iconOnly: true,
                        disable: true
                    )
                }
            }
            
            Text("Icon").montage()
            
            HStack {
                Button.SolidButton(
                    size: .small,
                    leadingIcon: .apps,
                    text: "안녕하세요"
                )
                
                Button.SolidButton(
                    size: .small,
                    trailingIcon: .apps,
                    text: "안녕하세요"
                )
                
                Button.SolidButton(
                    size: .small,
                    leadingIcon: .apps,
                    trailingIcon: .apps,
                    text: "안녕하세요"
                )
            }
            
            Text("Custom").montage()
            
            HStack {
                Button.SolidButton(
                    size: .small,
                    text: "content",
                    contentColor: .semantic(.accentBackgroundRedOrange)
                )
                
                Button.SolidButton(
                    size: .small,
                    text: "background",
                    backgroundColor: .semantic(.accentBackgroundPurple)
                )
            }
        }
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        SolidButtonPreview()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
