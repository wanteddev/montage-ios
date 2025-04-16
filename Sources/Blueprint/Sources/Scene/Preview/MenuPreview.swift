//
//  MenuPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/5/25.
//

import SwiftUI
import Montage

struct MenuPreview: View {
    @State var items: [Montage.Menu.Item] = [
        .init(title: "Item 1"),
        .init(title: "Item 2"),
        .init(title: "Item 3"),
        .init(title: "Item 4"),
        .init(title: "Item 5"),
        .init(title: "Item 6"),
        .init(title: "Item 7"),
        .init(title: "Item 8"),
        .init(title: "Item 9"),
        .init(title: "Item 10")
    ]
    
    @State var variantIndex: Int = 0
    @State var menuActionArea: Bool = false
    @State var selectAllState: Control.State = .unchecked
    
    private let variants: [Montage.Menu.Variant] = [.normal, .radio, .checkbox]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Preview").bold()
                Spacer()
            }
            Montage.Menu(variant: variants[variantIndex], items: $items) {
                print("\($0) selectd")
            } cellModifier: { index, cell in
                cell
            }
            .if(menuActionArea) {
                $0.menuActionArea {
                    Group {
                        if variants[variantIndex] == .checkbox {
                            Input.checkbox(state: selectAllState, text: leadingButtonTitle) { _ in
                                items = items.map {
                                    var mutated = $0
                                    mutated.isSelected = !allSelected
                                    return mutated
                                }
                            }
                            .onChange(of: allSelected) { _ in
                                updateSelectAllState()
                            }
                            .onChange(of: nothingSelected) { _ in
                                updateSelectAllState()
                            }
                        }
                    }
                } trailingContent: {
                    Button.solid(variant: .primary, size: .small, text: "확인")
                }
            }
            .frame(height: 300)
            
            Text("Options").bold()
            HStack {
                Text("size")
                SegmentedControl(selectedIndex: $variantIndex, labels: variants.map(\.description))
                    .size(.small)
            }
            HStack {
                Text("menuActionArea")
                Control.Switch($menuActionArea)
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    func updateSelectAllState() {
        selectAllState = if nothingSelected {
            .unchecked
        } else if allSelected {
            .checked
        } else {
            .indeterminate
        }
    }
    
    var nothingSelected: Bool {
        items.filter { $0.isSelected }.isEmpty
    }
    
    var allSelected: Bool {
        items.filter { !$0.isSelected }.isEmpty
    }
    
    var leadingButtonTitle: String {
        if variants[variantIndex] == .checkbox {
            allSelected ? "전체 해제" : "전체 선택"
        } else {
            ""
        }
    }
}

extension Montage.Menu.Variant: CaseDescribable {}

#Preview {
    MenuPreview()
}
