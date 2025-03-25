//
//  TextArea.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/24/24.
//

import SwiftUI

extension TextInput {
    public struct TextArea: View {
        // MARK: - Types
        
        /// TextArea의 텍스트 영역 Resize 관한 열거형입니다.
        /// - normal : 줄 수 제한이 없으며, 줄 수에 따라 영역이 늘어납니다.
        /// - limit : 최대 8줄 노출되며 초과 영역은 Scrollable 합니다.
        /// - fixed: 텍스트가 표시될 영역을 지정합니다. 초과 영역은 Scrollable 합니다.
        public enum Resize {
            case normal
            case limit
            case fixed(min: CGFloat, max: CGFloat)
            
            var minHeight: CGFloat? {
                switch self {
                case .normal: 36.0
                case .limit: 36.0
                case .fixed(let min, _): min
                }
            }
            
            var maxHeight: CGFloat? {
                switch self {
                case .normal: .infinity
                case .limit: 102.0
                case .fixed(_, let max): max
                }
            }
            
            var alignment: Alignment {
                switch self {
                case .normal, .limit: .center
                case .fixed: .topLeading
                }
            }
        }
        
        /// TextArea 하단 좌/우측에 사용할 수 있는 컴포넌트입니다.
        /// > characterCount는 좌/우측 중 하나에만 사용 가능합니다. 중복된다면 좌측을 우선 표시합니다.
        public enum Resource {
            public enum Placement {
                case leading
                case trailing
            }
            
            case characterCount(limit: Int? = nil)
            case textButton(
                placement: Placement = .leading,
                varaint: Button.TextButton.Variant? = .assistive,
                title: String,
                handler: (() -> Void)? = nil
            )
            case iconButton(
                placement: Placement = .leading,
                variant: Button.IconButton.Variant? = .solid(size: .small),
                icon: Icon,
                tintColor: SwiftUI.Color = .semantic(.labelAlternative),
                handler: (() -> Void)? = nil
            )
            case icon(
                Icon,
                tintColor: SwiftUI.Color = .semantic(.labelAssistive)
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
                Badge.ContentUIView.Variant = .solid,
                title: String
            )
            
            var isCharacterCount: Bool {
                if case .characterCount = self {
                    return true
                } else {
                    return false
                }
            }
        }
        
        // MARK: - Initializer
        
        @Binding private var text: String
        private var exposedFocusState: FocusState<Bool>.Binding?
        
        public init(
            text: Binding<String>,
            focus: FocusState<Bool>.Binding? = nil
        ) {
            _text = text
            exposedFocusState = focus
        }
        
        // MARK: - Modifiers
        
        private var resize: Resize = .normal
        private var negative = false
        private var disable = false
        private var heading: String? = nil
        private var requiredBadge = false
        private var description: String? = nil
        private var placeholder: String? = nil
        private var leadingResources: [Resource] = []
        private var trailingResources: [Resource] = []
        private var leadingResourceSpacing: CGFloat = 4
        private var trailingResourceSpacing: CGFloat = 4
        
        /// TextArea의 resize 여부 입니다.
        public func resize(_ resize: Resize) -> Self {
            var zelf = self
            zelf.resize = resize
            return zelf
        }
        
        /// TextArea의 negative 여부를 결정합니다.
        public func negative(_ negative: Bool = true) -> Self {
            var zelf = self
            zelf.negative = negative
            return zelf
        }
        
        /// TextArea의 사용가능 여부입니다.
        public func disable(_ disable: Bool = true) -> Self {
            var zelf = self
            zelf.disable = disable
            return zelf
        }
        
        /// TextArea의 제목입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        public func heading(_ heading: String?) -> Self {
            var zelf = self
            zelf.heading = heading
            return zelf
        }
        
        /// TextArea의 필수 표시 노출 여부입니다.
        public func requiredBadge(_ requiredBadge: Bool = true) -> Self {
            var zelf = self
            zelf.requiredBadge = requiredBadge
            return zelf
        }
        
        /// TextArea 하단 컴포넌트입니다.
        /// > 좌/우 각각 최대 3개까지 사용할 수 있습니다.
        public func bottomResources(
            leading leadingResources: [Resource] = [],
            trailing trailingResources: [Resource] = [],
            leadingResourceSpacing: CGFloat = 4,
            trailingResourceSpacing: CGFloat = 4
        ) -> Self {
            var zelf = self
            zelf.leadingResources = Array(leadingResources.prefix(3))
            zelf.leadingResourceSpacing = leadingResourceSpacing
            
            zelf.trailingResources = Array(trailingResources.prefix(3))
            zelf.trailingResourceSpacing = trailingResourceSpacing
            return zelf
        }
        
