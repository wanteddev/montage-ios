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
    @State private var sizeIndex: Int = 0
    @State private var showIcon: Bool = true
    @State private var iconOnly: Bool = false

    private let sizes: [SegmentedControl.Size] = [.large, .medium, .small]

    var items: [SegmentedControl.Item] {
        // iconOnly일 때는 반드시 아이콘이 필요하므로 아이콘 항목을 사용한다.
        if showIcon || iconOnly {
            return [
                .init(image: .icon(.android), title: "Android"),
                .init(image: .icon(.logoApple), title: "iOS"),
                .init(image: .icon(.globe), title: "Web"),
                .init(image: .icon(.apps), title: "ETC")
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
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: items,
                onSelect: { print($0) }
            )
            .size(sizes[sizeIndex])
            .iconOnly(iconOnly)
        } options: {
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            HStack {
                ToggleOption("icon", isOn: $showIcon)
                ToggleOption("iconOnly", isOn: $iconOnly)
            }
        }
    }
}

extension SegmentedControl.Size: CaseDescribable {}

#Preview {
    SegmentedControlPreview()
}
