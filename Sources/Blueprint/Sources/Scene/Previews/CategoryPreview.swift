//
//  CategoryPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/8/25.
//

import SwiftUI
import Montage

struct CategoryPreview: View {
    @State private var showTransparentChecker: Bool = false
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
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                .padding(.horizontal)
                
                Category(selectedIndex: $selectedIndex, items: items.map(\.text), itemModifier: { index, actionChip in
                    actionChip.disabled(items[index].isSelected)
                })
                .variant(isAlternative ? .alternative : .normal)
                .size(sizes[sizeIndex])
                .horizontalPadding(horizontalPadding)
                .verticalPadding(verticalPadding)
                .if(icon) {
                    $0.iconButton(.apps, action: { alertPresented.toggle() })
                }
                .border(showGuideLine ? .blue : .clear)
            }
            
            VStack(alignment: .leading) {
                Text("Options").bold()
                HStack {
                    Text("guideLine")
                    Control.switch(checked: showGuideLine) { showGuideLine = $0 }
                    Text("alternative")
                    Control.switch(checked: isAlternative) { isAlternative = $0 }
                    Text("icon")
                    Control.switch(checked: icon) { icon = $0 }
                }
                HStack {
                    Text("horizontalPadding")
                    Control.switch(checked: horizontalPadding) { horizontalPadding = $0 }
                    Text("vertical padding")
                    Control.switch(checked: verticalPadding) { verticalPadding = $0 }
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
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
            .padding(.horizontal)
            .alert("icon Button Pressed", isPresented: $alertPresented) {}
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Montage.Category.Size: CaseDescribable {}

#Preview {
    CategoryPreview()
}
