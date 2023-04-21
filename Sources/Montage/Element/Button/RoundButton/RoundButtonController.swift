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

struct RoundButtonController_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            VStack(alignment: .leading) {
                Text("Primary").montage()
                Button.RoundButtonController(
                    varient: .primary,
                    size: .large,
                    text: "안녕하세요"
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
            }
            
            VStack(alignment: .leading) {
                Text("Alternative").montage()
                Button.RoundButtonController(
                    varient: .alternative,
                    size: .medium,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            VStack(alignment: .leading) {
                Text("Secondary").montage()
                Button.RoundButtonController(
                    varient: .secondary,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            VStack(alignment: .leading) {
                Text("Assistive").montage()
                Button.RoundButtonController(
                    varient: .assistive,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            VStack(alignment: .leading) {
                Text("Primary with left icon").montage()
                Button.RoundButtonController(
                    varient: .primary,
                    size: .large,
                    leftIcon: .apps,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            VStack(alignment: .leading) {
                Text("Primary with right icon").montage()
                Button.RoundButtonController(
                    varient: .primary,
                    size: .medium,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
        .onAppear {
            try! Pretendard.registerFonts()
        }
    }
}
