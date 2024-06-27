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
        public var variant: TextButton.Variant = .primary
        public var size: TextButton.Size = .medium
        public var leftIcon: Icon?
        public var rightIcon: Icon?
        public var text: String
        public var disable: Bool = false
        public var contentColorResolver: ColorResolvable? = nil
        public var fontSize: Typography.Variant? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = TextButton
        
        public init(
            variant: TextButton.Variant = .primary,
            size: TextButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            disable: Bool = false,
            contentColorResolver: ColorResolvable? = nil,
            fontSize: Typography.Variant? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
            self.disable = disable
            self.contentColorResolver = contentColorResolver
            self.fontSize = fontSize
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
            uiView.disable = disable
            uiView.contentColorResolver = contentColorResolver
            uiView.fontSize = fontSize
            uiView.handler = handler
        }
    }
}

struct TextButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("Size").montage(variant: .headline2)
            
            HStack {
                Button.TextButtonController(
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    variant: .assistive,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButtonController(
                    variant: .assistive,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            Text("Icon").montage(variant: .headline2)
            
            VStack(alignment: .leading) {
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
                
                HStack {
                    Button.TextButtonController(
                        variant: .assistive,
                        leftIcon: .bubbleFill,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Button.TextButtonController(
                        variant: .assistive,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Button.TextButtonController(
                        variant: .assistive,
                        leftIcon: .bubbleFill,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    ).fixedSize()
                }
            }
            
            Text("State").montage(variant: .headline2)
            
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
                    variant: .assistive,
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Button.TextButtonController(
                    variant: .assistive,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
            
            Text("Custom").montage(variant: .headline2)
            
            VStack(alignment: .leading) {
                HStack {
                    Button.TextButtonController(
                        text: "accentCyan",
                        disable: false,
                        contentColorResolver: Color.Alias.accentCyan
                    ).fixedSize()
                    
                    Button.TextButtonController(
                        text: "globalBlue40",
                        disable: false,
                        contentColorResolver: Color.Global.globalBlue40
                    ).fixedSize()
                }
                
                HStack {
                    Button.TextButtonController(
                        text: "body1",
                        disable: false,
                        contentColorResolver: Color.Alias.accentCyan,
                        fontSize: .body1
                    ).fixedSize()
                    
                    Button.TextButtonController(
                        text: "heading1",
                        disable: false,
                        contentColorResolver: Color.Global.globalBlue40,
                        fontSize: .heading1
                    ).fixedSize()
                }
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
