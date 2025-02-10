//
//  TextInput.swift
//  Montage
//
//  Created by ahn sanghoon on 8/1/24.
//

import SwiftUI

public struct TextInput: View {
    
    // MARK: - Types
    
    /// TextInput의 외관을 결정하는 열거형입니다.
    public enum Status {
        case normal(description: String = "")
        case positive(description: String = "")
        case negative(description: String = "")
    }
    
    /// 오른쪽 버튼의 속성을 가지고 있는 타입입니다.
    public struct RightButton {
        fileprivate let variant: Montage.Button.OutlinedUIButton.Variant
        fileprivate let title: String
        fileprivate let handler: (() -> Void)?
        
        public init(
            variant: Montage.Button.OutlinedUIButton.Variant,
            title: String,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.title = title
            self.handler = handler
        }
    }
    
    // MARK: - Initializer
    
    @Binding private var text: String
    private let onCommit: (() -> Void)?
    
    public init(
        text: Binding<String>,
        onCommit: (() -> Void)? = nil
    ) {
        _text = text
        self.onCommit = onCommit
    }
    
    // MARK: - Modifiers
    
    private var status: Status = .normal()
    private var disable: Bool = false
    private var heading: String? = nil
    private var requiredBadge: Bool = false
    private var description: Bool = false
    private var placeholder: String? = nil
    private var icon: Icon? = nil
    private var rightButton: RightButton? = nil
    private var rightContent: (() -> any View)? = nil

    /// 상태를 조정합니다.
    public func status(_ status: Status) -> Self {
        var zelf = self
        zelf.status = status
        return zelf
    }

    /// 사용가능 여부를 조정합니다.
    public func disable(_ disable: Bool) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 제목을 표시합니다.
    public func heading(_ heading: String?) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    /// 필수값임을 나타내는 뱃지를 제목 옆에 노출할지 여부를 조정합니다. 제목이 없으면 노출되지 않습니다.
    public func requiredBadge(_ requiredBadge: Bool) -> Self {
        var zelf = self
        zelf.requiredBadge = requiredBadge
        return zelf
    }
    
    /// 입력된 텍스트가 없을 때 노출되는 placeholder를 지정합니다.
    public func placeholder(_ placeholder: String?) -> Self {
        var zelf = self
        zelf.placeholder = placeholder
        return zelf
    }

    /// 왼쪽에 표시될 아이콘을 지정합니다.
    public func icon(_ icon: Icon?) -> Self {
        var zelf = self
        zelf.icon = icon
        return zelf
    }
    
    /// 오른쪽에 표시될 버튼의 속성을 지정합니다. `rightContent`와 함께 사용될 경우 `rightButton`이 우선순위가 높습니다.
    public func rightButton(_ rightButton: RightButton?) -> Self {
        var zelf = self
        zelf.rightButton = rightButton
        return zelf
    }
    
