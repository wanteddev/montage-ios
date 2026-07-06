//
//  TabPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/15/24.
//

import SwiftUI
import Montage

struct TabPreview: View {
    @State var selectedIndex = 0
    @State var sizeIndex = 1
    @State var items: [Select.Item] = []
    @State var count: CGFloat = 2
    @State var resize = false
    @State var horizontalPadding: Bool = false
    @State var icon: Bool = false

    private let sizes: [Montage.Tab.Size] = [
        .small,
        .medium,
        .large
    ]

    var body: some View {
        PreviewLayout {
            Montage.Tab(
                selectedIndex: $selectedIndex,
                items: items.map(\.text),
                itemDisabled: { index in
                    items[index].isSelected
                }
            )
            .size(sizes[sizeIndex])
            .resize(resize ? .fill : .hug)
            .horizontalPadding(horizontalPadding)
            .if(icon) {
                $0.iconButton(.apps) {
                    print("button clicked")
                }
            }
            .onAppear(perform: {
                items = Array(1...Int(count.rounded())).map { .init(text: "Tab \($0)") }
            })
            .onChange(of: count) { _ in
                items = Array(1...Int(count.rounded())).map { .init(text: "Tab \($0)") }
                resize = false
                icon = false
                horizontalPadding = false
            }
        } options: {
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            SliderOptionRow("tab count \(Int(count.rounded()))", value: $count, in: 2...10, step: 1)
            HStack {
                ToggleOption("fill", isOn: $resize)
                ToggleOption("icon", isOn: $icon)
                ToggleOption("horizontalPadding", isOn: $horizontalPadding)
                Spacer(minLength: 0)
            }
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

extension Montage.Tab.Size: CaseDescribable {}

#Preview {
    TabPreview()
}
