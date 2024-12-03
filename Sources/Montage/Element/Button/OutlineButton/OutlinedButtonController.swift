//
//  OutlineButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import Foundation

import SwiftUI
import Pretendard

extension Button {
    public struct OutlinedButtonController: UIViewRepresentable {
        public var variant: OutlinedButton.Variant = .primary
        public var size: OutlinedButton.Size = .medium
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String
        public var uniqueIcon: Icon?
        public var iconOnly: Bool = false
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var contentColor: SwiftUI.Color? = nil
        public var backgroundColor: SwiftUI.Color? = nil
        public var borderColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = OutlinedButton
        
        public init(
            variant: OutlinedButton.Variant = .primary,
            size: OutlinedButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
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
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
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
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
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
            uiView.borderUIColor = borderColor?.uiColor
            uiView.handler = handler
        }
        
        public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
            CGSize(
                width: fillHorizontal ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillVertical ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        private var fillHorizontal: Bool = false
        private var fillVertical: Bool = false
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
    }
}

struct OutlinedButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("Variant").montage()
            
            VStack(alignment: .leading) {
                HStack {
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .secondary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                }
                
                HStack {
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .large,
                        uniqueIcon: .android,
                        iconOnly: true
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .medium,
                        uniqueIcon: .android,
                        iconOnly: true
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .small,
                        uniqueIcon: .android,
                        iconOnly: true,
                        disable: true
                    )
                }
            }
            
            Text("State").montage()
            
            VStack(alignment: .leading, spacing: .spacing(.pt16)) {
                HStack {
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .secondary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                }
                HStack {
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요",
                        disable: true
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .secondary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요",
                        disable: true
                    )
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요",
                        disable: true
                    )
                }
            }
            
            Text("Size").montage()
            
            HStack {
                Button.OutlinedButtonController(
                    size: .small,
                    text: "안녕하세요"
                )
                
                Button.OutlinedButtonController(
                    size: .medium,
                    text: "안녕하세요"
                )
                
                Button.OutlinedButtonController(
                    size: .large,
                    text: "안녕하세요"
                )
            }
            
            Text("Icon").montage()
            
            HStack {
                Button.OutlinedButtonController(
                    size: .small,
                    leftIcon: .apps,
                    text: "안녕하세요"
                )
                
                Button.OutlinedButtonController(
                    size: .small,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
                
                Button.OutlinedButtonController(
                    size: .small,
                    leftIcon: .apps,
                    rightIcon: .apps,
                    text: "안녕하세요"
                )
            }
            
            Text("Custom").montage()
            
            HStack {
                Button.OutlinedButtonController(
                    size: .small,
                    text: "border&content",
                    contentColor: .alias(.accentLime),
                    borderColor: .alias(.accentLime)
                )
                
                Button.OutlinedButtonController(
                    size: .small,
                    text: "background",
                    backgroundColor: .alias(.accentPink)
                )
            }
        }
    }
}
    
struct OutlinedButtonController_Previews: PreviewProvider {
    static var previews: some View {
        OutlinedButtonControllerPreview()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
