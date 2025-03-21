//
//  TextField.swift
//  Montage
//
//  Created by ahn sanghoon on 8/1/24.
//

import SwiftUI

extension TextInput {
    public struct TextField: View {
        // MARK: - Types
        
        /// TextInput의 외관을 결정하는 열거형입니다.
        public enum Status {
            case normal(description: String = "")
            case positive(description: String = "")
            case negative(description: String = "")
        }
        
        /// 오른쪽 버튼의 속성을 가지고 있는 타입입니다.
        public struct TrailingButton {
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
        
        public struct AutoCompletionDataSource: Equatable {
            public static func == (lhs: AutoCompletionDataSource, rhs: AutoCompletionDataSource) -> Bool {
                lhs.id == rhs.id
            }

            private let id = UUID()
            fileprivate let numberOfSections: Int
            fileprivate let sectionTitleAt: ((Int) -> String)?
            fileprivate let numberOfItemsInSection: (Int) -> Int
            fileprivate let cellForItemAt: (IndexPath) -> any View
            fileprivate let headerView: (() -> any View)?
            fileprivate let footerView: (() -> any View)?
            fileprivate let maxHeight: CGFloat
            
            public init(
                numberOfSections: Int = 1,
                sectionTitleAt: ((Int) -> String)? = nil,
                numberOfItemsInSection: @escaping (Int) -> Int,
                cellForItemAt: @escaping (IndexPath) -> any View,
                headerView: (() -> any View)? = nil,
                footerView: (() -> any View)? = nil,
                maxHeight: CGFloat = 400
            ) {
                self.numberOfSections = numberOfSections
                self.sectionTitleAt = sectionTitleAt
                self.numberOfItemsInSection = numberOfItemsInSection
                self.cellForItemAt = cellForItemAt
                self.headerView = headerView
                self.footerView = footerView
                self.maxHeight = maxHeight
            }
            
            public var totalNumberOfItems: Int {
                (0 ..< numberOfSections).map(numberOfItemsInSection).reduce(0, +)
            }
        }
        
        // MARK: - Initializer
        
        @Binding private var text: String
        @Binding private var autoCompletionDataSource: AutoCompletionDataSource?
        
        public init(
            text: Binding<String>,
            autoCompletionDataSource: Binding<AutoCompletionDataSource?> = .constant(
                nil
            )
        ) {
            _text = text
            _autoCompletionDataSource = autoCompletionDataSource
        }
        
        // MARK: - Modifiers
        
        private var status: Status = .normal()
        private var disable = false
        private var heading: String? = nil
        private var requiredBadge = false
        private var description = false
        private var placeholder: String? = nil
        private var icon: Icon? = nil
        private var trailingButton: TrailingButton? = nil
        private var trailingContent: (() -> any View)? = nil
        private var suggestions: Binding<[String]> = .constant([])
        
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
        
        /// 오른쪽에 표시될 버튼의 속성을 지정합니다. `trailingContent`와 함께 사용될 경우 `trailingButton`이 우선순위가 높습니다.
        public func trailingButton(_ trailingButton: TrailingButton?) -> Self {
            var zelf = self
            zelf.trailingButton = trailingButton
            return zelf
        }
        
        /// 오른쪽에 표시될 컨텐츠를 지정합니다. `trailingButton`과 함께 사용하는 경우 `trailingContent`가 무시됩니다.
        public func trailingContent(_ trailingContent: (() -> any View)?) -> Self {
            var zelf = self
            zelf.trailingContent = trailingContent
            return zelf
        }
        
        // MARK: - Body
        
        @Environment(\.safeAreaInsets) private var safeAreaInsets
        @State var textFieldFrame: CGRect = .zero
        @FocusState var textFieldFocusState: Bool
        @State private var autoCompletionContentHeight: CGFloat = .zero
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let heading {
                    HStack(spacing: 4) {
                        Text(heading)
                            .montage(variant: .label1, weight: .bold, semantic: .labelNeutral)
                            .paragraph(variant: .label1)
                        if requiredBadge {
                            Text("*")
                                .montage(variant: .label1, weight: .medium, semantic: .statusNegative)
                        }
                    }
                }
                
                inputField
                
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
    }
}
        
// MARK: - Private

private extension TextInput.TextField {
    var inputField: some View {
        HStack(spacing: -1) {
            ZStack {
                HStack(spacing: 9) {
                    if let icon {
                        Image.montage(icon)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                    }
                    SwiftUI.TextField(
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
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                            .onTapGesture { text = "" }
                    } else {
                        if let trailingIcon, let trailingIconColor {
                            Image
                                .montage(trailingIcon)
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundStyle(trailingIconColor)
                        }
                    }
                    
                    if trailingButton == nil, let trailingContent {
                        AnyView(trailingContent())
                    }
                }
                .padding(.all, 12)
                .overlay {
                    if trailingButton == nil {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(fieldStrokeColor, lineWidth: textFieldFocusState ? 2 : 1)
                    } else {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 12, bottomLeading: 12))
                            .strokeBorder(fieldStrokeColor, lineWidth: textFieldFocusState ? 2 : 1)
                    }
                }
                .onGeometryChange(
                    for: CGRect.self,
                    of: { $0.frame(in: .global) },
                    action: { textFieldFrame = $0 }
                )
            }
            
