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
            if let contentColor {
                uiView.contentUIColor = contentColor.uiColor
            } else {
                uiView.contentUIColor = nil
            }
            if let backgroundColor {
                uiView.backgroundUIColor = backgroundColor.uiColor
            } else {
                uiView.backgroundUIColor = nil
            }
            if let borderColor {
                uiView.borderUIColor = borderColor.uiColor
            } else {
                uiView.borderUIColor = nil
            }
            uiView.handler = handler
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
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .secondary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    .fixedSize()
                }
                
                HStack {
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .large,
                        uniqueIcon: .android,
                        iconOnly: true
                    )
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .medium,
                        uniqueIcon: .android,
                        iconOnly: true
                    )
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .small,
                        uniqueIcon: .android,
                        iconOnly: true,
                        disable: true
                    )
                    .fixedSize()
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
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .secondary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요"
                    )
                    .fixedSize()
                }
                HStack {
                    Button.OutlinedButtonController(
                        variant: .primary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요",
                        disable: true
                    )
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .secondary,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요",
                        disable: true
                    )
                    .fixedSize()
                    
                    Button.OutlinedButtonController(
                        variant: .assistive,
                        size: .small,
                        rightIcon: .chevronRightThick,
                        text: "안녕하세요",
                        disable: true
                    )
                    .fixedSize()
                }
            }
            
            Text("Size").montage()
            
            HStack {
                Button.OutlinedButtonController(
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.OutlinedButtonController(
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.OutlinedButtonController(
                    size: .large,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            Text("Icon").montage()
            
            HStack {
                Button.OutlinedButtonController(
                    size: .small,
                    leftIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.OutlinedButtonController(
                    size: .small,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.OutlinedButtonController(
                    size: .small,
                    leftIcon: .apps,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            Text("Custom").montage()
            
            HStack {
                Button.OutlinedButtonController(
                    size: .small,
                    text: "border&content",
                    contentColor: .alias(.accentLime),
                    borderColor: .alias(.accentLime)
                ).fixedSize()
                
                Button.OutlinedButtonController(
                    size: .small,
                    text: "background",
                    backgroundColor: .alias(.accentPink)
                ).fixedSize()
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
