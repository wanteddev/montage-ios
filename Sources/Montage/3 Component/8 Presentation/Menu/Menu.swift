//
//  Menu.swift
//  Montage
//
//  Created by 김삼열 on 2/5/25.
//

import SwiftUI

public struct Menu: View {
    public enum Variant {
        case normal
        case radio
        case checkbox
    }
    
    public struct Item: Equatable {
        public let title: String
        public var isSelected: Bool
        
        public init(title: String, isSelected: Bool = false) {
            self.title = title
            self.isSelected = isSelected
        }
    }
    
    private let variant: Variant
    @Binding private var items: [Item]
    private let onSelectCell: ((Item) -> Void)?
    private let cellModifier: (_ index: Int, _ cell: Cell) -> Cell
    
    public init(
        variant: Variant,
        items: Binding<[Item]>,
        onSelectCell: ((Item) -> Void)? = nil,
        cellModifier: @escaping (_ index: Int, _ cell: Cell) -> Cell = { _, cell in cell }
    ) {
        self.variant = variant
        _items = items
        self.onSelectCell = onSelectCell
        self.cellModifier = cellModifier
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            SwiftUI.ScrollView {
                VStack(spacing: 4) {
                    ForEach(items.indices, id: \.self) { index in
                        cellModifier(index, Cell(title: items[index].title, onTap: {
                            switch variant {
                            case .radio:
                                items = items.map {
                                    var mutated = $0
                                    mutated.isSelected = false
                                    return mutated
                                }
                                fallthrough
                            case .checkbox:
                                items[index].isSelected.toggle()
                            default: break
                            }
                            onSelectCell?(items[index])
                        }))
                        .leadingContent {
                            Group {
                                switch variant {
                                case .radio:
                                    Control.radio(checked: items[index].isSelected)
                                case .checkbox:
                                    Control.checkbox(checked: items[index].isSelected)
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }
            
            if menuActionArea {
                HStack(spacing: 0) {
                    AnyView(menuActionAreaLeadingContent())
                        .frame(alignment: .leading)
                    Spacer(minLength: 24)
                    AnyView(menuActionAreaTrailingContent())
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .frame(height: 56)
                .background(SwiftUI.Color.semantic(.backgroundElevated))
                .overlay {
                    Rectangle()
                        .strokeBorder(SwiftUI.Color.semantic(.lineSolidAlternative), lineWidth: 1)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(SwiftUI.Color.semantic(.lineSolidNeutral), lineWidth: 1)
                .shadow(color: .semantic(.staticBlack).opacity(0.04), radius: 1, x: 0, y: 1)
        }
        .padding(.vertical, 8)
    }
    
    private var menuActionArea = false
    private var menuActionAreaLeadingContent: () -> any View = { EmptyView() }
    private var menuActionAreaTrailingContent: () -> any View = { EmptyView() }
    
    public func menuActionArea(
        leadingContent: @escaping () -> any View,
        trailingContent: @escaping () -> any View
    ) -> Self {
        var zelf = self
        zelf.menuActionArea = true
        zelf.menuActionAreaLeadingContent = leadingContent
        zelf.menuActionAreaTrailingContent = trailingContent
        return zelf
    }
}
