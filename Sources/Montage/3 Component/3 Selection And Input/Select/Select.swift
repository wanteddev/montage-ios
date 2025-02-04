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
        case single, multiple(render: Render = .text, overflow: Bool = false)
    }
    
    /// 아이템 타입입니다.
    public struct Item: Equatable {
        public enum State {
            case normal
            case negative
        }
        
        public let state: State
        public let text: String
        public var icon: Icon?
        
        public init(
            state: State = .normal,
            text: String,
            icon: Icon? = nil
        ) {
            self.state = state
            self.text = text
            self.icon = icon
        }
    }
    
    /// variant가 multiple일 때 컴포넌트에 표시될 내용의 형태를 결정하는 열거형입니다.
    public enum Render: String, CaseIterable {
        case text
        case chip
    }
    
    private let variant: Variant
    private let items: [Item]
    private let onTapItem: ((Select.Item) -> Void)?
    private let onSelectionChanged: ([Select.Item]) -> Void
    
    public init(
        variant: Variant,
        items: [Item],
        onTapItem: ((Select.Item) -> Void)? = nil,
        onSelectionChanged: @escaping ([Select.Item]) -> Void
    ) {
        self.variant = variant
        self.items = items
        self.onTapItem = onTapItem
        self.onSelectionChanged = onSelectionChanged
    }
    
    // MARK: - Body
    @State private var selectedIndices: [Int] = []
    @State private var contentSize: CGSize = .zero
    @State private var menuPresented: Bool = false
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
                                                onTapItem: { item in
                                                    selectedIndices.removeAll { items[$0] == item }
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
                    
                    if !selectedIndices.isEmpty, negative {
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
                        menuPresented.toggle()
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
                        .stroke(strokeColor, lineWidth: menuPresented ? 2 : 1)
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
            menuPresented.toggle()
        }
        .sheet(isPresented: $menuPresented) {
            VStack {
                ForEach(Array(items.enumerated()), id: \.offset) { item in
                    Cell(title: item.element.text) {
                        switch variant {
                        case .single:
                            selectedIndices = [item.offset]
                        case .multiple:
                            if selectedIndices.contains(item.offset) {
                                selectedIndices.removeAll { $0 == item.offset }
                            } else {
                                selectedIndices.append(item.offset)
                            }
                        }
                        onSelectionChanged(selectedItems)
                    }
                    .active(selectedIndices.contains(item.offset))
                    .rightContent { active in
                        Control.Check(state: active)
                    }
                }
            }
            .padding()
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { menuSize = $0 })
            .presentationDetents([.height(menuSize.height)])
        }
//        .onAppear {
//            selectedIndices = Array(0..<Int(items.count))
//        }
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
        items.enumerated()
            .filter { selectedIndices.contains($0.offset) }
            .map { $0.element }
    }
    
    private var strokeColor: SwiftUI.Color {
        if disable {
            .alias(.lineNeutral)
        } else {
            if negative {
                .alias(.statusNegative).opacity(0.28)
            } else {
                menuPresented ? .alias(.primaryNormal).opacity(0.43) : .alias(.lineNeutral)
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
        var onTapItem: ((Select.Item) -> Void)?
        
        var body: some View {
            ForEach(Array(items.indices), id: \.self) {
                let item = items[$0]
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
                    onTapItem?(item)
                }
            }
        }
        
        private func iconColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .alias(.labelDisable) }
            switch item.state {
            case .normal:
                return .alias(.labelAlternative)
            case .negative:
                return .alias(.statusNegative)
            }
        }
        
        private func backgroundColor(_ item: Select.Item) -> SwiftUI.Color? {
            guard disable == false else { return nil }
            switch item.state {
            case .normal:
                return nil
            case .negative:
                return .alias(.statusNegative).opacity(0.05)
            }
        }
        
        private func fontColor(_ item: Select.Item) -> SwiftUI.Color {
            guard disable == false else { return .alias(.labelDisable) }
            switch item.state {
            case .normal:
                return .alias(.labelNormal)
            case .negative:
                return .alias(.statusNegative)
            }
        }
    }
}
