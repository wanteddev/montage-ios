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
    @State var items: [String] = []
    @State var count: CGFloat = 2
    @State var resize = false
    @State var horizontalPadding: Bool = false
    @State var icon: Bool = false
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                .padding(.horizontal)
                Montage.Tab(
                    selectedIndex: $selectedIndex,
                    items: items
                )
                .size(Tab.Size.allCases[sizeIndex])
                .resize(resize ? .fill : .hug)
                .horizontalPadding(horizontalPadding)
                .if(icon) {
                    $0.iconButton(.apps) {
                        print("button clicked")
                    }
                }
                .onAppear(perform: {
                    items = Array(1...Int(count.rounded())).map { "Tab \($0)" }
                })
                .onChange(of: count) { _ in
                    items = Array(1...Int(count.rounded())).map { "Tab \($0)" }
                    resize = false
                    icon = false
                    horizontalPadding = false
                }
                VStack(alignment: .leading) {
                    Text("Options").bold()
                    HStack {
                        Text("size")
                        SegmentedControl(selectedIndex: $sizeIndex, labels: Tab.Size.allCases.map(\.rawValue))
                            .size(.small)
                    }
                    HStack {
                        Text("tab count \(Int(count.rounded()))")
                        Slider(value: $count, in: 2...10)
                    }
                    HStack {
                        Text("fill")
                        Control.Switch($resize)
                        Text("icon")
                        Control.Switch($icon)
                        Text("horizontalPadding")
                        Control.Switch($horizontalPadding)
                        Spacer(minLength: 0)
                    }
                }
                .padding()
            }
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    TabPreview()
}
