//
//  SegmentedControlPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/13/24.
//

import SwiftUI
import Montage

struct SegmentedControlPreview: View {
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
        PreviewLayout {
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
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            ToggleOptionRow("icon", isOn: $showIcon)
        }
    }
}

extension SegmentedControl.Variant: CaseDescribable {}
extension SegmentedControl.Size: CaseDescribable {}

#Preview {
    SegmentedControlPreview()
}
