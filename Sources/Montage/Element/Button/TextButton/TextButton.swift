//
//  TextButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

import Pretendard

extension Button.TextButton {
    /// 버튼의 외관을 결정하는 열거형입니다.
    public enum Variant {
        case primary
        case assistive
    }
    
    /// 버튼의 사이즈를 결정하는 열거형입니다.
    public enum Size {
        case medium, small
    }
}

extension Button.TextButton.Variant {
    var activeUIColor: UIColor {
        switch self {
        case .primary: .alias(.primaryNormal)
        case .assistive: .alias(.labelAlternative).withAlphaComponent(0.61)
        }
    }
    
    var activeColor: SwiftUI.Color {
        .init(uiColor: activeUIColor)
    }
    
    var inactiveUIColor: UIColor {
        .alias(.labelDisable).withAlphaComponent(0.16)
    }
    
    var inactiveColor: SwiftUI.Color {
        .init(uiColor: inactiveUIColor)
    }

    var interactionRadius: CGFloat {
        6.0
    }
    
    var interactionVariant: Decorate.Interaction.Variant {
        switch self {
        case .primary: .normal
        case .assistive: .light
        }
    }
    
    var interactionColor: Color.Alias {
        switch self {
        case .primary: .primaryNormal
        case .assistive: .labelNormal
        }
    }

    var interactionVerticalOffset: CGFloat { 4 }
    var interactionHorizontalOffset: CGFloat { 7 }
}

extension Button.TextButton.Size {
    var iconSize: CGSize {
        switch self {
        case .medium:
            return .init(width: 20, height: 20)
        case .small:
            return .init(width: 16, height: 16)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .medium:
            return .body1
        case .small:
            return .label1
        }
    }
    
    var typoWeight: Typography.Weight {
        return .bold
    }
}

extension Button {
    public struct TextButton: View {
        @State private var isPressed = false

        public let variant: TextButton.Variant
        public let size: TextButton.Size
        public let leftIcon: Icon?
        public let rightIcon: Icon?
        public let text: String
        public let disable: Bool
        public let contentColorResolver: ColorResolvable?
        public let fontSize: Typography.Variant?
        public let handler: (() -> Void)?
        
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
        
        private var typoColor: SwiftUI.Color {
            if disable {
                variant.inactiveColor
            } else {
                if let contentColorResolver {
                    .init(uiColor: contentColorResolver.resolve(.current))
                } else {
                    variant.activeColor
                }
            }
        }
        
        public var body: some View {
            SwiftUI.Button {} label: {
                Text(text)
                    .montage(
                        variant: size.typoVariant,
                        weight: size.typoWeight,
                        color: typoColor
                    )
            }
            .overlay {
                Decorate.InteractionController(
                    state: isPressed ? .pressed : .normal,
                    variant: variant.interactionVariant,
                    color: variant.interactionColor
                )
                .clipShape(RoundedRectangle(cornerRadius: variant.interactionRadius))
                .padding(.vertical, -variant.interactionVerticalOffset)
                .padding(.horizontal, -variant.interactionHorizontalOffset)
            }
            .onLongPressGesture(
                minimumDuration: 2.0,
                perform: {
                    isPressed = true
                },
                onPressingChanged: { state in
                    isPressed = state
                    if state == false {
                        handler?()
                    }
                }
            )
            .allowsHitTesting(disable == false)
        }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButtonPreview()
    }
}

struct TextButtonPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("Size").montage(variant: .headline2)
            
            HStack {
                Button.TextButton(
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButton(
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButton(
                    variant: .assistive,
                    text: "안녕하세요"
                ).fixedSize()
                
                Button.TextButton(
                    variant: .assistive,
                    size: .small,
                    text: "안녕하세요"
                ).fixedSize()
            }
            
            Text("Icon").montage(variant: .headline2)
            
            VStack(alignment: .leading) {
                HStack {
                    Button.TextButton(
                        leftIcon: .bubbleFill,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Button.TextButton(
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Button.TextButton(
                        leftIcon: .bubbleFill,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    ).fixedSize()
                }
                
                HStack {
                    Button.TextButton(
                        variant: .assistive,
                        leftIcon: .bubbleFill,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Button.TextButton(
                        variant: .assistive,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    ).fixedSize()
                    
                    Button.TextButton(
                        variant: .assistive,
                        leftIcon: .bubbleFill,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    ).fixedSize()
                }
            }
            
            Text("State").montage(variant: .headline2)
            
            HStack {
                Button.TextButton(
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Button.TextButton(
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
                
                Button.TextButton(
                    variant: .assistive,
                    text: "안녕하세요",
                    disable: false
                ).fixedSize()
                
                Button.TextButton(
                    variant: .assistive,
                    text: "안녕하세요",
                    disable: true
                ).fixedSize()
            }
            
            Text("Custom").montage(variant: .headline2)
            
            VStack(alignment: .leading) {
                HStack {
                    Button.TextButton(
                        text: "accentCyan",
                        disable: false,
                        contentColorResolver: Color.Alias.accentCyan
                    ).fixedSize()
                    
                    Button.TextButton(
                        text: "globalBlue40",
                        disable: false,
                        contentColorResolver: Color.Global.globalBlue40
                    ).fixedSize()
                }
                
                HStack {
                    Button.TextButton(
                        text: "body1",
                        disable: false,
                        contentColorResolver: Color.Alias.accentCyan,
                        fontSize: .body1
                    ).fixedSize()
                    
                    Button.TextButton(
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
