//
//  TextArea.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/24/24.
//

import SwiftUI

public struct TextArea: View {
    // MARK: - Environment
    
    /// TextArea의 텍스트 영역 Resize 관한 열거형입니다.
    /// - normal : 줄 수 제한이 없으며, 줄 수에 따라 영역이 늘어납니다.
    /// - limit : 최대 8줄 노출되며 초과 영역은 Scrollable 합니다.
    /// - fixed: 텍스트가 표시될 영역을 지정합니다. 초과 영역은 Scrollable 합니다.
    /// > iOS 15에서는 normal 인 경우에도 영역이 늘어나지 않는 현상이 있으니 사용시 주의하시기 바랍니다.
    public enum Resize {
        case normal
        case limit
        case fixed(min: CGFloat, max: CGFloat)
    }
    
    /// TextArea의 외관을 결정하는 열거형입니다.
    public enum Variant {
        case normal
        case negative
    }
    
    // MARK: - Local state
    
    @Binding private var text: String
    
    // MARK: - Uninitialised properties
    
    /// TextArea의 resize 여부 입니다.
    public let resize: Resize
    
    /// TextArea의 외관입니다.
    public let variant: Variant
    
    /// TextArea의 포커싱 여부입니다.
    public let focus: Bool
    
    /// TextArea의 사용가능 여부입니다.
    public let disable: Bool
    
    /// TextArea의 제목입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    public let heading: String?
    
    /// TextArea의 필수 표시 노출 여부입니다.
    public let requiredBadge: Bool
    
    /// TextArea의 하단 영역 노출 여부입니다.
    /// - 하단 영역 : 글자수 / 제한 글자수 / 버튼
    public let bottom: Bool
    
    /// TextArea 하단 설명입니다.
    /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
    public let description: String?
    
    /// TextArea에 입력된 텍스트가 없을 때 노출되는 placeholder입니다.
    ///  > 값을 지정하지 않으면 노출되지 않습니다.
    public let placeholder: String?
    
    /// TextArea 하단 좌측의 컴포넌트입니다.
    /// > 최대 3개까지 사용할 수 있습니다.
    public let leftResource: [Resource]
    
    /// TextArea 하단 좌측의 컴포넌트들의 여백입니다.
    /// > 기본값은 24입니다.
    public let leftResourceSpacing: CGFloat
    
    /// TextArea 하단 우측의 컴포넌트입니다.
    /// > 최대 3개까지 사용할 수 있습니다.
    public let rightResource: [Resource]
    
    /// TextArea 하단 우측의 컴포넌트들의 여백입니다.
    /// > 기본값은 24입니다.
    public let rightResourceSpacing: CGFloat
    
    public init(
        text: Binding<String>,
        resize: Resize = .normal,
        variant: Variant = .normal,
        focus: Bool = false,
        disable: Bool = false,
        heading: String? = nil,
        requiredBadge: Bool = false,
        bottom: Bool = false,
        description: String? = nil,
        placeholder: String? = nil,
        leftResource: [Resource] = [],
        leftResourceSpacing: CGFloat = 24,
        rightResource: [Resource] = [],
        rightResourceSpacing: CGFloat = 24
    ) {
        self._text = text
        self.resize = resize
        self.variant = variant
        self.focus = focus
        self.disable = disable
        self.heading = heading
        self.requiredBadge = requiredBadge
        self.bottom = bottom
        self.description = description
        self.placeholder = placeholder
        self.leftResource = Array(leftResource.prefix(3))
        self.leftResourceSpacing = leftResourceSpacing
        self.rightResource = Array(rightResource.prefix(3))
        self.rightResourceSpacing = rightResourceSpacing
    }
    
