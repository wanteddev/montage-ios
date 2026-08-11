//
//  ListCellPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/13/24.
//

import SwiftUI
import Montage

struct ListCellPreview: View {
    /// 슬롯당 담을 수 있는 요소 수. `ListCell`은 개수를 제한하지 않지만,
    /// 프리뷰에서 무한히 쌓이면 셀이 화면을 넘어가므로 여기서만 상한을 둔다.
    private static let slotCapacity = 3

    @State private var description = false
    @State private var verticalPaddingIndex = 1
    @State private var customVerticalPadding: CGFloat = 24
    @State private var chevron = false
    @State private var verticalAlignmentIndex = 0
    @State private var textEllipsis = false
    @State private var divider = false
    @State private var disable = false
    @State private var longText = false
    @State private var interactionOutset: CGFloat = 12
    @State private var interactionRadius: CGFloat = 16
    @State private var selected = false
    @State private var highlightText: String = ""

    // 슬롯에 담은 요소는 "만들어진 Resource" 대신 프리셋 인덱스로 들고 있는다.
    // checkbox·radio·switch는 checked를 Binding이 아닌 Bool로 받으므로, Resource 값을
    // @State에 저장하면 담은 시점의 checked가 그대로 굳어 탭해도 외관이 바뀌지 않는다.
    // 인덱스만 저장하고 렌더마다 프리셋을 다시 만들면 아래 상태들이 그대로 반영된다.
    @State private var leadingSelection: [Int] = []
    @State private var labelTrailingSelection: [Int] = []
    @State private var trailingSelection: [Int] = []
    @State private var extraSelection: [Int] = []

    @State private var checkboxChecked = false
    @State private var radioChecked = false
    @State private var switchChecked = true

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

    // 각 슬롯의 프리셋은 enum case를 하나씩 빠짐없이 담는다.
    // slot(_:)에 넣은 뷰는 셀 스펙에 맞춘 크기 제약을 받지 않으므로 프리뷰에서도
    // frame으로 직접 크기를 정해 행 높이가 밀리지 않게 한다.

    var leadingPresets: [ListCell.Resource.Leading] {
        [
            .icon(.check),
            .largeIcon(.check),
            .checkbox(checked: checkboxChecked, onSelect: { checkboxChecked = $0 }),
            .radio(checked: radioChecked, onSelect: { radioChecked = $0 }),
            .avatar("", variant: .person),
            .thumbnail(""),
            .slot {
                Image(systemName: "star.fill")
                    .foregroundColor(.semantic(.foregroundBrandPrimary))
                    .frame(width: 22, height: 22)
            }
        ]
    }

    var labelTrailingPresets: [ListCell.Resource.LabelTrailing] {
        [
            .contentBadge(title: "배지"),
            .icon(.check, tintColor: .semantic(.surfaceBrandPrimary)),
            .slot {
                Image(systemName: "star.fill")
                    .foregroundColor(.semantic(.foregroundBrandPrimary))
                    .frame(width: 22, height: 22)
            }
        ]
    }

    var trailingPresets: [ListCell.Resource.Trailing] {
        [
            .value("값"),
            .icon(.chevronRight),
            .iconButton(.chevronRight, handler: {}),
            .textButton(title: "텍스트", handler: {}),
            .button(title: "버튼", handler: {}),
            .contentBadge(title: "배지"),
            .switch(checked: switchChecked, onSelect: { switchChecked = $0 }),
            .slot {
                Image(systemName: "star.fill")
                    .foregroundColor(.semantic(.foregroundBrandPrimary))
                    .frame(width: 22, height: 22)
            }
        ]
    }

    var extraPresets: [ListCell.Resource.Extra] {
        [
            .text("텍스트"),
            .contentBadge(.outlined, title: "서울"),
            .slot {
                Image(systemName: "star.fill")
                    .foregroundColor(.semantic(.foregroundBrandPrimary))
                    .frame(width: 22, height: 22)
            }
        ]
    }

    var leadingResourceList: [ListCell.Resource.Leading] {
        leadingSelection.map { leadingPresets[$0] }
    }

    var labelTrailingResourceList: [ListCell.Resource.LabelTrailing] {
        labelTrailingSelection.map { labelTrailingPresets[$0] }
    }

    var trailingResourceList: [ListCell.Resource.Trailing] {
        trailingSelection.map { trailingPresets[$0] }
    }

    var extraResourceList: [ListCell.Resource.Extra] {
        extraSelection.map { extraPresets[$0] }
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
            .leadingResources(leadingResourceList)
            .labelTrailingResources(labelTrailingResourceList)
            .trailingResources(trailingResourceList)
            .extraResources(extraResourceList)
            .textEllipsis(textEllipsis)
            .divider(divider)
            .interactionOutset(interactionOutset)
            .interactionRadius(interactionRadius)
            .selected(selected)
            .if(!highlightText.isEmpty) {
                $0.highlight(highlightText)
            }
            .disabled(disable)
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
                slotMenu("Leading", selection: $leadingSelection, presets: leadingPresets)
                slotMenu("Label Trailing", selection: $labelTrailingSelection, presets: labelTrailingPresets)
            }
            HStack {
                slotMenu("Trailing", selection: $trailingSelection, presets: trailingPresets)
                slotMenu("Extra", selection: $extraSelection, presets: extraPresets)
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

    /// 슬롯 하나의 프리셋을 골라 담는 메뉴. 항목을 누르면 추가되고, reset으로 비운다.
    ///
    /// 한 줄에 두 슬롯씩 나열하므로 행 단위인 `MenuOptionRow`가 아니라 인라인용 `MenuOption`을 쓴다.
    private func slotMenu<Preset: CaseDescribable>(
        _ title: String,
        selection: Binding<[Int]>,
        presets: [Preset]
    ) -> some View {
        MenuOption(title, menuLabel: "add") {
            ForEach(presets.indices, id: \.self) { index in
                Button {
                    selection.wrappedValue = Array((selection.wrappedValue + [index]).suffix(Self.slotCapacity))
                } label: {
                    Text(presets[index].description)
                }
            }
        } accessory: {
            Button("reset") { selection.wrappedValue.removeAll() }
        }
    }
}

extension ListCell.VerticalPadding: CaseDescribable {}
extension ListCell.VerticalAlign: CaseDescribable {}
extension ListCell.Resource.Leading: CaseDescribable {}
extension ListCell.Resource.LabelTrailing: CaseDescribable {}
extension ListCell.Resource.Trailing: CaseDescribable {}
extension ListCell.Resource.Extra: CaseDescribable {}

#Preview {
    ListCellPreview()
}
