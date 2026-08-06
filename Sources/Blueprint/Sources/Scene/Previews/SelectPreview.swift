//
//  SelectPreview.swift
//  Blueprint
//
//  Created by Sanghoon Ahn on 8/13/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct SelectPreview: View {
    @State private var showSheet: Bool = false
    @State private var negative: Bool = false
    @State private var variantIndex: Int = 0
    @State private var selectionTypeIndex: Int = 0
    @State private var menuActionArea: Bool = false
    @State private var menuButtonTitle: String = "확인"
    @State private var renderIndex: Int = 0
    @State private var overflow: Bool = false
    @State private var disable: Bool = false
    @State private var leadingContentIndex: Int = 0
    @State private var customMenu: Bool = false
    @State private var menuResizeIndex = 0
    @State private var itemCountClassIndex: Int = 0
    @State private var sizeIndex: Int = 0

    private let selectionTypes: [Select.SingleSelectionType] = [.checkmark, .radio]
    private let renders: [Select.Render] = [.text, .chip]
    private let sizes: [Select.Size] = [.large, .medium]

    private var variants: [Select.Variant] {
        [
            .single(selectionType: selectionTypes[selectionTypeIndex], menuPrimaryButtonTitle: menuActionArea ? menuButtonTitle : nil),
            .multiple(render: renders[renderIndex], overflow: overflow, menuPrimaryButtonTitle: menuButtonTitle)
        ]
    }

    private var leadingContents: [Select.LeadingContent?] {
        [
            .none,
            .icon(.send),
            // leading 아이콘 버튼은 Select 사이즈에 맞춰 large/medium을 사용한다.
            .iconButton(.init(variant: .normal(size: sizes[sizeIndex] == .large ? .large : .medium), icon: .send)),
            .custom({
                Text("이력서")
            }),
        ]
    }

    private let bottomSheetResizes: [BottomSheet.Resize] = [
        .hug,
        .fixedRatio(0.6),
        .fixedHeight(200),
        .flexible,
        .fill
    ]

    private enum ItemCountClass: String, CaseIterable {
        case few, medium, many

        var description: String {
            self.rawValue
        }
    }

    @State private var items: [Select.Item] = [
        .init(text: "값1"),
        .init(text: "값2(icon)", icon: .apps),
        .init(text: "값3(negative)", isNegative: true)
    ]

    var body: some View {
        PreviewLayout {
            Select(
                menuPresented: customMenu ? $showSheet : nil,
                variant: variants[variantIndex],
                items: $items
            ) {
                print($0.text)
            }
            .size(sizes[sizeIndex])
            .negative(negative)
            .placeholder("선택해 주세요.")
            .disable(disable)
            .leadingContent(leadingContents[leadingContentIndex])
            .menuResize(bottomSheetResizes[menuResizeIndex])
            .bottomSheet(isPresented: $showSheet) {
                VStack {
                    ForEach(items.indices, id: \.self) { index in
                        ListCell(label: items[index].text) {
                            switch variants[variantIndex] {
                            case .single:
                                items = items.map {
                                    var mutated = $0
                                    mutated.isSelected = false
                                    return mutated
                                }
                                fallthrough
                            case .multiple:
                                items[index].isSelected.toggle()
                            @unknown default:
                                break
                            }
                        }
                        .selected(items[index].isSelected)
                        .trailingContent { active in
                            Checkmark(checked: active)
                        }
                    }
                }
            }
        } options: {
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            switch variants[variantIndex] {
            case .single:
                SegmentedIndexRow("selectionType", index: $selectionTypeIndex, labels: selectionTypes.map(\.description))
                ToggleOptionRow("menuActionArea", isOn: $menuActionArea)
                if menuActionArea {
                    TextFieldOptionRow("menuButtonTitle", text: $menuButtonTitle)
                }
            case .multiple:
                HStack {
                    SegmentedIndexRow("render", index: $renderIndex, labels: renders.map(\.description))
                    ToggleOption("overflow", isOn: $overflow)
                }
                TextFieldOptionRow("menuButtonTitle", text: $menuButtonTitle)
            @unknown default:
                EmptyView()
            }
            HStack {
                ToggleOption("negative", isOn: $negative)
                ToggleOption("disable", isOn: $disable)
            }
            SegmentedIndexRow("leadingContent", index: $leadingContentIndex, labels: leadingContents.map { $0?.description ?? "none" })
            ToggleOptionRow("custom menu", isOn: $customMenu)
                // 커스텀 메뉴를 끄면 항상 살아 있는 bottomSheet가 남지 않도록 함께 닫는다.
                .onChange(of: customMenu) { enabled in
                    if !enabled { showSheet = false }
                }
            SegmentedIndexRow("menuResize", index: $menuResizeIndex, labels: bottomSheetResizes.map(\.description))
            HStack {
                SegmentedIndexRow(index: $itemCountClassIndex, labels: ItemCountClass.allCases.map(\.rawValue))
                Text("items")
            }
        }
        .onChange(of: itemCountClassIndex) { _ in
            switch ItemCountClass.allCases[itemCountClassIndex] {
            case .few:
                items = [
                    .init(text: "값1"),
                    .init(text: "값2(icon)", icon: .apps),
                    .init(text: "값3(negative)", isNegative: true)
                ]
            case .medium:
                items = [
                    .init(text: "값1"),
                    .init(text: "값2(icon)", icon: .apps),
                    .init(text: "값3(negative)", isNegative: true),
                    .init(text: "값4"),
                    .init(text: "값5"),
                    .init(text: "값6"),
                    .init(text: "값7"),
                    .init(text: "값8"),
                    .init(text: "아이콘", icon: .apps),
                    .init(text: "negative", isNegative: true)
                ]
            case .many:
                items = [
                    .init(text: "값1"),
                    .init(text: "값2(icon)", icon: .apps),
                    .init(text: "값3(negative)", isNegative: true),
                    .init(text: "값4"),
                    .init(text: "값5"),
                    .init(text: "값6"),
                    .init(text: "값7"),
                    .init(text: "값8"),
                    .init(text: "값9"),
                    .init(text: "값10"),
                    .init(text: "값11"),
                    .init(text: "값12"),
                    .init(text: "값13"),
                    .init(text: "값14"),
                    .init(text: "아이콘", icon: .apps),
                    .init(text: "negative", isNegative: true)
                ]
            }
        }
    }
}

extension Select.Variant: CaseDescribable {}
extension Select.Size: CaseDescribable {}
extension Select.SingleSelectionType: CaseDescribable {}
extension Select.Render: CaseDescribable {}
extension Select.LeadingContent: CaseDescribable {}

#Preview {
    SelectPreview()
}