    /// 오른쪽에 표시될 컨텐츠를 지정합니다. `rightButton`과 함께 사용하는 경우 `rightContent`가 무시됩니다.
    public func rightContent(_ rightContent: (() -> any View)?) -> Self {
        var zelf = self
        zelf.rightContent = rightContent
        return zelf
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let heading {
                HStack(spacing: 4) {
                    Text(heading)
                        .montage(variant: .label1, weight: .bold, alias: .labelNeutral)
                        .paragraph(variant: .label1)
                    if requiredBadge {
                        Text("*")
                            .montage(variant: .label1, weight: .medium, alias: .statusNegative)
                    }
                }
            }
            Field(
                text: $text,
                status: status,
                disable: disable,
                placeholder: placeholder,
                icon: icon,
                rightButton: rightButton,
                rightContent: rightContent
            )
            Group {
                switch status {
                case .positive(let caption), .negative(let caption), .normal(let caption):
                    if caption.isEmpty == false {
                        Text(caption)
                            .montage(
                                variant: .caption1,
                                color: captionTextColor
                            )
                            .paragraph(variant: .caption1)
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    
    private var captionTextColor: SwiftUI.Color {
        switch status {
        case .negative:
            .alias(.statusNegative)
        default:
            .alias(.labelAlternative)
        }
    }
    
    // MARK: - Inner Views
    
    private struct Field: View {

        @Binding private var text: String
        private let status: Status
        private let disable: Bool
        private let placeholder: String?
        private let icon: Icon?
        private let rightButton: RightButton?
        private let rightContent: (() -> any View)?

        init(
            text: Binding<String>,
            status: Status,
            disable: Bool,
            placeholder: String?,
            icon: Icon?,
            rightButton: RightButton?,
            rightContent: (() -> any View)?
        ) {
            self._text = text
            self.status = status
            self.disable = disable
            self.placeholder = placeholder
            self.icon = icon
            self.rightButton = rightButton
            self.rightContent = rightContent
        }
        
        @FocusState var textFieldFocusState: Bool
        @State private var height: CGFloat = 0

        var body: some View {
            HStack(spacing: .zero) {
                ZStack {
                    HStack(spacing: 9) {
                        if let icon {
                            Image.montage(icon)
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundStyle(SwiftUI.Color.alias(.labelAlternative))
                        }
                        TextField(
                            "",
                            text: $text,
                            prompt: {
                                if let placeholder {
                                    Text(placeholder)
                                        .montage(
                                            variant: .body1,
                                            weight: .regular,
                                            color: placeholderTextColor
                                        )
                                } else {
                                    nil
                                }
                            }()
                        )
                        .font(.montage(variant: .body1, weight: .regular))
                        .foregroundStyle(fieldTextColor)
                        .focused($textFieldFocusState)
                        .frame(minHeight: 24)
                        .padding(.horizontal, 4)

                        if !text.isEmpty, textFieldFocusState {
                            Image.montage(.circleCloseFill)
                                .frame(width: 22, height: 22)
                                .foregroundStyle(SwiftUI.Color.alias(.labelAssistive))
                                .onTapGesture { text = "" }
                        } else {
                            if let rightIcon, let rightIconColor {
                                Image
                                    .montage(rightIcon)
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(rightIconColor)
                            }
                        }
                        
                        if rightButton == nil, let rightContent {
                            AnyView(rightContent())
                        }
                    }
                    .padding(.all, 12)
                    .overlay {
                        if rightButton == nil {
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(fieldStrokeColor, lineWidth: textFieldFocusState ? 2 : 1)
                                .padding(.all, textFieldFocusState ? 2 : 1)
                        } else {
                            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, bottomLeading: 12))
                                .stroke(fieldStrokeColor, lineWidth: textFieldFocusState ? 2 : 1)
                                .padding([.top, .bottom, .leading], textFieldFocusState ? 2 : 1)
                        }
                    }
                    .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { height = $0 })
                }
                
                if let rightButton {
                    ZStack {
                        FieldButton(
                            variant: rightButton.variant,
                            title: rightButton.title,
                            handler: rightButton.handler
                        )
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 12, topTrailing: 12))
                            .stroke(SwiftUI.Color.alias(.lineNeutral), lineWidth: 1)
                            .padding([.top, .trailing, .bottom], textFieldFocusState ? 2 : 1)

                            .clipShape(
                                Rectangle()
                                    .offset(x: textFieldFocusState ? 1 : 0.7, y: .zero)
                            )
                            .frame(height: height)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
            .frame(minHeight: 48)
            .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .allowsHitTesting(disable == false)
        }
        
        private var fieldStrokeColor: SwiftUI.Color {
            if textFieldFocusState {
                switch status {
                case .normal, .positive:
                    .alias(.primaryNormal).opacity(0.43)
                case .negative:
                    .alias(.statusNegative).opacity(0.43)
                }
            } else {
                switch status {
                case .normal, .positive:
                    .alias(.lineNeutral)
                case .negative:
                    .alias(.statusNegative).opacity(0.43)
                }
            }
        }
        
        private var rightIcon: Icon? {
            switch status {
            case .positive:
                .circleCheckFill
            case .negative:
                .circleExclamationFill
            default:
                nil
            }
        }
        
        private var rightIconColor: SwiftUI.Color? {
            switch status {
            case .positive:
                .alias(.primaryNormal)
            case .negative:
                .alias(.statusNegative)
            default:
                nil
            }
        }

        private var placeholderTextColor: SwiftUI.Color {
            disable ? .alias(.labelDisable) : .alias(.labelAssistive)
        }
        
        private var fieldTextColor: SwiftUI.Color {
            disable ? .alias(.labelAlternative) : .alias(.labelNormal)
        }
    }
    
    private struct FieldButton: View {
        
        private let variant: Button.OutlinedUIButton.Variant
        private let title: String
        private let handler: (() -> Void)?
        
        init(variant: Button.OutlinedUIButton.Variant, title: String, handler: (() -> Void)?) {
            self.variant = variant
            self.title = title
            self.handler = handler
        }
        
        @State private var isPressed = false
        
        var body: some View {
            Text(title)
                .montage(variant: .body1, weight: variant.typoWeight, alias: variant.textColor)
                .paragraph(variant: .body1)
                .background(
                    Decorate.Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .backgroundNormal
                    )
                    .padding(.horizontal, -7)
                    .padding(.vertical, -4)
                )
                .onLongPressGesture(
                    minimumDuration: 2.0,
                    perform: {},
                    onPressingChanged: { state in
                        isPressed = state
                        if state == false {
                            handler?()
                        }
                    }
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SwiftUI.Color.clear)
                }
                .padding(.horizontal, 19)
                .padding(.vertical, 12)
        }
    }
}
