//
//  Select.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/13/24.
//

import SwiftUI

public struct Select: View {
    // MARK: - Types
    
    /// 다중 선택 가능여부를 나타내는 열거형입니다.
    public enum Variant {
        case single(selectionType: SingleSelectionType = .radio)
        case multiple(render: Render = .text, overflow: Bool = false)
        
        var isSingle: Bool {
            switch self {
            case .single:
                return true
            case .multiple:
                return false
            }
        }
    }
    
    /// 아이템 타입입니다.
    public struct Item: Equatable {
        public let text: String
        public let icon: Icon?
        public let isNegative: Bool
        public var isSelected: Bool
        
        public init(
            text: String,
            icon: Icon? = nil,
            isNegative: Bool = false,
            isSelected: Bool = false
        ) {
            self.text = text
            self.icon = icon
            self.isNegative = isNegative
            self.isSelected = isSelected
        }
    }
    
    /// variant가 single일 때 아이템 선택 창에 아이템이 표시되는 방식을 결정하는 열거형입니다.
    public enum SingleSelectionType: String, CaseIterable {
        case checkmark, radio
    }
    
    /// variant가 multiple일 때 컴포넌트에 표시될 내용의 형태를 결정하는 열거형입니다.
    public enum Render: String, CaseIterable {
        case text
        case chip
    }
    
    private var customMenuPresented: Binding<Bool>?
    private let variant: Variant
    @Binding private var items: [Item]
    private let onTapItem: ((Select.Item) -> Void)?
    
    public init(
        menuPresented: Binding<Bool>? = nil,
        variant: Variant,
        items: Binding<[Item]>,
        onTapItem: ((Select.Item) -> Void)? = nil
    ) {
        self.customMenuPresented = menuPresented
        self.variant = variant
        self._items = items
        self.onTapItem = onTapItem
    }
    
