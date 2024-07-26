//
//  TextArea.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/24/24.
//

import SwiftUI

public struct TextArea: View {
    // MARK: - Environment
    
    /// TextArea의 Resize 여부에 관한 열거형입니다.
    /// - normal : 줄 수 제한이 없으며, 줄 수에 따라 영역이 늘어납니다.
    /// - limit : 최대 8줄 노출되며 초과 영역은 Scrollable 합니다.
    /// > iOS 15에서는 normal 인 경우에도 영역이 늘어나지 않는 현상이 있으니 사용시 주의하시기 바랍니다.
    public enum Resize {
        case normal
        case limit
    }
    
    /// TextArea의 외관을 결정하는 열거형입니다.
    public enum Variant {
        case normal
        case negative
    }
    
    // MARK: - Local state
    
    // MARK: - Uninitialised properties
    
    /// TextArea의 resize 여부 입니다.
    public var resize: Resize = .normal
    
    /// TextArea의 외관입니다.
    public var variant: Variant = .normal
    
    /// TextArea의 활성화 여부입니다.
    public var active: Bool = false
    
    /// TextArea의 포커싱 여부입니다.
    public var focus: Bool = false
    
    /// TextArea의 사용가능 여부입니다.
    public var disable: Bool = false
    
    /// TextArea의 제목 노출 여부입니다.
    /// > heading이 활성화 되어있는 경우에만 title이 노출됩니다.
    public var heading: Bool = false
    
    /// TextArea의 필수 표시 노출 여부입니다.
    public var requiredBadge: Bool = false
    
    /// TextArea의 하단 영역 노출 여부입니다.
    /// - 하단 영역 : 글자수 / 제한 글자수 / 버튼
    public var bottom: Bool = false
    
    /// TextArea 하단 설명입니다.
    public var description: String = ""
    
    /// TextArea에 입력된 텍스트가 없을 때 노출되는 placeholder입니다.
    ///  > 값을 지정하지 않으면 노출되지 않습니다.
    public var placeholder: String? = nil
    
    /// TextArea 하단 좌측의 컴포넌트입니다.
    public var leftResource: Resource? = nil
    
    /// TextArea 하단 우측의 컴포넌트입니다.
    public var rightResource: Resource? = nil
    
    public init(
        resize: Resize = .normal,
        variant: Variant = .normal,
        active: Bool = false,
        focus: Bool = false,
        disable: Bool = false,
        heading: Bool = false,
        requiredBadge: Bool = false,
        bottom: Bool = true,
        description: String = "",
        placeholder: String? = nil,
        leftResource: Resource? = nil,
        rightResource: Resource? = nil
    ) {
        self.resize = resize
        self.variant = variant
        self.active = active
        self.focus = focus
        self.disable = disable
        self.heading = heading
        self.requiredBadge = requiredBadge
        self.bottom = bottom
        self.description = description
        self.placeholder = placeholder
        self.leftResource = leftResource
        self.rightResource = rightResource
    }
    
