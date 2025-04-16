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
    @State var items: [String] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
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
                Text("Preview").bold()
                    .padding(.horizontal)
                
                Category(selectedIndex: $selectedIndex, items: items)
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
                    Control.Switch($showGuideLine)
                    Text("alternative")
                    Control.Switch($isAlternative)
                    Text("icon")
                    Control.Switch($icon)
                }
                HStack {
                    Text("horizontalPadding")
                    Control.Switch($horizontalPadding)
                    Text("vertical padding")
                    Control.Switch($verticalPadding)
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
                }
            }
            .padding(.horizontal)
            .alert("icon Button Pressed", isPresented: $alertPresented) {}
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Montage.Category.Size: CaseDescribable {}

#Preview {
    CategoryPreview()
}
