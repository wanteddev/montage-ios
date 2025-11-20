//
//  ListCellPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/13/24.
//

import SwiftUI
import Montage

struct ListCellPreview: View {
    @State private var showTransparentChecker: Bool = false
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
                    Switch(checked: caption) { caption = $0 }
                    Text("Fill Width")
                    Switch(checked: fillWidth) { fillWidth = $0 }
                    Text("Chevron")
                    Switch(checked: chevron) { chevron = $0 }
                }
                HStack {
                    Text("Leading Content")
                    Switch(checked: leadingContent) { leadingContent = $0 }
                    Text("Trailing Content")
                    Switch(checked: trailingContent) { trailingContent = $0 }
                }
                HStack {
                    Text("Text Ellipsis")
                    Switch(checked: textEllipsis) { textEllipsis = $0 }
                    Text("Divider")
                    Switch(checked: divider) { divider = $0 }
                }
                HStack {
                    Text("Disable")
                    Switch(checked: disable) { disable = $0 }
                    Text("Long Text")
                    Switch(checked: longText) { longText = $0 }
                    Text("Selected")
                    Switch(checked: selected) { selected = $0 }
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
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension ListCell.VerticalPadding: CaseDescribable {}

#Preview {
    ListCellPreview()
}
