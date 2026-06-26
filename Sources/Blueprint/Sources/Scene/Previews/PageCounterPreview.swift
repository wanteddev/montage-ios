//
//  PageCounterPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import Montage
import SwiftUI

struct PageCounterPreview: View {
    @State var selectedPage: Int = 1
    @State var sizeIndex: Int = 0
    @State var totalPages: Int = 5
    @State var isAlternative: Bool = false

    private let sizes: [PageCounter.Size] = [
        .small,
        .medium,
    ]

    var body: some View {
        PreviewLayout {
            PageCounter(selectedPage: $selectedPage, totalPages: totalPages)
                .size(sizes[sizeIndex])
                .alternative(isAlternative)
        } options: {
            PrevNextOptionRow(value: $selectedPage, in: 1...totalPages)

            SliderOptionRow("totalPages", value: Binding(
                get: { Double(totalPages) },
                set: { totalPages = Int($0) }
            ), in: 1...10, step: 1)

            ToggleOptionRow("alternative", isOn: $isAlternative)
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
        }
    }
}

extension PageCounter.Size: CaseDescribable {}

#Preview {
    PageCounterPreview()
}
