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
    @State private var description = false
    @State private var verticalPaddingIndex = 1
    @State private var customVerticalPadding: CGFloat = 24
    @State private var chevron = false
    @State private var leadingContent = false
    @State private var multipleLeadingContent = false
    @State private var labelTrailingContent = false
    @State private var multipleLabelTrailingContent = false
    @State private var trailingContent = false
    @State private var multipleTrailingContent = false
    @State private var extraContent = false
    @State private var verticalAlignmentIndex = 0
    @State private var textEllipsis = false
    @State private var divider = false
    @State private var disable = false
    @State private var longText = false
    @State private var interactionOutset: CGFloat = 12
    @State private var interactionRadius: CGFloat = 16
    @State private var selected = false
    @State private var highlightText: String = ""

    var verticalPaddings: [ListCell.VerticalPadding] {
        [.none, .small, .medium, .large, .custom(customVerticalPadding)]
    }

    var isCustomVerticalPadding: Bool {
        if case .custom = verticalPaddings[verticalPaddingIndex] { true } else { false }
    }

    let verticalAlignments: [ListCell.VerticalAlign] = [.top, .center]

    var labelText: String {
        longText ? "이것은 세 줄 이상으로 표현될 수 있는 긴 문장입니다. 충분히 길어야 줄 바꿈이 됩니다. 더욱 더 많이 길어야 합니다." : "텍스트"
    }

    var descriptionText: String {
        longText ? "이것은 두 줄 이상으로 표현될 수 있는 긴 설명입니다. 충분히 길어야 줄 바꿈이 됩니다." : "설명"
    }

    var body: some View {
        PreviewLayout {
            ListCell(label: labelText, onTap: {
                print("helloworld")
            })
            .description(description ? descriptionText : nil)
            .verticalPadding(verticalPaddings[verticalPaddingIndex])
            .verticalAlign(verticalAlignments[verticalAlignmentIndex])
            .chevron(chevron)
            .leadingContent {
                if leadingContent {
                    Checkmark(checked: selected)

                    if multipleLeadingContent {
                        Avatar("", variant: .person, size: .xsmall)
                    }
                }
            }
            .labelTrailingContent {
                if labelTrailingContent {
                    ContentBadge(text: "배지")

                    if multipleLabelTrailingContent {
                        Image.icon(.check)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(SwiftUI.Color.semantic(.surfaceBrandPrimary))
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .trailingContent { selected in
                if trailingContent {
                    if multipleTrailingContent {
                        Text("값")
                    }

                    Checkmark(checked: selected)
                }
            }
            .extraContent {
                if extraContent {
                    ContentBadge(variant: .outlined, text: "서울")
                    ContentBadge(variant: .outlined, text: "5년차")
                }
            }
            .textEllipsis(textEllipsis)
            .divider(divider)
            .disable(disable)
            .interactionOutset(interactionOutset)
            .interactionRadius(interactionRadius)
            .selected(selected)
            .if(!highlightText.isEmpty) {
                $0.highlight(highlightText)
            }
        } options: {
            SegmentedIndexRow("Vertical Padding", index: $verticalPaddingIndex, labels: verticalPaddings.map(\.description))
            if isCustomVerticalPadding {
                SliderOptionRow("Custom Vertical Padding", value: $customVerticalPadding, in: 0...40, step: 1, format: { "\(Int(Double($0)))pt" })
            }
            HStack {
                ToggleOption("Description", isOn: $description)
                ToggleOption("Chevron", isOn: $chevron)
                ToggleOption("Divider", isOn: $divider)
            }
            HStack {
                ToggleOption("Leading Content", isOn: $leadingContent)
                ToggleOption("+ 다중", isOn: $multipleLeadingContent)
            }
            HStack {
                ToggleOption("Trailing Content", isOn: $trailingContent)
                ToggleOption("+ 다중", isOn: $multipleTrailingContent)
            }
            HStack {
                ToggleOption("Label Trailing", isOn: $labelTrailingContent)
                ToggleOption("Extra Content", isOn: $extraContent)
            }
            HStack {
                ToggleOption("Text Ellipsis", isOn: $textEllipsis)
                ToggleOption("Long Text", isOn: $longText)
            }
            HStack {
                ToggleOption("Disable", isOn: $disable)
                ToggleOption("Selected", isOn: $selected)
            }
            SegmentedIndexRow("Vertical Alignment", index: $verticalAlignmentIndex, labels: verticalAlignments.map(\.description))
            SliderOptionRow("Interaction Outset", value: $interactionOutset, in: 0...20, step: 1, format: { "\(Int(Double($0)))pt" })
            SliderOptionRow("Interaction Radius", value: $interactionRadius, in: 0...20, step: 1, format: { "\(Int(Double($0)))pt" })
            TextFieldOptionRow("Highlight Text", text: $highlightText)
        }
    }
}

extension ListCell.VerticalPadding: CaseDescribable {}
extension ListCell.VerticalAlign: CaseDescribable {}

#Preview {
    ListCellPreview()
}