        /// TextArea 하단 설명입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        public func description(_ description: String?) -> Self {
            var zelf = self
            zelf.description = description
            return zelf
        }
        
        /// TextArea에 입력된 텍스트가 없을 때 노출되는 placeholder입니다.
        ///  > 값을 지정하지 않으면 노출되지 않습니다.
        public func placeholder(_ placeholder: String?) -> Self {
            var zelf = self
            zelf.placeholder = placeholder
            return zelf
        }
        
        // MARK: - Body
        
        @State private var typedCharacters = 0
        @FocusState private var internalFocusState
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let heading {
                    HStack(spacing: 4) {
                        Text(heading)
                            .montage(variant: .label1, weight: .bold, semantic: .labelNeutral)
                        if requiredBadge {
                            Text("*")
                                .montage(variant: .label1, weight: .medium, semantic: .statusNegative)
                        }
                    }
                }
                
                editor
                
                if let description {
                    Text(description)
                        .montage(
                            variant: .caption1,
                            semantic: negative ? .statusNegative : .labelAlternative
                        )
                }
            }
        }
        
        // MARK: - Private
        
        var editor: some View {
            VStack(spacing: 12) {
                ZStack(alignment: .topLeading) {
                    UITextViewWrapper(text: $text)
                        .frameHeight(
                            minHeight: resize.minHeight,
                            maxHeight: resize.maxHeight
                        )
                        .frame(
                            minHeight: resize.minHeight,
                            maxHeight: resize.maxHeight,
                            alignment: resize.alignment
                        )
                        .foregroundStyle(editorTextColor)
                        .font(.montage(variant: .body1Reading))
                        .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                        .if(!disable) {
                            $0.focused(focus)
                        }
                        .onChange(of: text) { _ in
                            typedCharacters = text.count
                        }
                        .scrollContentBackground(.hidden)
                        .background(disable ? SwiftUI.Color.semantic(.interactionDisable) : .clear)
                        .padding(.horizontal, -4.5)
                        .padding(.top, -4)
                        .padding(.bottom, -6)
                    
                    if $text.wrappedValue.isEmpty, let placeholder {
                        Text(placeholder)
                            .montage(
                                variant: .body1Reading,
                                color: placeholderTextColor
                            )
                            .paragraph(variant: .body1Reading)
                            .background(disable ? SwiftUI.Color.semantic(.interactionDisable) : .clear)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, 4)
                
                if leadingResources.isEmpty == false || trailingResources.isEmpty == false {
                    Bottom(
                        typedCharacters: $typedCharacters,
                        negative,
                        disable,
                        leadingResources,
                        leadingResourceSpacing,
                        trailingResources,
                        trailingResourceSpacing
                    )
                }
            }
            .padding(.all, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(editorStrokeColor, lineWidth: focus.wrappedValue ? 2 : 1)
            }
            .background(
                disable ? SwiftUI.Color.semantic(.interactionDisable) : SwiftUI.Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .allowsHitTesting(disable == false)
        }
        
        private var editorStrokeColor: SwiftUI.Color {
            if negative {
                SwiftUI.Color.semantic(.statusNegative).opacity(0.43)
            } else {
                focus.wrappedValue ? SwiftUI.Color.semantic(.primaryNormal).opacity(0.43) : SwiftUI.Color
                    .semantic(.lineNormal)
            }
        }
        
        private var focus: FocusState<Bool>.Binding {
            exposedFocusState ?? $internalFocusState
        }
        
        private var placeholderTextColor: SwiftUI.Color {
            disable ? .semantic(.labelDisable) : .semantic(.labelAssistive)
        }
        
        private var editorTextColor: SwiftUI.Color {
            disable ? .semantic(.labelAlternative) : .semantic(.labelNormal)
        }
        
        // MARK: - Inner View
        
        private struct Bottom: View {
            @Binding private var typedCharacters: Int
            
            private let negative: Bool
            private let disable: Bool
            private let leadingResources: [Resource]
            private let leadingResourceSpacing: CGFloat
            private let trailingResources: [Resource]
            private let trailingResourceSpacing: CGFloat
            
            init(
                typedCharacters: Binding<Int>,
                _ negative: Bool,
                _ disable: Bool,
                _ leadingResources: [Resource],
                _ leadingResourceSpacing: CGFloat,
                _ trailingResources: [Resource],
                _ trailingResourceSpacing: CGFloat
            ) {
                _typedCharacters = typedCharacters
                self.negative = negative
                self.disable = disable
                self.leadingResources = leadingResources
                self.leadingResourceSpacing = leadingResourceSpacing
                self.trailingResources = trailingResources
                self.trailingResourceSpacing = trailingResourceSpacing
            }
            
            var body: some View {
                HStack {
                    if leadingResources.isEmpty == false {
                        HStack(spacing: leadingResourceSpacing) {
                            ForEach(leadingResources.indices, id: \.self) { index in
                                component(leadingResources[index])
                            }
                        }
                    }
                    Spacer()
                    if negative {
                        Button.IconButton(
                            icon: .circleExclamationFill,
                            iconColor:
                            disable ? .semantic(.labelDisable) : .semantic(.statusNegative)
                        )
                    } else {
                        if trailingResources.isEmpty == false {
                            HStack(spacing: trailingResourceSpacing) {
                                ForEach(filteredTrailingResources.indices, id: \.self) { index in
                                    component(filteredTrailingResources[index])
                                }
                            }
                        }
                    }
                }
            }
            
            var filteredTrailingResources: [Resource] {
                if trailingResources.contains(where: \.isCharacterCount) &&
                    leadingResources.contains(where: \.isCharacterCount) {
                    Array(trailingResources.drop(while: \.isCharacterCount))
                } else {
                    trailingResources
                }
            }
            
            @ViewBuilder
            func component(_ resource: Resource) -> some View {
                switch resource {
                case .characterCount(let limit):
                    let counterString = [typedCharacters, limit]
                        .compactMap { $0 }
                        .map(String.init)
                        .joined(separator: "/")
                    Text(counterString)
                        .montage(
                            variant: .label2,
                            weight: .medium,
                            semantic: disable ? .labelDisable : .labelAlternative
                        )
                        .paragraph(variant: .label2)
                        .padding(.horizontal, 4)
                case let .textButton(placement, variant, title, handler):
                    Button.TextButton(
                        variant: {
                            if let variant {
                                variant
                            } else {
                                switch placement {
                                case .leading: .assistive
                                case .trailing: .primary
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
                                variant
                            } else {
                                switch placement {
                                case .leading: .outlined(size: .medium)
                                case .trailing: .solid(size: .small)
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
                    Chip.Action(
                        variant: variant,
                        size: .small,
                        text: title,
                        handler: handler
                    )
                case let .filterChip(variant, title, handler):
                    Chip.Filter(
                        variant: variant,
                        size: .small,
                        text: title,
                        handler: handler
                    )
                case let .badge(variant, title):
                    Badge.Content(
                        variant: variant,
                        size: .medium,
                        color: .neutral,
                        text: title
                    )
                }
            }
        }
        
        struct UITextViewWrapper: UIViewRepresentable {
            @Binding var text: String
            
            init(
                text: Binding<String>
            ) {
                _text = text
            }
            
            func makeUIView(context: Context) -> UITextView {
                let textView = UITextView()
                textView.font = UIFont.systemFont(ofSize: 16)
                textView.isScrollEnabled = false
                textView.backgroundColor = .clear
                textView.delegate = context.coordinator
                return textView
            }
            
            func updateUIView(_ uiView: UITextView, context: Context) {
                guard uiView.text != text else { return }
                uiView.text = text
            }
            
            func makeCoordinator() -> Coordinator {
                Coordinator(self)
            }
            
            class Coordinator: NSObject, UITextViewDelegate {
                var parent: UITextViewWrapper
                var minHeight: CGFloat?
                var maxHeight: CGFloat?
                private var heightConstraint: NSLayoutConstraint?
                
                init(_ parent: UITextViewWrapper) {
                    self.parent = parent
                }
                
                func textViewDidChange(_ textView: UITextView) {
                    textView.isScrollEnabled = textView.frame.height >= (maxHeight ?? 0)
                    parent.text = textView.text
                }
            }
            
            public func sizeThatFits(
                _ proposal: ProposedViewSize,
                uiView: UIViewType,
                context _: Context
            ) -> CGSize? {
                var newSize = uiView.sizeThatFits(
                    CGSize(width: proposal.width ?? 0, height: CGFloat.greatestFiniteMagnitude)
                )
                newSize.height = min(max(newSize.height, minHeight ?? 0), maxHeight ?? .greatestFiniteMagnitude)
                return CGSize(
                    width: proposal.width ?? 0,
                    height: newSize.height
                )
            }
            
            private var minHeight: CGFloat?
            private var maxHeight: CGFloat?
            
            func frameHeight(minHeight: CGFloat?, maxHeight: CGFloat?) -> Self {
                var zelf = self
                zelf.minHeight = minHeight
                zelf.maxHeight = maxHeight
                return zelf
            }
        }
        
        class CustomTextView: UITextView {
            override var intrinsicContentSize: CGSize {
                sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
            }
        }
    }
}
