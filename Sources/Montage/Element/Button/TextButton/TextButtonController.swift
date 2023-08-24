//
//  TextButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

import Pretendard

extension Button {
    public struct TextButtonController: UIViewRepresentable {
        public var varient: TextButton.Varient = .primary
        public var size: TextButton.Size = .medium
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String
        public var disable: Bool = false
        public var handler: (() -> Void)?
        
        public typealias UIViewType = TextButton
        
        public init(
            varient: TextButton.Varient = .primary,
            size: TextButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.varient = varient
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
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
            uiView.disable = disable
            uiView.handler = handler
        }
    }
}

struct TextButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("Size").montage(varient: .heading2)
            
            HStack {
                Button.TextButtonController(
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            Text("Icon").montage(varient: .heading2)
            
            HStack {
                Button.TextButtonController(
                    leftIcon: .bubbleFill,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    rightIcon: .circleClose,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    leftIcon: .bubbleFill,
                    rightIcon: .circleClose,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    leftIcon: .bubbleFill,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    rightIcon: .circleClose,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    leftIcon: .bubbleFill,
                    rightIcon: .circleClose,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            Text("State").montage(varient: .heading2)
            
            HStack {
                Button.TextButtonController(
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Button.TextButtonController(
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Button.TextButtonController(
                    varient: .assistive,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
        }
    }
}

struct TextButtonController_Previews: PreviewProvider {
    static var previews: some View {
        TextButtonControllerPreview()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