    // MARK: - Computed properties
    // MARK: - Initialisers
    // MARK: - Helper functions
    // MARK: - ViewModifier properties
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if heading {
                HStack(spacing: 4) {
                    Text("주제")
                        .montage(variant: .label1, weight: .bold, color: .labelNeutral)
                    if requiredBadge {
                        Text("*")
                            .montage(variant: .label1, weight: .medium, color: .statusNegative)
                    }
                }
            }
            Editor(
                resize,
                variant,
                focus,
                disable,
                placeholder,
                bottom,
                leftResource,
                rightResource
            )
            Text(description)
                .montage(
                    variant: .caption1,
                    color: variant == .normal ? .labelAlternative : .statusNegative
                )
        }
    }
    
    private struct Editor: View {
        @FocusState private var textEditorFocusState: Bool
        @State private var text: String = ""
        @State private var typedCharacters: Int = 0

        private let resize: Resize
        private let variant: Variant
        private let focus: Bool
        private let disable: Bool
        private let placeholder: String?
        private let bottom: Bool
        private let leftResource: TextArea.Resource?
        private let rightResource: TextArea.Resource?
        
        init(
            _ resize: Resize,
            _ variant: Variant,
            _ focus: Bool,
            _ disable: Bool,
            _ placeholder: String?,
            _ bottom: Bool,
            _ leftResource: TextArea.Resource? = nil,
            _ rightResource: TextArea.Resource? = nil
        ) {
            self.resize = resize
            self.variant = variant
            self.focus = focus
            self.disable = disable
            self.placeholder = placeholder
            self.bottom = bottom
            self.leftResource = leftResource
            self.rightResource = rightResource
        }

        private var editorStrokeColor: SwiftUI.Color {
            if variant == .negative {
                return SwiftUI.Color.alias(.statusNegative).opacity(0.43)
            } else {
                return textEditorFocusState ? SwiftUI.Color.alias(.primaryNormal).opacity(0.43) : SwiftUI.Color.alias(.lineNormal)
            }
        }
        
        var body: some View {
            VStack(spacing: 12) {
                ZStack(alignment: .topLeading) {
                    if resize == .limit {
                        if #available(iOS 16, *) {
                            TextEditor(text: $text)
                                .font(.montage(variant: .body1))
                                .lineSpacing(Typography.Variant.body1.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36, maxHeight: 250)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .scrollContentBackground(.hidden)
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                        } else {
                            TextEditor(text: $text)
                                .font(.montage(variant: .body1))
                                .lineSpacing(Typography.Variant.body1.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36, maxHeight: 250)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .onAppear {
                                    UITextView.appearance().backgroundColor = .clear
                                }
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                        }
                    } else {
                        if #available(iOS 16, *) {
                            TextEditor(text: $text)
                                .foregroundStyle(disable ? SwiftUI.Color.alias(.labelDisable) : SwiftUI.Color.alias(.labelNormal))
                                .font(.montage(variant: .body1))
                                .lineSpacing(Typography.Variant.body1.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .scrollContentBackground(.hidden)
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                        } else {
                            TextEditor(text: $text)
                                .foregroundStyle(disable ? SwiftUI.Color.alias(.labelDisable) : SwiftUI.Color.alias(.labelNormal))
                                .font(.montage(variant: .body1))
                                .lineSpacing(Typography.Variant.body1.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .onAppear {
                                    UITextView.appearance().backgroundColor = .clear
                                }
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                        }
                    }
                    if $text.wrappedValue.isEmpty && textEditorFocusState == false, let placeholder {
                        Text(placeholder)
                            .montage(variant: .body1, color: .labelAssistive)
                            .padding(.top, 10)
                            .padding(.leading, 2)
                            .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, 4)
                if bottom {
                    Bottom(
                        typedCharacters: $typedCharacters,
                        variant,
                        disable,
                        leftResource,
                        rightResource
                    )
                }
            }
            .padding(.all, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: textEditorFocusState ? 1 : 0.5)
                    .stroke(editorStrokeColor, lineWidth: textEditorFocusState ? 2 : 1)
            }
            .background(
                disable ? SwiftUI.Color.alias(.interactionDisable) :  SwiftUI.Color.clear
            )
            .allowsHitTesting(disable == false)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onChange(of: focus, perform: { v in
                textEditorFocusState = v
            })
        }
        
        private struct Bottom: View {
            @Binding private var typedCharacters: Int
            
            private let variant: Variant
            private let disable: Bool
            private let leftResource: TextArea.Resource?
            private let rightResource: TextArea.Resource?
            
            init(
                typedCharacters: Binding<Int>,
                _ variant: Variant,
                _ disable: Bool,
                _ leftResource: TextArea.Resource? = nil,
                _ rightResource: TextArea.Resource? = nil
            ) {
                self._typedCharacters = typedCharacters
                self.variant = variant
                self.disable = disable
                self.leftResource = leftResource
                self.rightResource = rightResource
            }

            var body: some View {
                HStack(spacing: 16) {
                    if let leftResource {
                        component(leftResource)
                    }
                    Spacer()
                    if let rightResource {
                        if variant == .normal {
                            if 
                                case .characterCount(_) = leftResource,
                                case .characterCount(_) = rightResource
                            {
                                EmptyView()
                            } else {
                                component(rightResource)
                            }
                        } else {
                            Button.IconButtonController(
                                icon: .circleExclamationFill,
                                iconColorResolver:
                                    disable ? Color.Alias.labelDisable : Color.Alias.statusNegative
                            )
                            .fixedSize()
                        }
                    }
                }
                .padding(.leading, 6)
            }
            
            @ViewBuilder
            func component(_ resource: TextArea.Resource) -> some View {
                switch resource {
                case .characterCount(let limit):
                    HStack(spacing: .zero) {
                        Text("\(typedCharacters)")
                            .montage(variant: .label2, weight: .medium, color: disable ? .labelDisable : .labelAlternative)
                        if limit != .zero {
                            Text("/\(String(limit))")
                                .montage(variant: .label2, weight: .medium, color: disable ? .labelDisable : .labelAssistive)
                        }
                    }
                case .solidButton(let variant, let size, let title, let handler):
                    Button.SolidButtonController(
                        variant: variant,
                        size: size,
                        text: title,
                        handler: handler
                    )
                    .fixedSize()
                case .outlinedButton(let variant, let size, let title, let handler):
                    Button.OutlinedButtonController(
                        variant: variant,
                        size: size,
                        text: title,
                        handler: handler
                    )
                    .fixedSize()
                case .textButton(let variant, let size, let title, let handler):
                    Button.TextButtonController(
                        variant: variant,
                        size: size,
                        text: title,
                        handler: handler
                    )
                    .fixedSize()
                case .iconButton(let variant, let icon, let handler):
                    Button.IconButtonController(
                        variant: variant,
                        icon: icon,
                        handler: handler
                    )
                    .fixedSize()
                case .icon(let icon, let size):
                    Image.montage(icon)
                        .resizable()
                        .frame(width: size, height: size)
                case .actionChip(let variant, let size, let title, let handler):
                    Chip.ActionChipController(
                        variant: variant,
                        size: size,
                        text: title,
                        handler: handler
                    )
                    .fixedSize()
                case .filterChip(let variant, let size, let title, let handler):
                    Chip.FilterChipController(
                        variant: variant,
                        size: size,
                        text: title,
                        handler: handler
                    )
                    .fixedSize()
                }
            }
        }
    }
}

