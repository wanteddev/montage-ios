//
//  RoundButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import SwiftUI
import Pretendard

extension Button {
    public struct RoundButtonController: UIViewRepresentable {
        @State public var varient: RoundButton.Varient
        @State public var size: RoundButton.Size = .medium
        @State public var leftIcon: Icon?
        @State public var rightIcon: Icon?
        @State public var text: String
        @State public var state: Decorate.Interaction.State = .normal
        @State public var disable: Bool = false
        @State public var handler: (() -> Void)?
        
        public typealias UIViewType = RoundButton
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
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
        Text("Varient").montage()
        
        VStack(alignment: .leading, spacing: .spacing(.pt16)) {
            HStack {
                Button.RoundButtonController(
                    varient: .primary,
                    size: .medium,
                    text: "안녕하세요"
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.RoundButtonController(
                    varient: .alternative,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.RoundButtonController(
                    varient: .secondary,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            HStack {
                Button.RoundButtonController(
                    varient: .assistive,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.RoundButtonController(
                    varient: .assistive,
                    size: .medium,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        
        Text("Size").montage()
        
        HStack {
            Button.RoundButtonController(
                varient: .secondary,
                size: .small,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.RoundButtonController(
                varient: .secondary,
                size: .medium,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.RoundButtonController(
                varient: .secondary,
                size: .large,
                text: "안녕하세요"
            ).fixedSize()
        }
        
        Text("Icon").montage()
        
        HStack {
            Button.RoundButtonController(
                varient: .secondary,
                size: .small,
                leftIcon: .apps,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.RoundButtonController(
                varient: .secondary,
                size: .small,
                rightIcon: .apps,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.RoundButtonController(
                varient: .secondary,
                size: .small,
                leftIcon: .apps,
                rightIcon: .apps,
                text: "안녕하세요"
            ).fixedSize()
        }
        
        Text("State").montage()
        
        HStack {
            Button.RoundButtonController(
                varient: .primary,
                size: .medium,
                rightIcon: .chevronRightThick,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.RoundButtonController(
                varient: .primary,
                size: .medium,
                rightIcon: .chevronRightThick,
                text: "안녕하세요",
                disable: true
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
