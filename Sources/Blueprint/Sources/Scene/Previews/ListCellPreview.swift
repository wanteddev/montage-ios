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
        PreviewLayout {
            ListCell(title: longText ? "이것은 세 줄 이상으로 표현될 수 있는 긴 문장입니다. 충분히 길어야 줄 바꿈이 됩니다. 더욱 더 많이 길어야 합니다." : "텍스트", onTap: {
                print("helloworld")
            })
            .caption(caption ? "캡션" : nil)
            .verticalPadding(verticalPaddings[verticalPaddingIndex])
            .verticalAlign(verticalAlignments[verticalAlignmentIndex])
            .fillWidth(fillWidth)
            .chevron(chevron)
            .leadingContent {
                if leadingContent {
                    Image.icon(.star)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .scaledToFit()
                }
            }
            .trailingContent { selected in
                if trailingContent {
                    Checkmark(checked: selected)
                }
            }
            .textEllipsis(textEllipsis)
            .divider(divider)
            .disable(disable)
            .interactionPadding(interactionPadding)
            .selected(selected)
            .if(!highlightText.isEmpty) {
                $0.highlight(highlightText)
            }
        } options: {
            SegmentedIndexRow("Vertical Padding", index: $verticalPaddingIndex, labels: verticalPaddings.map(\.description))
            HStack {
                ToggleOption("Caption", isOn: $caption)
                ToggleOption("Fill Width", isOn: $fillWidth)
                ToggleOption("Chevron", isOn: $chevron)
            }
            HStack {
                ToggleOption("Leading Content", isOn: $leadingContent)
                ToggleOption("Trailing Content", isOn: $trailingContent)
            }
            HStack {
                ToggleOption("Text Ellipsis", isOn: $textEllipsis)
                ToggleOption("Divider", isOn: $divider)
            }
            HStack {
                ToggleOption("Disable", isOn: $disable)
                ToggleOption("Long Text", isOn: $longText)
                ToggleOption("Selected", isOn: $selected)
            }
            SegmentedIndexRow("Vertical Alignment", index: $verticalAlignmentIndex, labels: verticalAlignments.map { alignment in
                switch alignment {
                case .top: "top"
                case .center: "center"
                case .bottom: "bottom"
                default: "unknown"
                }
            })
            SliderOptionRow("Interaction Padding", value: $interactionPadding, in: 0...20, step: 1, format: { "\(Int(Double($0)))pt" })
            TextFieldOptionRow("Highlight Text", text: $highlightText)
        }
    }
}

extension ListCell.VerticalPadding: CaseDescribable {}

#Preview {
    ListCellPreview()
}