extension TextArea {
    /// TextArea 하단 좌/우측에 사용할 수 있는 컴포넌트입니다.
    /// > characterCount는 좌/우측 중 하나에만 사용 가능합니다. 중복된다면 좌측을 우선 표시합니다.
    public enum Resource {
        /// TextArea에 입력한 있는 글자의 수를 나타내는 컴포넌트 입니다.
        /// > 기본값은 제한이 없습니다.
        case characterCount(limit: Int = .zero)
        case solidButton(
            Button.SolidButton.Variant = .primary,
            size: Button.SolidButton.Size = .medium,
            title: String,
            handler: (() -> Void)? = nil
        )
        case outlinedButton(
            Button.OutlinedButton.Variant = .primary,
            size: Button.OutlinedButton.Size = .medium,
            title: String,
            handler: (() -> Void)? = nil
        )
        case textButton(
            Button.TextButton.Variant = .primary,
            size: Button.TextButton.Size = .medium,
            title: String,
            handler: (() -> Void)? = nil
        )
        case iconButton(
            Button.IconButton.Variant = .default,
            icon: Icon,
            handler: (() -> Void)? = nil
        )
        case icon(Icon, size: CGFloat = 24)
        /* 얘만 switch에서 만들지 못함
        case badge(
            Badge.Content.Variant = .filled,
            size: Badge.Content.Size = .medium,
            title: String
        )
         */
        case actionChip(
            Chip.Action.Variant = .filled,
            size: Chip.Action.Size = .normal,
            title: String,
            handler: (() -> Void)? = nil
        )
        case filterChip(
            Chip.Filter.Variant = .filled,
            size: Chip.Filter.Size = .normal,
            title: String,
            handler: (() -> Void)? = nil
        )
    }
}

struct TextArea_Previews: PreviewProvider {
    static var previews: some View {
        TextArea(
            resize: .normal,
            variant: .normal,
            active: false,
            focus: false,
            disable: true,
            heading: true,
            requiredBadge: true,
            bottom: true,
            description: "?",
            placeholder: "??",
            leftResource: .characterCount(limit: 2000),
            rightResource: .textButton(title: "텍스트", handler: {})
        )
    }
}
