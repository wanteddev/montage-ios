//
//  TextInput.swift
//  Montage
//
//  Created by ahn sanghoon on 8/1/24.
//

import SwiftUI

public struct TextInput: View {
    /// TextInput의 외관을 결정하는 열거형입니다.
    public enum Status {
        case normal
        case positive
        case negative
    }
    
    @Binding private var text: String
    @State private var active = false
    
    /// TextInput의 외관입니다.
    public var status: Status

    /// TextInput의 사용가능 여부입니다.
    public var disable: Bool
    
    /// TextInput의 제목입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    public var heading: String?
    
    /// TextInput의 필수 표시 노출 여부입니다.
    public var requiredBadge: Bool
    
    /// TextInput의 설명입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    public var description: TextInput.Description?
    
    /// TextInput에 입력된 텍스트가 없을 때 노출되는 placeholder입니다.
    ///  > 값을 지정하지 않으면 노출되지 않습니다.
    public var placeholder: String? = nil

    /// TextInput의 왼쪽 아이콘입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    public var icon: Icon?
    
    /// TextInput의 오른쪽 버튼입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    public var rightButton: Resource.Button?
    
    /// TextInput의 오른쪽 컨텐츠입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    /// >
    /// > rightButton과 함께 사용하는 경우 rightContent가 무시됩니다.
    public var rightContent: (() -> any View)?
    
    /// TextInput의 onCommit시 실행될 내용입니다.
    public var onCommit: (() -> Void)?
    
    public init(
        text: Binding<String>,
        status: Status = .normal,
        disable: Bool = false,
        heading: String? = nil,
        requiredBadge: Bool = false,
        description: TextInput.Description? = nil,
        placeholder: String? = nil,
        icon: Icon? = nil,
        rightButton: Resource.Button? = nil,
        rightContent: (() -> any View)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        _text = text
        self.status = status
        self.disable = disable
        self.heading = heading
        self.requiredBadge = requiredBadge
        self.description = description
        self.placeholder = placeholder
        self.icon = icon
        self.rightButton = rightButton
        self.rightContent = rightButton == nil ? rightContent : nil
        self.onCommit = onCommit
    }
    
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
                active: $active,
                status: status,
                disable: disable,
                placeholder: placeholder,
                icon: icon,
                rightButton: rightButton,
                rightContent: rightContent
            )
            if let description {
                let message: String = {
                    if status == .positive {
                        description.positive ?? description.normal
                    } else if status == .negative {
                        description.negative ?? description.normal
                    } else {
                        description.normal
                    }
                }()
                if message.isEmpty == false {
                    Text(message)
                        .montage(
                            variant: .caption1,
                            alias: status == .negative ? .statusNegative : .labelAlternative
                        )
                        .paragraph(variant: .caption1)
                }
            }
        }
        .onChange(of: text) { newValue in
            active = (newValue.isEmpty == false)
        }
    }
    
    private struct Field: View {
        @FocusState var textFieldFocusState: Bool

        @Binding var text: String
        @Binding var active: Bool
        
        var status: Status
        var disable: Bool
        var placeholder: String?
        var icon: Icon?
        var rightButton: Resource.Button?
        var rightContent: (() -> any View)?

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

        private var placeholderTextColor: SwiftUI.Color {
            disable ? .alias(.labelDisable) : .alias(.labelAssistive)
        }
        
        private var fieldTextColor: SwiftUI.Color {
            disable ? .alias(.labelAlternative) : .alias(.labelNormal)
        }
        
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
                        .paragraph(variant: .body1)
                        .foregroundStyle(fieldTextColor)
                        .focused($textFieldFocusState)
                        .frame(minHeight: 24)
                        .padding(.horizontal, 4)

                        if active, textFieldFocusState {
                            Image.montage(.circleClose)
                                .frame(width: 22, height: 22)
                                .foregroundStyle(SwiftUI.Color.alias(.labelAssistive))
                                .onTapGesture { text = "" }
                        } else {
                            if status == .positive || status == .negative {
                                Image
                                    .montage(status == .positive ? .circleCheckFill : .circleExclamationFill)
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(
                                        status == .positive ? SwiftUI.Color
                                            .alias(.primaryNormal) : .alias(.statusNegative)
                                    )
                            }
                        }
                        
                        if let rightContent {
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
                
                if case let .button(variant, title, handler) = rightButton {
                    ZStack {
                        FieldButton(
                            variant: variant,
                            title: title,
                            handler: handler
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
    }
    
    private struct FieldButton: View {
        @State private var isPressed = false
        
        let variant: Button.OutlinedUIButton.Variant
        let title: String
        let handler: (() -> Void)?
        
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

extension TextInput {
    public struct Description {
        var normal: String
        var positive: String?
        var negative: String?
        
        public init(
            normal: String = "",
            positive: String? = nil,
            negative: String? = nil
        ) {
            self.normal = normal
            self.positive = positive
            self.negative = negative
        }
    }
}

extension TextInput {
    public enum Resource {
        public enum Button {
            case button(
                variant: Montage.Button.OutlinedUIButton.Variant,
                title: String,
                handler: (() -> Void)? = nil
            )
        }
    }
}

struct TextInput_Preview: PreviewProvider {
    static var previews: some View {
        TextInput(
            text: .constant("값"),
            status: .normal,
            disable: false,
            heading: "주제",
            requiredBadge: true,
            description: .init(
                normal: "메세지에 마침표를 찍어요.",
                positive: "성공 메세지를 나타내요.",
                negative: "실패 메세지를 나타내요."
            ),
            icon: .apps,
            rightButton: .button(variant: .primary, title: "텍스트", handler: {}),
            rightContent: {
                Text("히히")
            }
        )
    }
}
