//
//  SolidButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import SwiftUI
import Pretendard

extension Button {
    public struct SolidButtonController: UIViewRepresentable {
        public var size: SolidButton.Size = .medium
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String
        public var uniqueIcon: Icon?
        public var iconOnly: Bool = false
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var handler: (() -> Void)?
        
        public typealias UIViewType = SolidButton
        
        public init(
            size: SolidButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            uniqueIcon: Icon? = nil,
            iconOnly: Bool = false,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
            self.uniqueIcon = uniqueIcon
            self.iconOnly = iconOnly
            self.state = state
            self.disable = disable
            self.handler = handler
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.size = size
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
            uiView.uniqueIcon = uniqueIcon
            uiView.iconOnly = iconOnly
            uiView.state = state
            uiView.disable = disable
            uiView.handler = handler
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
                .fixedSize()
                
                Button.SolidButtonController(
                    size: .medium,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
            
            Text("Size").montage()
            
            HStack {
                Button.SolidButtonController(
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.SolidButtonController(
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.SolidButtonController(
                    size: .large,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.SolidButtonController(
                    size: .large,
                    text: "안녕하세요",
                    uniqueIcon: .apps,
                    iconOnly: true
                ).fixedSize()
            }
            
            Text("Icon").montage()
            
            HStack {
                Button.SolidButtonController(
                    size: .small,
                    leftIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.SolidButtonController(
                    size: .small,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.SolidButtonController(
                    size: .small,
                    leftIcon: .apps,
                    rightIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
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
