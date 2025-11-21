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
    @State private var showTransparentChecker: Bool = false
    @State private var showSheet: Bool = false
    @State private var negative: Bool = false
    @State private var variantIndex: Int = 0
    @State private var selectionTypeIndex: Int = 0
    @State private var menuActionArea: Bool = false
    @State private var menuButtonTitle: String = "확인"
    @State private var renderIndex: Int = 0
    @State private var overflow: Bool = false
    @State private var disable: Bool = false
    @State private var description: Bool = false
    @State private var heading: Bool = false
    @State private var requiredBadge: Bool = false
    @State private var leadingContentIndex: Int = 0
    @State private var customMenu: Bool = false
    @State private var menuResizeIndex = 0
    @State private var itemCountClassIndex: Int = 0

    private let selectionTypes: [Select.SingleSelectionType] = [.checkmark, .radio]
    private let renders: [Select.Render] = [.text, .chip]
    
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
            .iconButton(.init(icon: .send)),
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
                Select(
                    menuPresented: customMenu ? $showSheet : nil,
                    variant: variants[variantIndex],
                    items: $items
                ) {
                    print($0.text)
                }
                .negative(negative)
                .placeholder("선택해 주세요.")
                .disable(disable)
                .description(description ? "설명을 적습니다." : "")
                .heading(heading ? "제목" : "")
                .requiredBadge(requiredBadge)
                .leadingContent(leadingContents[leadingContentIndex])
                .menuResize(bottomSheetResizes[menuResizeIndex])
                .bottomSheet(isPresented: $showSheet) {
                    VStack {
                        ForEach(items.indices, id: \.self) { index in
                            ListCell(title: items[index].text) {
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
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Options").bold()

                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        labels: variants.map(\.description)
                    )
                    .size(.small)
                }
                switch variants[variantIndex] {
                case .single:
                    HStack {
                        Text("selectionType")
                        SegmentedControl(
                            selectedIndex: $selectionTypeIndex,
                            labels: selectionTypes.map(\.description)
                        )
                        .size(.small)
                    }
                    HStack {
                        Text("menuActionArea")
                        Switch(checked: menuActionArea) { menuActionArea = $0 }
                    }
                    if menuActionArea {
                        HStack {
                            Text("menuButtonTitle")
                            TextField(text: $menuButtonTitle)
                        }
                    }
                case .multiple:
                    HStack {
                        Text("render")
                        SegmentedControl(
                            selectedIndex: $renderIndex,
                            labels: renders.map(\.description)
                        )
                        .size(.small)
                        Text("overflow")
                        Switch(checked: overflow) { overflow = $0 }
                    }
                    HStack {
                        Text("menuButtonTitle")
                        TextField(text: $menuButtonTitle)
                    }
                @unknown default:
                    EmptyView()
                }
                HStack {
                    Text("heading")
                    Switch(checked: heading) { heading = $0 }
                    Text("requiredBadge")
                    Switch(checked: requiredBadge) { requiredBadge = $0 }
                }
                HStack {
                    Text("negative")
                    Switch(checked: negative) { negative = $0 }
                    Text("disable")
                    Switch(checked: disable) { disable = $0 }
                    Text("description")
                    Switch(checked: description) { description = $0 }
                }
                HStack {
                    Text("leadingContent")
                    SegmentedControl(
                        selectedIndex: $leadingContentIndex,
                        labels: leadingContents.map { $0?.description ?? "none" }
                    )
                    .size(.small)
                }
                HStack {
                    Text("custom menu")
                    Switch(checked: customMenu) { customMenu = $0 }
                }
                HStack {
                    Text("menuResize")
                    SegmentedControl(selectedIndex: $menuResizeIndex, labels: bottomSheetResizes.map(\.description))
                        .size(.small)
                }
                HStack {
                    SegmentedControl(selectedIndex: $itemCountClassIndex, labels: ItemCountClass.allCases.map(\.rawValue))
                        .size(.small)
                    Text("items")
                }
            }
            .padding(.horizontal)
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .navigationTitle("Select/Multiple")
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
extension Select.SingleSelectionType: CaseDescribable {}
extension Select.Render: CaseDescribable {}
extension Select.LeadingContent: CaseDescribable {}

#Preview {
    SelectPreview()
}
