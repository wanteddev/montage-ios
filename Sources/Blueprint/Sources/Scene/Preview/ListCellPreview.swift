//
//  ListCellPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/13/24.
//

import SwiftUI
import Montage

struct ListCellPreview: View {
    @State private var isOn: Bool = true
    @State private var caption = false
    @State private var verticalPaddingIndex = 1
    @State private var fillWidth = false
    @State private var chevron = false
    @State private var leadingContent = false
    @State private var trailingContent = false
    @State private var verticalAlignmentIndex = 0
    @State private var textEllipsis = false
    @State private var divider = false
    @State private var disable = false
    @State private var longText = false
    @State private var interactionPadding: CGFloat = 12
    @State private var selected = false
    @State private var highlightText: String = ""

    let verticalPaddings: [ListCell.VerticalPadding] = [.none, .small, .medium, .large]
    let verticalAlignments: [VerticalAlignment] = [.top, .center, .bottom]

    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()

                ListCell(title: longText ? "이것은 세 줄 이상으로 표현될 수 있는 긴 문장입니다. 충분히 길어야 줄 바꿈이 됩니다. 더욱 더 많이 길어야 합니다." : "텍스트", onTap: {
                    print("helloworld")
                })
                .caption(caption ? "캡션" : nil)
                .verticalPadding(verticalPaddings[verticalPaddingIndex])
                .verticalAlign(verticalAlignments[verticalAlignmentIndex])
                .fillWidth(fillWidth)
                .chevron(chevron)
                .leadingContent(leadingContent ? {
                    Image.icon(.star)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .scaledToFit()
                } : nil)
                .trailingContent(trailingContent ? {
                    Control.checkmark(checked: $0)
                } : nil)
                .textEllipsis(textEllipsis)
                .divider(divider)
                .disable(disable)
                .interactionPadding(interactionPadding)
                .selected(selected)
                .if(!highlightText.isEmpty) {
                    $0.highlight(highlightText)
                }

                Text("Options").bold()

                HStack {
                    Text("Vertical Padding")
                    SegmentedControl(
                        selectedIndex: $verticalPaddingIndex,
                        labels: verticalPaddings.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("Caption")
                    Switch($caption)
                    Text("Fill Width")
                    Switch($fillWidth)
                    Text("Chevron")
                    Switch($chevron)
                }
                HStack {
                    Text("Leading Content")
                    Switch($leadingContent)
                    Text("Trailing Content")
                    Switch($trailingContent)
                }
                HStack {
                    Text("Text Ellipsis")
                    Switch($textEllipsis)
                    Text("Divider")
                    Switch($divider)
                }
                HStack {
                    Text("Disable")
                    Switch($disable)
                    Text("Long Text")
                    Switch($longText)
                    Text("Selected")
                    Switch($selected)
                }
                HStack {
                    Text("Vertical Alignment")
                    SegmentedControl(
                        selectedIndex: $verticalAlignmentIndex,
                        labels: verticalAlignments.map { alignment in
                            switch alignment {
                            case .top: "top"
                            case .center: "center"
                            case .bottom: "bottom"
                            default: "unknown"
                            }
                        }
                    )
                    .size(.small)
                }
                HStack {
                    Text("Interaction Padding")
                    Slider(value: $interactionPadding, in: 0...20, step: 1)
                        .frame(width: 150)
                    Text("\(Int(interactionPadding))pt")
                        .frame(width: 40, alignment: .leading)
                }
                HStack {
                    Text("Highlight Text")
                    TextField(text: $highlightText)
                        .placeholder("강조할 텍스트를 입력하세요")
                }
                Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension ListCell.VerticalPadding: CaseDescribable {}

#Preview {
    ListCellPreview()
}
