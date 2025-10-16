//
//  TabPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/15/24.
//

import SwiftUI
import Montage

struct TabPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State var selectedIndex = 0
    @State var sizeIndex = 1
    @State var items: [String] = []
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
        SwiftUI.ScrollView {
            VStack {
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
                Montage.Tab(
                    selectedIndex: $selectedIndex,
                    items: items
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
                        SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                            .size(.small)
                    }
                    HStack {
                        Text("tab count \(Int(count.rounded()))")
                        Slider(value: $count, in: 2...10)
                    }
                    HStack {
                        Text("fill")
                        Control.switch(checked: resize) { resize = $0 }
                        Text("icon")
                        Control.switch(checked: icon) { icon = $0 }
                        Text("horizontalPadding")
                        Control.switch(checked: horizontalPadding) { horizontalPadding = $0 }
                        Spacer(minLength: 0)
                    }
                }
                .padding()
            }
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Montage.Tab.Size: CaseDescribable {}

#Preview {
    TabPreview()
}
