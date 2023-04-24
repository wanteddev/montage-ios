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
        @State public var size: TextButton.Size = .medium
        @State public var leftIcon: Icon?
        @State public var rightIcon: Icon?
        @State public var text: String
        @State public var disable: Bool = false
        @State public var handler: (() -> Void)?
        
        public typealias UIViewType = TextButton
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
            uiView.disable = disable
            uiView.handler = handler
        }
    }
}

var textButtonControllerPreview: some View {
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
        }
    }
}

struct TextButtonController_Previews: PreviewProvider {
    static var previews: some View {
        textButtonControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
