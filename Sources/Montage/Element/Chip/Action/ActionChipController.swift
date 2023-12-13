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
        public var varient: Action.Varient = .filled
        public var size: Action.Size = .medium
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String = ""
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Action
        
        public init(
            varient: Action.Varient = .filled,
            size: Action.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.varient = varient
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

var actionChipControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        VStack(alignment: .leading) {
            Text("Varient").montage(varient: .headline2)
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
            Text("State").montage(varient: .headline2)
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
            Text("Size").montage(varient: .headline2)
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
}

struct ActionChipController_Previews: PreviewProvider {
    static var previews: some View {
        actionChipControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
