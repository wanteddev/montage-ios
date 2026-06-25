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
    @State private var leadingContent = false

    let verticalPaddings: [Accordion.VerticalPadding] = [.small, .medium, .large]

    var body: some View {
        PreviewLayout {
            Group {
                Accordion(
                    title: multilineTitle ? "제목이 두 줄이\n될 수도 있다고 합니다" : "제목",
                    description: description ? "제목에 대한 상세 내용을 입력해주세요.\n긴 컨텐츠라면 접은 상태를 기본 값으로 사용하세요." : nil,
                    content: {
                        if content {
                            if recursive {
                                Accordion(title: "1.제목", description: "컨텐츠에 아코디언이 또 들어갈 수도 있지요.")
                                Accordion(title: "2.제목", content: { dummyContent })
                                Accordion(title: "3.제목(fillWidth = true)", content: { dummyContent })
                                    .fillWidth()
                            } else {
                                dummyContent
                            }
                        }
                    }
                )
                .verticalPadding(verticalPaddings[verticalPaddingIndex])
                .hideDivider(hideDivider)
                .fillWidth(fillWidth)
                .leadingContent({
                    if leadingContent {
                        Thumbnail(urlString: "https://images.icon-icons.com/4128/PNG/512/hero_main_heading_title_icon_260510.png", ratio: .r1x1)
                            .frame(width: 24, height: 24)
                    }
                })
                .trailingContent { isExpanded in
                    if trailingContent {
                        HStack(spacing: 4) {
                            TextButton(
                                color: .assistive,
                                size: .small,
                                text: isExpanded ? "접기" : "펼치기"
                            )
                            Image.icon(isExpanded ? .chevronUp : .chevronDown)
                                .resizable()
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                                .frame(width: 16, height: 16)
                        }
                        .frame(height: 24)
                        .allowsHitTesting(false)
                    }
                }
            }
        } options: {
            ToggleOptionRow("multilineTitle", isOn: $multilineTitle)
            HStack {
                ToggleOption("description", isOn: $description)
                ToggleOption("content", isOn: $content)
            }
            HStack {
                ToggleOption("leadingContent", isOn: $leadingContent)
                ToggleOption("trailingContent", isOn: $trailingContent)
            }
            SegmentedIndexRow("verticalPadding", index: $verticalPaddingIndex, labels: verticalPaddings.map(\.description))
            HStack {
                ToggleOption("hideDivider", isOn: $hideDivider)
                ToggleOption("fillWidth", isOn: $fillWidth)
                ToggleOption("recursive", isOn: $recursive)
            }
        }
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
