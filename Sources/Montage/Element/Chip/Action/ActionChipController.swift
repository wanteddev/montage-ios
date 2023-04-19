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
        @State public var varient: Action.Varient = .filled
        @State public var size: Action.Size = .medium
        @State public var leftIcon: Icon?
        @State public var rightIcon: Icon?
        @State public var text: String = ""
        @State public var state: Decorate.Interaction.State = .normal
        @State public var disable: Bool = false
        
        public typealias UIViewType = Action
        
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
        }
    }
}

struct ActionChipController_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            VStack(alignment: .leading) {
                Text("Varient").montage()
                HStack {
                    Chip.ActionChipController(
                        varient: .filled,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Chip.ActionChipController(
                        varient: .outlined,
                        text: "안녕하세요"
                    ).fixedSize()
                }
            }
            
            VStack(alignment: .leading) {
                Text("State").montage()
                HStack {
                    Chip.ActionChipController(
                        varient: .filled,
                        text: "안녕하세요",
                        disable: false
                    ).fixedSize()
                    
                    Chip.ActionChipController(
                        varient: .filled,
                        text: "안녕하세요",
                        disable: true
                    ).fixedSize()
                }
                HStack {
                    Chip.ActionChipController(
                        varient: .outlined,
                        text: "안녕하세요",
                        disable: false
                    ).fixedSize()
                    
                    Chip.ActionChipController(
                        varient: .outlined,
                        text: "안녕하세요",
                        disable: true
                    ).fixedSize()
                }
            }
            
            VStack(alignment: .leading) {
                Text("State").montage()
                HStack(alignment: .center) {
                    Chip.ActionChipController(
                        varient: .filled,
                        size: .small,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Chip.ActionChipController(
                        varient: .filled,
                        size: .medium,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Chip.ActionChipController(
                        varient: .filled,
                        size: .large,
                        text: "안녕하세요"
                    ).fixedSize()
                }
            }
        }
        .onAppear {
            try! Pretendard.registerFonts()
        }
    }
}
