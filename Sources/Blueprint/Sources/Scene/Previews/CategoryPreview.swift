//
//  CategoryPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/8/25.
//

import SwiftUI
import Montage

struct CategoryPreview: View {
    @State var showGuideLine: Bool = false
    @State var selectedIndex: Int = 0
    @State var items: [Select.Item] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"].map { Select.Item(text: $0) }
    @State var isAlternative: Bool = false
    @State var sizeIndex: Int = 1
    @State var horizontalPadding: Bool = false
    @State var verticalPadding: Bool = false
    @State var icon: Bool = false
    @State var alertPresented = false

    private let sizes: [Montage.Category.Size] = [
        .small, .medium, .large, .xlarge
    ]

    var body: some View {
        PreviewLayout {
            Category(selectedIndex: $selectedIndex, items: items.map(\.text), itemModifier: { index, chip in
                chip.disabled(items[index].isSelected)
            })
            .variant(isAlternative ? .alternative : .normal)
            .size(sizes[sizeIndex])
            .horizontalPadding(horizontalPadding)
            .verticalPadding(verticalPadding)
            .if(icon) {
                $0.iconButton(.apps, action: { alertPresented.toggle() })
            }
            .border(showGuideLine ? .blue : .clear)
            .alert("icon Button Pressed", isPresented: $alertPresented) {}
        } options: {
            HStack {
                ToggleOption("guideLine", isOn: $showGuideLine)
                ToggleOption("alternative", isOn: $isAlternative)
                ToggleOption("icon", isOn: $icon)
            }
            HStack {
                ToggleOption("horizontalPadding", isOn: $horizontalPadding)
                ToggleOption("vertical padding", isOn: $verticalPadding)
                Spacer(minLength: 0)
            }
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            HStack {
                Text("disabled items")
                Select(
                    variant: .multiple(
                        render: .chip,
                        overflow: false,
                        menuPrimaryButtonTitle: "확인"
                    ),
                    items: $items
                )
            }
        }
    }
}

extension Montage.Category.Size: CaseDescribable {}

#Preview {
    CategoryPreview()
}
