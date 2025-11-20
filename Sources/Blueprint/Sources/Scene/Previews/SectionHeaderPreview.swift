//
//  SectionHeaderPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/20/25.
//

import SwiftUI
import Montage

struct SectionHeaderPreview: View {
    @State private var showTransparentChecker: Bool = false
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
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                SectionHeader(title: title)
                    .headingContent {
                        if headingContent {
                            FilterButton(variant: .outlined, size : .small, text: "텍스트")
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
                    TextField(text: $title)
                }
                HStack {
                    Text("titleColor")
                    Switch(checked: titleColor) { titleColor = $0 }
                }
                HStack {
                    Text("heading content")
                    Switch(checked: headingContent) { headingContent = $0 }
                    Text("trailing content")
                    Switch(checked: trailingContent) { trailingContent = $0 }
                }
            }
            .padding(.horizontal)
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension SectionHeader.Size: CaseDescribable {}

import Pretendard
#Preview {
    _ = try? Pretendard.registerFonts()
    return SectionHeaderPreview()
}