    // MARK: - Body
    @State private var contentSize: CGSize = .zero
    @State private var defaultMenuPresented: Bool = false
    private var menuPresented: Binding<Bool> {
        customMenuPresented ?? $defaultMenuPresented
    }
    @State private var menuSize: CGSize = .zero
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !heading.isEmpty {
                HStack(spacing: 4) {
                    Text(heading)
                        .montage(
                            variant: .label1,
                            weight: .bold,
                            alias: .labelNormal
                        )
                    if requiredBadge {
                        Text("*")
                            .montage(
                                variant: .label1,
                                weight: .medium,
                                alias: .statusNegative
                            )
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(shadowBackgroundColor)
                    .shadow(
                        color: .alias(.staticBlack).opacity(0.03),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
                    .frame(
                        width: contentSize.width,
                        height: contentSize.height
                    )
                
                HStack(spacing: 8) {
                    AnyView(leftContent())
                    
                    ZStack {
                        HStack {
                            if selectedItems.isEmpty {
                                Text(placeholder)
                                    .montage(
                                        variant: .body1,
                                        weight: .regular,
                                        color: placeholderTextColor
                                    )
                                    .paragraph(variant: .body1)
                            } else {
                                switch variant {
                                case .single:
                                    if let text = selectedItems.first?.text {
                                        Text(text)
                                            .montage(
                                                variant: .body1,
                                                weight: .regular,
                                                color: textColor
                                            )
                                            .paragraph(variant: .body1)
                                    }
                                case .multiple(let render, let overflow):
                                    Group {
                                        if render == .text {
                                            Text(selectedItems.map { $0.text }.joined(separator: ", "))
                                                .montage(
                                                    variant: .body1,
                                                    weight: .regular,
                                                    color: textColor
                                                )
                                                .paragraph(variant: .body1)
                                                .if(!overflow) {
                                                    $0.lineLimit(1)
                                                }
                                        } else {
                                            let chips = Chips(
                                                items: selectedItems,
                                                disable: disable,
                                                onTapItem: { index in
                                                    items[index].isSelected.toggle()
                                                }
                                            )
                                            if overflow {
                                                FlowLayout {
                                                    chips
                                                }
                                            } else {
                                                HStack {
                                                    chips
                                                }
                                                .modifier(GradientScrollEdgeModifier(gradientWidth: 40))
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(minHeight: 24)
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                    }
                    
                    if !selectedItems.isEmpty, negative {
                        Image.montage(.circleExclamationFill)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(SwiftUI.Color.alias(.statusNegative))
                    }
                    
                    Button.IconButton(
                        variant: .normal(size: 16),
                        icon: .chevronDownThickSmall,
                        iconColor: disable ? SwiftUI.Color
                            .alias(.labelDisable) : .alias(.labelAlternative)
                    ) {
                        menuPresented.wrappedValue.toggle()
                    }
                    .padding(.horizontal, 4)
                }
                .padding(.all, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(strokeColor, lineWidth: menuPresented.wrappedValue ? 2 : 1)
                }
                .shadow(
                    color: .alias(.staticBlack).opacity(0.03),
                    radius: 2,
                    x: 0,
                    y: 1
                )
            }
            
            if !description.isEmpty {
                Text(description)
                    .montage(
                        variant: .caption1,
                        weight: .regular,
                        alias: .labelAlternative
                    )
            }
        }
        .allowsHitTesting(disable == false)
        .onTapGesture {
            menuPresented.wrappedValue.toggle()
        }
        .if(customMenuPresented == nil) {
            $0.sheet(isPresented: $defaultMenuPresented) {
                Modal.Bottom {
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(items.indices, id: \.self) { index in
                                Group {
                                    let cell = Cell(title: items[index].text) {
                                        switch variant {
                                        case .single:
                                            deselectAll()
                                            fallthrough
                                        case .multiple:
                                            items[index].isSelected.toggle()
                                        }
                                    }
                                    
                                    switch variant {
                                    case .single(let selectionType):
                                        switch selectionType {
                                        case .checkmark:
                                            cell.active(items[index].isSelected)
                                                .rightContent { active in
                                                    Control.Check(state: active)
                                                }
                                        case .radio:
                                            cell.leftContent {
                                                Control.Radio(state: items[index].isSelected)
                                            }
                                        }
                                    case .multiple:
                                        cell.leftContent {
                                            Control.Checkbox(state: items[index].isSelected)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 480)
                } actionArea: {
                    .init(
                        model: .init(
                            priority: .neutral(
                                main: .init(text: "완료", action: {
                                    defaultMenuPresented.toggle()
                                }),
                                sub: .init(custom: {
                                    Button.OutlinedButton(variant: .assistive, size: .large, leftIcon: .refresh, iconOnly: true) {
                                        deselectAll()
                                    }
                                })
                            )
                        )
                    )
                }
                .resize(.hug)
            }
        }
    }
    
    // MARK: - Modifiers
    
    private var negative: Bool = false
    private var render: Render = .text
    private var placeholder: String = ""
    private var disable: Bool = false
    private var heading: String = ""
    private var requiredBadge: Bool = false
    private var description: String = ""
    private var shadowBackgroundColor: SwiftUI.Color = .init(uiColor: UIColor.systemBackground)
    private var leftContent: () -> any View = { EmptyView() }
    
    /// negative 상태 여부를 조정합니다.
    public func negative(_ negative: Bool = true) -> Self {
        var zelf = self
        zelf.negative = negative
        return zelf
    }
    
    /// 선택된 항목들이 없는 경우 placeholder를 표시합니다.
    public func placeholder(_ placeholder: String) -> Self {
        var zelf = self
        zelf.placeholder = placeholder
        return zelf
    }
    
    /// 활성화 여부를 조정합니다.
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 제목을 추가합니다.
    public func heading(_ heading: String) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    /// 필수 표시 노출 여부를 조정합니다.
    public func requiredBadge(_ requiredBadge: Bool = true) -> Self {
        var zelf = self
        zelf.requiredBadge = requiredBadge
        return zelf
    }
    
    /// 설명을 추가합니다.
    public func description(_ description: String) -> Self {
        var zelf = self
        zelf.description = description
        return zelf
    }
    
    /// shadow 배경색을 조정합니다. 기본값은 systemBackgroundColor 입니다.
    public func shadowBackgroundColor(_ shadowBackgroundColor: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.shadowBackgroundColor = shadowBackgroundColor
        return zelf
    }
    
    /// 왼쪽 컨텐츠를 추가합니다.
    public func leftContent(_ content: @escaping () -> any View) -> Self {
        var zelf = self
        zelf.leftContent = content
        return zelf
    }
    
    // MARK: - Private
    
    private var selectedItems: [Item] {
        items.filter(\.isSelected)
    }
    
    private func deselectAll() {
        items = items.map {
            var mutated = $0
            mutated.isSelected = false
            return mutated
        }
    }
    
    private var strokeColor: SwiftUI.Color {
        if disable {
            .alias(.lineNeutral)
        } else {
            if negative {
                .alias(.statusNegative).opacity(0.28)
            } else {
                menuPresented.wrappedValue ? .alias(.primaryNormal).opacity(0.43) : .alias(.lineNeutral)
            }
        }
    }
    
    private var placeholderTextColor: SwiftUI.Color {
        disable ? .alias(.labelDisable) : .alias(.labelAssistive)
    }
    
    private var textColor: SwiftUI.Color {
        disable ? .alias(.labelAlternative) : .alias(.labelNormal)
    }
    
    // MARK: - Inner View
    
    private struct Chips: View {
        var items: [Select.Item]
        var disable: Bool
        var onTapItem: ((Int) -> Void)?
        
        var body: some View {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                Montage.Chip.Action(
                    variant: .solid,
                    size: .xsmall,
                    text: item.text,
                    backgroundColor: backgroundColor(item),
                    fontColor: fontColor(item)
                )
                .imageColor(iconColor(item))
                .rightImage(Image.montage(.closeThick))
                .if(item.icon != nil) {
                    $0.leftImage(Image.montage(item.icon!))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapItem?(index)
                }
            }
        }
        
        private func iconColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .alias(.labelDisable) }
            if item.isNegative {
                return .alias(.statusNegative)
            } else {
                return .alias(.labelAlternative)
            }
        }
        
        private func backgroundColor(_ item: Select.Item) -> SwiftUI.Color? {
            guard disable == false else { return nil }
            if item.isNegative {
                return .alias(.statusNegative).opacity(0.05)
            } else {
                return nil
            }
        }
        
        private func fontColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .alias(.labelDisable) }
            if item.isNegative {
                return .alias(.statusNegative)
            } else {
                return .alias(.labelNormal)
            }
        }
    }
}
