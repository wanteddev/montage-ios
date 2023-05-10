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
        @State public var size: SolidButton.Size = .medium
        @State public var leftIcon: Icon?
        @State public var rightIcon: Icon?
        @State public var text: String
        @State public var state: Decorate.Interaction.State = .normal
        @State public var disable: Bool = false
        @State public var handler: (() -> Void)?
        
        public typealias UIViewType = SolidButton
        
        public init(
            size: SolidButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
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
            uiView.state = state
            uiView.disable = disable
            uiView.handler = handler
        }
    }
}

var roundButtonControllerPreview: some View {
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

struct RoundButtonController_Previews: PreviewProvider {
    static var previews: some View {
        roundButtonControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
