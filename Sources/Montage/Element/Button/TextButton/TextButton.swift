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
        @State private var isLongPressSessionActive = false
        @State private var frame: CGRect = .zero
        @State private var startingFrame: CGRect = .zero
        @State private var isDragging: Bool = false

        /// 버튼의 외관입니다.
        private let variant: TextButton.Variant
        
        /// 버튼의 사이즈입니다.
        private let size: TextButton.Size
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        private let leftIcon: Icon?
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        private let rightIcon: Icon?
        
        /// 버튼에서 표현될 텍스트입니다.
        private let text: String
        
        /// 버튼의 활성화 여부입니다.
        private let disable: Bool
        
        /// 커스텀 가능한 컨텐트(텍스트, 아이콘) 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        private let contentColor: SwiftUI.Color?
        
        /// 커스텀 가능한 텍스트 사이즈입니다.
        /// montage의 모든 Typography.Variant를 사용할 수 있습니다.
        private let fontSize: Typography.Variant?
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        private let handler: (() -> Void)?
        
        public init(
            variant: TextButton.Variant = .primary,
            size: TextButton.Size = .medium,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String,
            disable: Bool = false,
            contentColor: SwiftUI.Color? = nil,
            fontSize: Typography.Variant? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
            self.disable = disable
            self.contentColor = contentColor
            self.fontSize = fontSize
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
            SwiftUI.Button {} label: {
                HStack(alignment: .center, spacing: 4) {
                    if let leftIcon {
                        icon(leftIcon)
                    }
                    Text(text)
                        .montage(
                            variant: size.typoVariant,
                            weight: size.typoWeight,
                            color: typoColor
                        )
                    if let rightIcon {
                        icon(rightIcon)
                    }
                }
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
            .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { frame = $0 }
            .onLongPressGesture(perform: {}, onPressingChanged: {
                isLongPressSessionActive = $0 // 스크롤로 인해 버튼 frame이 변경되면 longPress 세션이 종료됨
                guard isPressed != $0, !isDragging else { return }
                if isPressed {
                    handler?()
                    startingFrame = .zero
                } else {
                    startingFrame = frame
                }
                isPressed = $0
            })
            .simultaneousGesture(
                DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                    .onChanged { value in
                        isDragging = true
                        // 스크롤되면 press상태가 해제되고 다시 버튼을 누르기 전까지는 press상태가 다시 켜지는 일이 없음
                        isPressed = isLongPressSessionActive && startingFrame.contains(value.location)
                    }
                    .onEnded { value in
                        if isLongPressSessionActive && startingFrame.contains(value.location) {
                            handler?()
                        }
                        isPressed = false
                        isDragging = false
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
                        leftIcon: .bubbleFill,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        leftIcon: .bubbleFill,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    )
                }
                
                HStack {
                    Button.TextButton(
                        variant: .assistive,
                        leftIcon: .bubbleFill,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        variant: .assistive,
                        rightIcon: .circleClose,
                        text: "안녕하세요"
                    )
                    
                    Button.TextButton(
                        variant: .assistive,
                        leftIcon: .bubbleFill,
                        rightIcon: .circleClose,
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
                        text: "accentCyan",
                        disable: false,
                        contentColor: .alias(.accentCyan)
                    )
                    
                    Button.TextButton(
                        text: "globalBlue40",
                        disable: false,
                        contentColor: .atomic(.globalBlue40)
                    )
                }
                
                HStack {
                    Button.TextButton(
                        text: "body1",
                        disable: false,
                        contentColor: .alias(.accentCyan),
                        fontSize: .body1
                    )
                    
                    Button.TextButton(
                        text: "heading1",
                        disable: false,
                        contentColor: .atomic(.globalBlue40),
                        fontSize: .heading1
                    )
                }
            }
        }
    }
}
