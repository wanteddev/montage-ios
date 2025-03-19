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
        case .primary: .semantic(.primaryNormal)
        case .assistive: .semantic(.labelAlternative).withAlphaComponent(0.61)
        }
    }
    
    var activeColor: SwiftUI.Color {
        .init(uiColor: activeUIColor)
    }
    
    var inactiveUIColor: UIColor {
        .semantic(.labelDisable).withAlphaComponent(0.16)
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
    
    var interactionColor: Color.Semantic {
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
            .init(width: 20, height: 20)
        case .small:
            .init(width: 16, height: 16)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .medium:
            .body1
        case .small:
            .label1
        }
    }
    
    var typoWeight: Typography.Weight {
        .bold
    }
}

extension Button {
    public struct TextButton: View {
        @State private var isPressed = false

        /// 버튼의 외관입니다.
        private let variant: TextButton.Variant
        
        /// 버튼의 사이즈입니다.
        private let size: TextButton.Size
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        private let leadingIcon: Icon?
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        private let trailingIcon: Icon?
        
        /// 버튼에서 표현될 텍스트입니다.
        private let text: String
        
        /// 버튼의 활성화 여부입니다.
        private let disable: Bool
        
        /// 커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        private let contentColor: SwiftUI.Color?
        
        /// 커스텀 가능한 텍스트 사이즈입니다.
        /// montage의 모든 Typography.Variant를 사용할 수 있습니다.
        private let fontVariant: Typography.Variant?
        
        private let fontWeight: Typography.Weight?
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        private let handler: (() -> Void)?
        
        public init(
            variant: TextButton.Variant = .primary,
            size: TextButton.Size = .medium,
            leadingIcon: Icon? = nil,
            trailingIcon: Icon? = nil,
            text: String,
            disable: Bool = false,
            contentColor: SwiftUI.Color? = nil,
            fontVariant: Typography.Variant? = nil,
            fontWeight: Typography.Weight? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.leadingIcon = leadingIcon
            self.trailingIcon = trailingIcon
            self.text = text
            self.disable = disable
            self.contentColor = contentColor
            self.fontVariant = fontVariant
            self.fontWeight = fontWeight
            self.handler = handler
        }
        
        // MARK: Private Computed Property
        
        private var typoColor: SwiftUI.Color {
            if disable {
                variant.inactiveColor
            } else {
                if let contentColor {
                    contentColor
                } else {
                    variant.activeColor
                }
            }
        }
        
        private var iconColor: SwiftUI.Color {
            if disable {
                variant.inactiveColor
            } else {
                if let contentColor {
                    contentColor
                } else {
                    variant.activeColor
                }
            }
        }
        
        public var body: some View {
            HStack(alignment: .center, spacing: 4) {
                if let leadingIcon {
                    icon(leadingIcon)
                }
                Text(text)
                    .montage(
                        variant: fontVariant ?? size.typoVariant,
                        weight: fontWeight ?? size.typoWeight,
                        color: typoColor
                    )
                if let trailingIcon {
                    icon(trailingIcon)
                }
            }
            .background {
                Decorate.Interaction(
                    state: isPressed ? .pressed : .normal,
                    variant: variant.interactionVariant,
                    color: variant.interactionColor
                )
                .clipShape(RoundedRectangle(cornerRadius: variant.interactionRadius))
                .padding(.vertical, -variant.interactionVerticalOffset)
                .padding(.horizontal, -variant.interactionHorizontalOffset)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isPressed = value.translation == .zero
                    }
                    .onEnded { value in
                        isPressed = false
                        if value.translation == .zero {
                            handler?()
                        }
                    }
            )
            .allowsHitTesting(disable == false)
        }
        
        private func icon(_ i: Icon) -> some View {
            Image.montage(i)
                .resizable()
                .frame(
                    width: size.iconSize.width,
                    height: size.iconSize.height
                )
                .foregroundStyle(iconColor)
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
                )
                
                Button.TextButton(
                    size: .small,
                    text: "안녕하세요"
                )
                
                Button.TextButton(
                    variant: .assistive,
                    text: "안녕하세요"
                )
                
                Button.TextButton(
                    variant: .assistive,
                    size: .small,
                    text: "안녕하세요"
                )
            }
            
            Text("Icon").montage(variant: .headline2)
            
            VStack(alignment: .leading) {
                HStack {
                    Button.TextButton(
                        leadingIcon: .bubbleFill,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        trailingIcon: .circleCloseFill,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        leadingIcon: .bubbleFill,
                        trailingIcon: .circleCloseFill,
                        text: "안녕하세요"
                    )
                }
                
                HStack {
                    Button.TextButton(
                        variant: .assistive,
                        leadingIcon: .bubbleFill,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        variant: .assistive,
                        trailingIcon: .circleCloseFill,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        variant: .assistive,
                        leadingIcon: .bubbleFill,
                        trailingIcon: .circleCloseFill,
                        text: "안녕하세요"
                    )
                }
            }
            
            Text("State").montage(variant: .headline2)
            
            HStack {
                Button.TextButton(
                    text: "안녕하세요",
                    disable: false
                )
                
                Button.TextButton(
                    text: "안녕하세요",
                    disable: true
                )
                
                Button.TextButton(
                    variant: .assistive,
                    text: "안녕하세요",
                    disable: false
                )
                
                Button.TextButton(
                    variant: .assistive,
                    text: "안녕하세요",
                    disable: true
                )
            }
            
            Text("Custom").montage(variant: .headline2)
            
            VStack(alignment: .leading) {
                HStack {
                    Button.TextButton(
                        text: "accentBackgroundCyan",
                        disable: false,
                        contentColor: .semantic(.accentBackgroundCyan)
                    )
                    
                    Button.TextButton(
                        text: "blue40",
                        disable: false,
                        contentColor: .atomic(.blue40)
                    )
                }
                
                HStack {
                    Button.TextButton(
                        text: "body1",
                        disable: false,
                        contentColor: .semantic(.accentBackgroundCyan),
                        fontVariant: .body1
                    )
                    
                    Button.TextButton(
                        text: "heading1",
                        disable: false,
                        contentColor: .atomic(.blue40),
                        fontVariant: .heading1
                    )
                }
            }
        }
    }
}
