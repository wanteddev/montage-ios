//
//  SegmentedControlPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/13/24.
//

import SwiftUI
import Montage

struct SegmentedControlPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var selectedIndex: Int = 0
    @State private var variantIndex: Int = 0
    @State private var sizeIndex: Int = 0
    @State private var showIcon: Bool = true
    
    private let variants: [SegmentedControl.Variant] = [.solid, .outlined]
    private let sizes: [SegmentedControl.Size] = [.large, .medium, .small]
    
    var items: [SegmentedControl.Item] {
        if showIcon {
            return [
                .init(image: .icon(.android), title: "Android"),
                .init(image: .icon(.logoApple), title: "iOS"),
                .init(image: .icon(.globe), title: "Web"),
                .init(title: "ETC")
            ]
        } else {
            return [
                .init(title: "Android"),
                .init(title: "iOS"),
                .init(title: "Web"),
                .init(title: "ETC")
            ]
        }
    }
    
    var body: some View {
        ScrollView {
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
                
                HStack {
                    Spacer()
                    SegmentedControl(
                        selectedIndex: $selectedIndex,
                        items: items,
                        onSelect: { print($0) }
                    )
                    .variant(variants[variantIndex])
                    .size(sizes[sizeIndex])
                    Spacer()
                }
                .padding(.vertical)
                
                Text("Options").bold()
                
                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        labels: variants.map(\.description)
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: sizes.map(\.description)
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("icon")
                    Control.switch(checked: showIcon) { showIcon = $0 }
                }
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension SegmentedControl.Variant: CaseDescribable {}
extension SegmentedControl.Size: CaseDescribable {}

#Preview {
    SegmentedControlPreview()
}
