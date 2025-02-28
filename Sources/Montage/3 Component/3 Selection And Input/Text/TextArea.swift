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
                case .normal: nil
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
                case left
                case right
            }
            
            case characterCount(limit: Int? = nil)
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
                Badge.ContentUIView.Variant = .solid,
                title: String
            )
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
        private var bottom = false
        private var description: String? = nil
        private var placeholder: String? = nil
        private var leftResource: [Resource] = []
        private var leftResourceSpacing: CGFloat = 24
        private var rightResource: [Resource] = []
        private var rightResourceSpacing: CGFloat = 2
        
        /// TextArea의 resize 여부 입니다.
        public func resize(_ resize: Resize) -> Self {
            var zelf = self
            zelf.resize = resize
            return zelf
        }
        
        /// TextArea의 negative 여부를 결정합니다.
        public func negative(_ negative: Bool) -> Self {
            var zelf = self
            zelf.negative = negative
            return zelf
        }
        
        /// TextArea의 사용가능 여부입니다.
        public func disable(_ disable: Bool) -> Self {
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
        public func requiredBadge(_ requiredBadge: Bool) -> Self {
            var zelf = self
            zelf.requiredBadge = requiredBadge
            return zelf
        }
        
        /// TextArea의 하단 영역 노출 여부입니다.
        /// - 하단 영역 : 글자수 / 제한 글자수 / 버튼
        public func bottom(_ bottom: Bool) -> Self {
            var zelf = self
            zelf.bottom = bottom
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
        
        /// TextArea 하단 좌측의 컴포넌트입니다.
        /// > 최대 3개까지 사용할 수 있습니다.
        public func leftResource(_ leftResource: [Resource], spacing _: CGFloat = 24) -> Self {
            var zelf = self
            zelf.leftResource = Array(leftResource.prefix(3))
            zelf.leftResourceSpacing = leftResourceSpacing
            return zelf
        }
        
        /// TextArea 하단 우측의 컴포넌트입니다.
        /// > 최대 3개까지 사용할 수 있습니다.
        public func rightResource(_ rightResource: [Resource], spacing _: CGFloat = 24) -> Self {
            var zelf = self
            zelf.rightResource = Array(rightResource.prefix(3))
            zelf.rightResourceSpacing = rightResourceSpacing
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
                            .montage(variant: .label1, weight: .bold, alias: .labelNeutral)
                        if requiredBadge {
                            Text("*")
                                .montage(variant: .label1, weight: .medium, alias: .statusNegative)
                        }
                    }
                }
                
                editor
                
                if let description {
                    Text(description)
                        .montage(
                            variant: .caption1,
                            alias: negative ? .statusNegative : .labelAlternative
                        )
                }
            }
        }
        
        // MARK: - Private
        
        var editor: some View {
            VStack(spacing: 12) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .foregroundStyle(editorTextColor)
                        .font(.montage(variant: .body1Reading))
                        .lineSpacing(Typography.Variant.body1Reading.lineSpacing)
                        .if(!disable) {
                            $0.focused(focus)
                        }
                        .frame(
                            minHeight: resize.minHeight,
                            maxHeight: resize.maxHeight,
                            alignment: resize.alignment
                        )
                        .fixedSize(horizontal: false, vertical: true)
                        .onChange(of: text) { _ in
                            typedCharacters = text.count
                        }
                        .scrollContentBackground(.hidden)
                        .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                        .padding(.horizontal, -4.5)
                        .padding(.top, -4)
                        .padding(.bottom, -6)
                    
                    if $text.wrappedValue.isEmpty, let placeholder {
                        Text(placeholder)
                            .montage(
                                variant: .body1Reading,
                                color: placeholderTextColor
                            )
                            .lineLimit(1)
                            .paragraph(variant: .body1Reading)
                            .background(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, 4)
                
                if bottom {
                    Bottom(
                        typedCharacters: $typedCharacters,
                        negative,
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
                    .strokeBorder(editorStrokeColor, lineWidth: focus.wrappedValue ? 2 : 1)
            }
            .background(
                disable ? SwiftUI.Color.alias(.interactionDisable) : SwiftUI.Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .allowsHitTesting(disable == false)
        }
        
        private var editorStrokeColor: SwiftUI.Color {
            if negative {
                SwiftUI.Color.alias(.statusNegative).opacity(0.43)
            } else {
                focus.wrappedValue ? SwiftUI.Color.alias(.primaryNormal).opacity(0.43) : SwiftUI.Color
                    .alias(.lineNormal)
            }
        }
        
        private var focus: FocusState<Bool>.Binding {
            exposedFocusState ?? $internalFocusState
        }
        
        private var placeholderTextColor: SwiftUI.Color {
            disable ? .alias(.labelDisable) : .alias(.labelAssistive)
        }
        
        private var editorTextColor: SwiftUI.Color {
            disable ? .alias(.labelAlternative) : .alias(.labelNormal)
        }
        
        // MARK: - Inner View
        
        private struct Bottom: View {
            @Binding private var typedCharacters: Int
            
            private let negative: Bool
            private let disable: Bool
            private let leftResources: [Resource]
            private let leftResourceSpacing: CGFloat
            private let rightResources: [Resource]
            private let rightResourceSpacing: CGFloat
            
            init(
                typedCharacters: Binding<Int>,
                _ negative: Bool,
                _ disable: Bool,
                _ leftResources: [Resource],
                _ leftResourceSpacing: CGFloat,
                _ rightResources: [Resource],
                _ rightResourceSpacing: CGFloat
            ) {
                _typedCharacters = typedCharacters
                self.negative = negative
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
                                if negative {
                                    Button.IconButton(
                                        icon: .circleExclamationFill,
                                        iconColor:
                                        disable ? .alias(.labelDisable) : .alias(.statusNegative)
                                    )
                                } else {
                                    let rightResource = rightResources[index]
                                    if
                                        leftResources.contains(where: { leftResource in
                                            if case .characterCount(_) = leftResource {
                                                true
                                            } else {
                                                false
                                            }
                                        }),
                                        case .characterCount(_) = rightResource {
                                        EmptyView()
                                    } else {
                                        component(rightResource)
                                    }
                                }
                            }
                        }
                    }
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
                            alias: disable ? .labelDisable : .labelAlternative
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
                                case .left: .assistive
                                case .right: .primary
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
                                case .left: .outlined(size: .normal)
                                case .right: .solid(size: .small)
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
                        size: .large,
                        color: .neutral,
                        text: title
                    )
                }
            }
        }
    }
}
