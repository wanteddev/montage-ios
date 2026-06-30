//
//  SectionHeaderPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/20/25.
//

import SwiftUI
import Montage

struct SectionHeaderPreview: View {
    @State var title: String = "제목"
    @State var sizeIndex: Int = 2
    @State var headingContent = false
    @State var titleColor = false
    @State var trailingContent = false

    private let sizes: [SectionHeader.Size] = [
        .xsmall,
        .small,
        .medium,
        .large
    ]

    var body: some View {
        PreviewLayout {
            SectionHeader(title: title)
                .headingContent {
                    if headingContent {
                        FilterButton(variant: .outlined, size: .small, text: "텍스트")
                    }
                }
                .trailingContent {
                    if trailingContent {
                        ContentBadge(text: "텍스트")
                    }
                }
                .size(sizes[sizeIndex])
                .if(titleColor) {
                    $0.titleColor(.semantic(.accentBackgroundPink))
                }
                .padding(.vertical)
        } options: {
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            TextFieldOptionRow("text", text: $title)
            ToggleOptionRow("titleColor", isOn: $titleColor)
            HStack {
                ToggleOption("heading content", isOn: $headingContent)
                ToggleOption("trailing content", isOn: $trailingContent)
            }
        }
    }
}

extension SectionHeader.Size: CaseDescribable {}

#Preview {
    return SectionHeaderPreview()
}
