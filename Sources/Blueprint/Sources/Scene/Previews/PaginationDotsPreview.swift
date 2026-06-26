//
//  PaginationDotsPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import Montage
import SwiftUI

struct PaginationDotsPreview: View {
    @State private var selectedPage: Int = 1
    @State private var totalPages: Int = 5
    @State private var variantIndex: Int = 0
    @State private var sizeIndex: Int = 0

    private let variants: [PaginationDots.Variant] = [.normal, .white]
    private let sizes: [PaginationDots.Size] = [.normal, .small]

    var body: some View {
        PreviewLayout {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    PaginationDots(selectedPage: $selectedPage, totalPages: totalPages)
                        .variant(variants[variantIndex])
                        .size(sizes[sizeIndex])
                    Spacer()
                }

                Text("\(selectedPage) / \(totalPages)")
            }
        } options: {
            PrevNextOptionRow(value: $selectedPage, in: 1...totalPages)

            SliderOptionRow("totalPages", value: Binding(
                get: { Double(totalPages) },
                set: {
                    totalPages = Int($0)
                    if selectedPage > totalPages {
                        selectedPage = totalPages
                    }
                }
            ), in: 1...10)

            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
        }
    }
}

extension PaginationDots.Variant: CaseDescribable {}
extension PaginationDots.Size: CaseDescribable {}

#Preview {
    PaginationDotsPreview()
}
