//
//  AccordionPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/3/25.
//

import SwiftUI
import Montage

struct AccordionPreview: View {
    @State private var multilineTitle = false
    @State private var description = true
    @State private var content = true
    @State private var trailingContent = false
    @State private var verticalPaddingIndex = 0
    @State private var hideDivider = false
    @State private var fillWidth = false
    @State private var recursive = false
    @State private var leadingIcon = false
    
    let verticalPaddings: [Accordion.VerticalPadding] = [.small, .medium, .large]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                Group {
                    Accordion(
                        title: multilineTitle ? "제목이 두 줄이\n될 수도 있다고 합니다" : "제목",
                        description: description ? "제목에 대한 상세 내용을 입력해주세요.\n긴 컨텐츠라면 접은 상태를 기본 값으로 사용하세요." : nil,
                        content: content ? {
                            recursive ?
                            Group {
                                Accordion(title: "1.제목", description: "컨텐츠에 아코디언이 또 들어갈 수도 있지요.")
                                Accordion(title: "2.제목", content: { dummyContent })
                                Accordion(title: "3.제목(fillWidth = true)", content: { dummyContent })
                                    .fillWidth()
                            } :
                            dummyContent
                        } : nil
                    )
                    .verticalPadding(verticalPaddings[verticalPaddingIndex])
                    .hideDivider(hideDivider)
                    .fillWidth(fillWidth)
                    .leadingIcon(leadingIcon ? .alignJustify : nil)
                    .trailingContent {
                        if trailingContent {
                            ContentBadge(variant: .solid, text: "뱃지")
                        } else {
                            EmptyView()
                        }
                    }
                }
                Text("Options").bold()
                HStack {
                    Text("multilineTitle")
                    Switch($multilineTitle)
                }
                HStack {
                    Text("description")
                    Switch($description)
                    Text("content")
                    Switch($content)
                }
                HStack {
                    Text("leadingIcon")
                    Switch($leadingIcon)
                    Text("trailingContent")
                    Switch($trailingContent)
                }
                HStack {
                    Text("verticalPadding")
                    SegmentedControl(
                        selectedIndex: $verticalPaddingIndex,
                        labels: verticalPaddings.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("hideDivider")
                    Switch($hideDivider)
                    Text("fillWidth")
                    Switch($fillWidth)
                    Text("recursive")
                    Switch($recursive)
                }
                Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    var dummyContent: some View {
        Rectangle()
            .fill(SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.2))
            .frame(height: 100)
    }
}

extension Accordion.VerticalPadding: CaseDescribable {}

#Preview {
    AccordionPreview()
}