            if let trailingButton {
                ZStack {
                    TrailingButtonView(
                        variant: trailingButton.variant,
                        title: trailingButton.title,
                        handler: trailingButton.handler
                    )
                    UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 12, topTrailing: 12))
                        .strokeBorder(SwiftUI.Color.semantic(.lineNeutral), lineWidth: 1)
                        .clipShape(
                            Rectangle()
                                .offset(x: 1, y: .zero)
                        )
                        .frame(height: textFieldFrame.height)
                }
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .frame(minHeight: 48)
        .background(disable ? SwiftUI.Color.semantic(.interactionDisable) : .clear)
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .allowsHitTesting(disable == false)
        .overlay {
            autoCompletionContent.opacity(0)
                .onGeometryChange(
                    for: CGFloat.self,
                    of: { $0.size.height },
                    action: { autoCompletionContentHeight = $0 }
                )
        }
        .modifier(
            FloatModifier(
                isPresented: (autoCompletionDataSource?.totalNumberOfItems ?? 0) > 0 && textFieldFocusState,
                updatingValue: Binding(
                    get: { "\(String(describing: autoCompletionDataSource)),\(autoCompletionContentHeight)" },
                    set: { _ in }
                ),
                dismissPolicy: .onTap,
                onDismiss: {
                    textFieldFocusState = false
                    autoCompletionDataSource = nil
                },
                floatView: {
                    SwiftUI.ScrollView {
                        autoCompletionContent
                    }
                    .frame(
                        width: textFieldFrame.width,
                        height: min(autoCompletionContentHeight, autoCompletionDataSource?.maxHeight ?? 0)
                    )
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(SwiftUI.Color.semantic(.lineAlternative))
                    }
                    .background(SwiftUI.Color.semantic(.backgroundNormal))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scrollDisabled(autoCompletionContentHeight <= autoCompletionDataSource?.maxHeight ?? 0)
                    .position(
                        x: textFieldFrame.midX,
                        y: textFieldFrame.maxY - safeAreaInsets.top
                    )
                    .offset(
                        y: 8 + min(autoCompletionContentHeight, autoCompletionDataSource?.maxHeight ?? 0) / 2
                    )
                }
            )
        )
    }
    
    var captionTextColor: SwiftUI.Color {
        switch status {
        case .negative:
            .semantic(.statusNegative)
        default:
            .semantic(.labelAlternative)
        }
    }
    
    var autoCompletionContent: some View {
        Group {
            if let autoCompletionDataSource {
                VStack(alignment: .leading, spacing: 4) {
                    if let headerView = autoCompletionDataSource.headerView,
                       autoCompletionDataSource.totalNumberOfItems > 0 {
                        AnyView(headerView())
                    }
                    LazyVStack(alignment: .leading, spacing: 4, pinnedViews: [.sectionHeaders]) {
                        ForEach(0 ..< autoCompletionDataSource.numberOfSections, id: \.self) { section in
                            Group {
                                let itemCount = autoCompletionDataSource.numberOfItemsInSection(section)
                                if itemCount > 0 {
                                    let header: some View = Group {
                                        if let title = autoCompletionDataSource.sectionTitleAt?(section) {
                                            HStack {
                                                Text(title)
                                                    .montage(
                                                        variant: .caption1,
                                                        weight: .bold,
                                                        color: .semantic(.labelAlternative)
                                                    )
                                                    .paragraph(variant: .caption1)
                                                Spacer()
                                            }
                                            .padding(.horizontal, 1)
                                            .padding(.vertical, 4)
                                            .background(SwiftUI.Color.semantic(.backgroundElevated))
                                        }
                                    }
                                    Section(header: header) {
                                        VStack(spacing: 4) {
                                            ForEach(0 ..< itemCount, id: \.self) { item in
                                                let indexPath = IndexPath(item: item, section: section)
                                                AnyView(autoCompletionDataSource.cellForItemAt(indexPath))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let footerView = autoCompletionDataSource.footerView,
                       autoCompletionDataSource.totalNumberOfItems > 0 {
                        AnyView(footerView())
                    }
                }
                .padding(.horizontal, autoCompletionDataSource.totalNumberOfItems == 0 ? 0 : 20)
                .padding(.vertical, autoCompletionDataSource.totalNumberOfItems == 0 ? 0 : 8)
            }
        }
    }
    
    var fieldStrokeColor: SwiftUI.Color {
        if textFieldFocusState {
            switch status {
            case .normal, .positive:
                .semantic(.primaryNormal).opacity(0.43)
            case .negative:
                .semantic(.statusNegative).opacity(0.43)
            }
        } else {
            switch status {
            case .normal, .positive:
                .semantic(.lineNeutral)
            case .negative:
                .semantic(.statusNegative).opacity(0.43)
            }
        }
    }
    
    var trailingIcon: Icon? {
        switch status {
        case .positive:
            .circleCheckFill
        case .negative:
            .circleExclamationFill
        default:
            nil
        }
    }
    
    var trailingIconColor: SwiftUI.Color? {
        switch status {
        case .positive:
            .semantic(.primaryNormal)
        case .negative:
            .semantic(.statusNegative)
        default:
            nil
        }
    }
    
    var placeholderTextColor: SwiftUI.Color {
        disable ? .semantic(.labelDisable) : .semantic(.labelAssistive)
    }
    
    var fieldTextColor: SwiftUI.Color {
        disable ? .semantic(.labelAlternative) : .semantic(.labelNormal)
    }
}

// MARK: - Inner Views
private extension TextInput.TextField {
    struct TrailingButtonView: View {
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
                .montage(variant: .body1, weight: variant.typoWeight, semantic: variant.textColor)
                .paragraph(variant: .body1)
                .background(
                    Decorate.Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .labelNormal
                    )
                    .padding(.horizontal, -7)
                    .padding(.vertical, -4)
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isPressed = value.translation == .zero
                        }
                        .onEnded { _ in
                            isPressed = false
                        }
                )
                .onTapGesture {
                    handler?()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SwiftUI.Color.clear)
                }
                .padding(.horizontal, 19)
                .padding(.vertical, 12)
        }
    }
}