    // MARK: - Computed properties
    // MARK: - Initialisers
    // MARK: - Helper functions
    // MARK: - ViewModifier properties
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let heading {
                HStack(spacing: 4) {
                    Text(heading)
                        .montage(variant: .label1, weight: .bold, alias: .labelNeutral)
                    if requiredBadge {
                        Text("*")
                            .montage(variant: .label1, weight: .medium, alias: .statusNegative)
                    }
                }
            }
            Editor(
                $text,
                resize,
                variant,
                focus,
                disable,
                placeholder,
                bottom,
                leftResource,
                leftResourceSpacing,
                rightResource,
                rightResourceSpacing
            )
            if let description {
                Text(description)
                    .montage(
                        variant: .caption1,
                        alias: variant == .normal ? .labelAlternative : .statusNegative
                    )
            }
        }
    }
    
    private struct Editor: View {
        @FocusState private var textEditorFocusState: Bool
        @Binding private var text: String
        @State private var typedCharacters: Int = 0

        private let resize: Resize
        private let variant: Variant
        private let focus: Bool
        private let disable: Bool
        private let placeholder: String?
        private let bottom: Bool
        private let leftResource: [TextArea.Resource]
        private let leftResourceSpacing: CGFloat
        private let rightResource: [TextArea.Resource]
        private let rightResourceSpacing: CGFloat
        
        init(
            _ text: Binding<String>,
            _ resize: Resize,
            _ variant: Variant,
            _ focus: Bool,
            _ disable: Bool,
            _ placeholder: String?,
            _ bottom: Bool,
            _ leftResource: [TextArea.Resource],
            _ leftResourceSpacing: CGFloat,
            _ rightResource: [TextArea.Resource],
            _ rightResourceSpacing: CGFloat
        ) {
            self._text = text
            self.resize = resize
            self.variant = variant
            self.focus = focus
            self.disable = disable
            self.placeholder = placeholder
            self.bottom = bottom
            self.leftResource = leftResource
            self.leftResourceSpacing = leftResourceSpacing
            self.rightResource = rightResource
            self.rightResourceSpacing = rightResourceSpacing
        }

        private var editorStrokeColor: SwiftUI.Color {
            if variant == .negative {
                return SwiftUI.Color.alias(.statusNegative).opacity(0.43)
            } else {
                return textEditorFocusState ? SwiftUI.Color.alias(.primaryNormal).opacity(0.43) : SwiftUI.Color.alias(.lineNormal)
            }
        }
        
        private var placeholderTextColor: SwiftUI.Color {
            disable ? .alias(.labelDisable) : .alias(.labelAssistive)
        }
        
        private var editorTextColor: SwiftUI.Color {
            disable ? .alias(.labelAlternative) : .alias(.labelNormal)
        }
        
        var body: some View {
            VStack(spacing: 12) {
                ZStack(alignment: .topLeading) {
                    switch resize {
                    case .normal:
                        if #available(iOS 16, *) {
                            TextEditor(text: $text)
                                .foregroundStyle(editorTextColor)
                                .font(.montage(variant: .body1Reading))
                                .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .scrollContentBackground(.hidden)
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                                .padding([.horizontal], -4.5)
                                .padding(.top, -4)
                                .padding(.bottom, -6)
                        } else {
                            TextEditor(text: $text)
                                .foregroundStyle(editorTextColor)
                                .font(.montage(variant: .body1Reading))
                                .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
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
                                .padding([.horizontal], -4.5)
                                .padding(.top, -4)
                                .padding(.bottom, -6)
                        }
                    case .limit:
                        if #available(iOS 16, *) {
                            TextEditor(text: $text)
                                .font(.montage(variant: .body1Reading))
                                .foregroundStyle(editorTextColor)
                                .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36, maxHeight: 320)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .scrollContentBackground(.hidden)
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                                .padding([.horizontal], -4.5)
                                .padding(.top, -4)
                                .padding(.bottom, -6)
                        } else {
                            TextEditor(text: $text)
                                .foregroundStyle(editorTextColor)
                                .font(.montage(variant: .body1Reading))
                                .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: 36, maxHeight: 320)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .onAppear {
                                    UITextView.appearance().backgroundColor = .clear
                                }
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                                .padding([.horizontal], -4.5)
                                .padding(.top, -4)
                                .padding(.bottom, -6)
                        }
                    case let .fixed(minimum, maximum):
                        let min = min(minimum, maximum)
                        let max = max(minimum, maximum)
                        if #available(iOS 16, *) {
                            TextEditor(text: $text)
                                .foregroundStyle(editorTextColor)
                                .font(.montage(variant: .body1Reading))
                                .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: min, maxHeight: max, alignment: .topLeading)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .scrollContentBackground(.hidden)
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                                .padding([.horizontal], -4.5)
                                .padding(.top, -4)
                                .padding(.bottom, -6)
                        } else {
                            TextEditor(text: $text)
                                .foregroundStyle(editorTextColor)
                                .font(.montage(variant: .body1Reading))
                                .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                                .focused($textEditorFocusState)
                                .frame(minHeight: min, maxHeight: max, alignment: .topLeading)
                                .fixedSize(horizontal: false, vertical: true)
                                .onChange(of: text) { result in
                                    typedCharacters = text.count
                                }
                                .onAppear {
                                    UITextView.appearance().backgroundColor = .clear
                                }
                                .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                                .padding([.horizontal], -4.5)
                                .padding(.top, -4)
                                .padding(.bottom, -6)
                        }
                    }
                    if $text.wrappedValue.isEmpty, let placeholder {
                        Text(placeholder)
                            .montage(
                                variant: .body1Reading,
                                color: placeholderTextColor
                            )
                            .paragraph(variant: .body1Reading)
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
                        leftResourceSpacing,
                        rightResource,
                        rightResourceSpacing
                    )
                }
            }
            .padding(.all, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
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
            private let leftResources: [TextArea.Resource]
            private let leftResourceSpacing: CGFloat
            private let rightResources: [TextArea.Resource]
            private let rightResourceSpacing: CGFloat
            
            init(
                typedCharacters: Binding<Int>,
                _ variant: Variant,
                _ disable: Bool,
                _ leftResources: [TextArea.Resource],
                _ leftResourceSpacing: CGFloat,
                _ rightResources: [TextArea.Resource],
                _ rightResourceSpacing: CGFloat
            ) {
                self._typedCharacters = typedCharacters
                self.variant = variant
                self.disable = disable
                self.leftResources = leftResources
                self.leftResourceSpacing = leftResourceSpacing
                self.rightResources = rightResources
                self.rightResourceSpacing = rightResourceSpacing
            }

            var body: some View {
                HStack {
                    if leftResources.isEmpty == false {
                        HStack(spacing: leftResourceSpacing) {
                            ForEach(leftResources.indices, id: \.self) { index in
                                component(leftResources[index])
                            }
                        }
                    }
                    Spacer()
                    if rightResources.isEmpty == false {
                        HStack(spacing: rightResourceSpacing) {
                            ForEach(rightResources.indices, id: \.self) { index in
                                if variant == .normal {
                                    let rightResource = rightResources[index]
                                    if
                                        leftResources.contains(where: { leftResource in
                                            if case .characterCount(_) = leftResource {
                                                return true
                                            } else {
                                                return false
                                            }
                                        }),
                                        case .characterCount(_) = rightResource
                                    {
                                        EmptyView()
                                    } else {
                                        component(rightResource)
                                    }
                                } else {
                                    Button.IconButton(
                                        icon: .circleExclamationFill,
                                        iconColor:
                                            disable ? .alias(.labelDisable) : .alias(.statusNegative)
                                    )
                                }
                            }
                        }
                    }
                }
            }

            @ViewBuilder
            func component(_ resource: TextArea.Resource) -> some View {
                switch resource {
                case .characterCount(let limit):
                    HStack(spacing: .zero) {
                        Text("\(typedCharacters)")
                            .montage(variant: .label2, weight: .medium, alias: disable ? .labelDisable : .labelAlternative)
                            .paragraph(variant: .label2)
                        if limit != .zero {
                            Text("/\(String(limit))")
                                .montage(variant: .label2, weight: .medium, alias: disable ? .labelDisable : .labelAssistive)
                                .paragraph(variant: .label2)
                        }
                    }
                    .padding(.horizontal, 4)
                case let .textButton(placement, variant, title, handler):
                    Button.TextButton(
                        variant: {
                            if let variant {
                                return variant
                            } else {
                                switch placement {
                                case .left: return .assistive
                                case .right: return .primary
                                }
                            }
                        }(),
                        size: .medium,
                        text: title,
                        handler: handler
                    )
                    .frame(maxHeight: 24)
                    .padding(.horizontal, 4)
                case let .iconButton(placement, variant, icon, tintColor, handler):
                    Button.IconButton(
                        variant: {
                            if let variant {
                                return variant
                            } else {
                                switch placement {
                                case .left: return .outlined(size: .normal)
                                case .right: return .solid(size: .small)
                                }
                            }
                        }(),
                        icon: icon,
                        iconColor: tintColor,
                        handler: handler
                    )
                case let .icon(icon, tintColor):
                    Image.montage(icon)
                        .resizable()
                        .foregroundColor(tintColor)
                        .frame(width: 22, height: 22)
                case let .actionChip(variant, title, handler):
                    Chip.ActionChipController(
                        variant: variant,
                        size: .small,
                        text: title,
                        handler: handler
                    )
                case let .filterChip(variant, title, handler):
                    Chip.FilterChipController(
                        variant: variant,
                        size: .small,
                        text: title,
                        handler: handler
                    )
                case let .badge(variant, title):
                    Badge.ContentBadgeController(
                        variant: variant,
                        size: .large,
                        color: .neutral,
                        text: title
                    )
                }
            }
        }
    }
}

