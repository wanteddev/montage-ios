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

    /// 리스트 예시에 담는 셀 수.
    private static let listSampleCount = 2

    /// 리스트 예시가 `inset` 셀에 주는 좌우 여백. 4.0.0 스펙의 리스트 여백과 같은 값이다.
    private static let listHorizontalPadding: CGFloat = 20

    /// 슬롯에 담은 요소 하나.
    ///
    /// 만들어진 `Resource` 대신 프리셋 번호를 들고 있다가 렌더마다 다시 만든다.
    /// checkbox·radio·switch는 `checked`를 `Binding`이 아닌 `Bool`로 받으므로 `Resource` 값을
    /// 그대로 저장하면 담은 시점의 `checked`가 굳어 탭해도 외관이 바뀌지 않는다.
    ///
    /// `checked`를 프리셋이 아니라 이 항목에 두는 이유는 같은 프리셋을 여러 번 담을 수 있기 때문이다.
    /// 상태를 프리셋 쪽에 두면 checkbox 두 개가 한 값을 공유해 하나를 눌렀을 때 둘이 같이 바뀐다.
    private struct SlotItem: Identifiable {
        let id = UUID()
        let presetIndex: Int
        var checked = false
    }

    @State private var description = false
    @State private var verticalPaddingIndex = 1
    @State private var customVerticalPadding: CGFloat = 24
    @State private var chevron = false
    @State private var verticalAlignmentIndex = 0
    @State private var textEllipsis = false
    @State private var divider = false
    @State private var disable = false
    @State private var longText = false
    @State private var variantIndex = 0
    @State private var selected = false
    @State private var highlightText: String = ""

    @State private var leadingItems: [SlotItem] = []
    @State private var labelTrailingItems: [SlotItem] = []
    @State private var trailingItems: [SlotItem] = []
    @State private var extraItems: [SlotItem] = []

    var verticalPaddings: [ListCell.VerticalPadding] {
        [.none, .small, .medium, .large, .custom(customVerticalPadding)]
    }

    var isCustomVerticalPadding: Bool {
        if case .custom = verticalPaddings[verticalPaddingIndex] { true } else { false }
    }

    let verticalAlignments: [ListCell.VerticalAlign] = [.top, .center]

    let variants: [ListCell.Variant] = [.inset, .full]

    var labelText: String {
        longText ? "이것은 세 줄 이상으로 표현될 수 있는 긴 문장입니다. 충분히 길어야 줄 바꿈이 됩니다. 더욱 더 많이 길어야 합니다." : "텍스트"
    }

    var descriptionText: String {
        longText ? "이것은 두 줄 이상으로 표현될 수 있는 긴 설명입니다. 충분히 길어야 줄 바꿈이 됩니다." : "설명"
    }

    // 각 슬롯의 프리셋은 enum case를 하나씩 빠짐없이 담는다. 상태를 가지는 case는 항목의
    // checked·onSelect를 받아 만들고, 나머지는 인자를 무시한다.
    // slot(_:)에 넣은 뷰는 셀 스펙에 맞춘 크기 제약을 받지 않으므로 frame으로 직접 크기를 정해
    // 행 높이가 밀리지 않게 한다.

    @ViewBuilder
    private var slotSampleView: some View {
        Image(systemName: "star.fill")
            .foregroundColor(.semantic(.foregroundBrandPrimary))
            .frame(width: 22, height: 22)
    }

    private func leadingPreset(
        _ index: Int,
        checked: Bool = false,
        onSelect: ((Bool) -> Void)? = nil
    ) -> ListCell.Resource.Leading {
        switch index {
        case 0: return .icon(.check)
        case 1: return .largeIcon(.check)
        case 2: return .checkbox(checked: checked, onSelect: onSelect)
        case 3: return .radio(checked: checked, onSelect: onSelect)
        case 4: return .avatar("", variant: .person)
        case 5: return .thumbnail("")
        default: return .slot { slotSampleView }
        }
    }

    private func labelTrailingPreset(_ index: Int) -> ListCell.Resource.LabelTrailing {
        switch index {
        case 0: return .contentBadge(title: "배지")
        case 1: return .icon(.check)
        default: return .slot { slotSampleView }
        }
    }

    private func trailingPreset(
        _ index: Int,
        checked: Bool = false,
        onSelect: ((Bool) -> Void)? = nil
    ) -> ListCell.Resource.Trailing {
        switch index {
        case 0: return .value("값")
        case 1: return .icon(.chevronRight)
        case 2: return .iconButton(.chevronRight, handler: {})
        case 3: return .textButton(title: "텍스트", handler: {})
        case 4: return .button(title: "버튼", handler: {})
        case 5: return .contentBadge(title: "배지")
        case 6: return .switch(checked: checked, onSelect: onSelect)
        default: return .slot { slotSampleView }
        }
    }

    private func extraPreset(_ index: Int) -> ListCell.Resource.Extra {
        switch index {
        case 0: return .text("텍스트")
        case 1: return .contentBadge(.outlined, title: "서울")
        default: return .slot { slotSampleView }
        }
    }

    // 메뉴에 띄울 이름. 프리셋 목록을 두 번 적지 않도록 빌더에서 뽑아 쓴다.
    var leadingLabels: [String] { (0..<7).map { leadingPreset($0).description } }
    var labelTrailingLabels: [String] { (0..<3).map { labelTrailingPreset($0).description } }
    var trailingLabels: [String] { (0..<8).map { trailingPreset($0).description } }
    var extraLabels: [String] { (0..<3).map { extraPreset($0).description } }

    var leadingResourceList: [ListCell.Resource.Leading] {
        leadingItems.map { item in
            leadingPreset(item.presetIndex, checked: item.checked) { newValue in
                setChecked(newValue, for: item.id, in: $leadingItems)
            }
        }
    }

    var labelTrailingResourceList: [ListCell.Resource.LabelTrailing] {
        labelTrailingItems.map { labelTrailingPreset($0.presetIndex) }
    }

    var trailingResourceList: [ListCell.Resource.Trailing] {
        trailingItems.map { item in
            trailingPreset(item.presetIndex, checked: item.checked) { newValue in
                setChecked(newValue, for: item.id, in: $trailingItems)
            }
        }
    }

    var extraResourceList: [ListCell.Resource.Extra] {
        extraItems.map { extraPreset($0.presetIndex) }
    }

    var body: some View {
        PreviewLayout {
            VStack(alignment: .leading, spacing: 8) {
                caption("Single")
                cell(divider: divider)

                caption("In List")
                listSample
            }
        } options: {
            SegmentedIndexRow("Variant", index: $variantIndex, labels: variants.map(\.description))
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
                slotMenu("Leading", labels: leadingLabels, items: $leadingItems)
                slotMenu("Label Trailing", labels: labelTrailingLabels, items: $labelTrailingItems)
            }
            HStack {
                slotMenu("Trailing", labels: trailingLabels, items: $trailingItems)
                slotMenu("Extra", labels: extraLabels, items: $extraItems)
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
            TextFieldOptionRow("Highlight Text", text: $highlightText)
        }
    }

    /// 옵션을 그대로 반영한 셀 하나.
    ///
    /// 낱개 미리보기와 리스트 예시가 같은 설정을 쓰도록 한곳에서 만든다.
    private func cell(divider: Bool) -> some View {
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
        .variant(variants[variantIndex])
        .selected(selected)
        .if(!highlightText.isEmpty) {
            $0.highlight(highlightText)
        }
        .disabled(disable)
    }

    /// 셀을 리스트에 담았을 때의 모습.
    ///
    /// `variant`는 셀이 아니라 셀이 놓이는 리스트의 가장자리를 기준으로 정의되므로,
    /// 좌우 여백을 리스트가 주는 `inset`과 셀이 직접 갖는 `full`의 차이는 컨테이너에 담아야 드러난다.
    /// 여기서는 리스트 가장자리를 눈으로 확인할 수 있게 테두리를 둘렀다.
    private var listSample: some View {
        VStack(spacing: 0) {
            ForEach(0..<Self.listSampleCount, id: \.self) { index in
                // 마지막 셀 아래 구분선은 리스트 테두리와 겹치므로 그리지 않는다.
                cell(divider: divider && index < Self.listSampleCount - 1)
            }
        }
        // inset은 리스트가 좌우 여백을 주고, full은 셀이 직접 갖는다.
        .padding(.horizontal, variants[variantIndex] == .inset ? Self.listHorizontalPadding : 0)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(SwiftUI.Color.semantic(.lineNeutralPrimaryOpaque), lineWidth: 1)
        )
    }

    private func caption(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    /// 슬롯 하나의 프리셋을 골라 담는 메뉴. 항목을 누르면 추가되고, reset으로 비운다.
    ///
    /// 한 줄에 두 슬롯씩 나열하므로 행 단위인 `MenuOptionRow`가 아니라 인라인용 `MenuOption`을 쓴다.
    private func slotMenu(
        _ title: String,
        labels: [String],
        items: Binding<[SlotItem]>
    ) -> some View {
        MenuOption(title, menuLabel: "add") {
            ForEach(labels.indices, id: \.self) { index in
                Button {
                    let appended = items.wrappedValue + [SlotItem(presetIndex: index)]
                    items.wrappedValue = Array(appended.suffix(Self.slotCapacity))
                } label: {
                    Text(labels[index])
                }
            }
        } accessory: {
            Button("reset") { items.wrappedValue.removeAll() }
        }
    }

    private func setChecked(_ value: Bool, for id: UUID, in items: Binding<[SlotItem]>) {
        guard let index = items.wrappedValue.firstIndex(where: { $0.id == id }) else { return }
        items.wrappedValue[index].checked = value
    }
}

extension ListCell.Variant: CaseDescribable {}
extension ListCell.VerticalPadding: CaseDescribable {}
extension ListCell.VerticalAlign: CaseDescribable {}
extension ListCell.Resource.Leading: CaseDescribable {}
extension ListCell.Resource.LabelTrailing: CaseDescribable {}
extension ListCell.Resource.Trailing: CaseDescribable {}
extension ListCell.Resource.Extra: CaseDescribable {}

#Preview {
    ListCellPreview()
}
