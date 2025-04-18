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
        SwiftUI.ScrollView {
            VStack {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                SectionHeader(title: title)
                    .headingContent(headingContent ? {
                        Chip.Filter(variant: .outlined, size : .small, text: "텍스트")
                    } : nil)
                    .trailingContent(trailingContent ? { ContentBadge(text: "텍스트") } : nil)
                    .size(sizes[sizeIndex])
                    .if(titleColor) {
                        $0.titleColor(.semantic(.accentBackgroundPink))
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
                Text("Options").bold()
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
                }
                HStack {
                    Text("text")
                    TextInput.TextField(text: $title)
                }
                HStack {
                    Text("titleColor")
                    Control.Switch($titleColor)
                }
                HStack {
                    Text("heading content")
                    Control.Switch($headingContent)
                    Text("trailing content")
                    Control.Switch($trailingContent)
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension SectionHeader.Size: CaseDescribable {}

import Pretendard
#Preview {
    _ = try? Pretendard.registerFonts()
    return SectionHeaderPreview()
}