extension TextArea {
    /// TextArea 하단 좌/측에 사용할 수 있는 컴포넌트입니다.
    /// > characterCount는 좌/우측 중 하나에만 사용 가능합니다. 중복된다면 좌측을 우선 표시합니다.
    public enum Resource {
        public enum Placement {
            case left
            case right
        }
        
        case characterCount(limit: Int = .zero)
        case textButton(
            placement: Placement = .left,
            varaint: Button.TextButton.Variant? = .assistive,
            title: String,
            handler: (() -> Void)? = nil
        )
        case iconButton(
            placement: Placement = .left,
            variant: Button.IconButton.Variant? = .solid(size: .small),
            icon: Icon,
            tintColor: SwiftUI.Color = .alias(.labelAlternative),
            handler: (() -> Void)? = nil
        )
        case icon(
            Icon,
            tintColor: SwiftUI.Color = .alias(.labelAssistive)
        )
        case actionChip(
            Chip.Action.Variant = .solid,
            title: String,
            handler: (() -> Void)? = nil
        )
        case filterChip(
            Chip.Filter.Variant = .solid,
            title: String,
            handler: (() -> Void)? = nil
        )
        case badge(
            Badge.Content.Variant = .solid,
            title: String
        )
    }
}

struct TextArea_Previews: PreviewProvider {
    static var previews: some View {
        TextArea(
            text: .constant(""),
            resize: .normal,
            variant: .normal,
            focus: false,
            disable: false,
            heading: "주제",
            requiredBadge: true,
            bottom: true,
            description: "메세지에 마침표를 찍어요.",
            placeholder: "텍스트를 입력해 주세요.",
            leftResource: [.badge(title: "텍스트")],
            rightResource: [.textButton(title: "텍스트", handler: {})]
        )
    }
}
