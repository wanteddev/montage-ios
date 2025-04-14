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
    @State private var description: Bool = false
    @State private var heading: Bool = false
    @State private var requiredBadge: Bool = false
    @State private var leadingContentIndex: Int = 0
    @State private var customMenu: Bool = false
    @State private var menuResizeIndex = 0
    @State private var itemCountClassIndex: Int = 0

    private var variants: [Select.Variant] {
        [
            .single(selectionType: Select.SingleSelectionType.allCases[selectionTypeIndex], menuPrimaryButtonTitle: menuActionArea ? menuButtonTitle : nil),
            .multiple(render: Select.Render.allCases[renderIndex], overflow: overflow, menuPrimaryButtonTitle: menuButtonTitle)
        ]
    }
    
    private var leadingContents: [Select.LeadingContent?] {
        [
            .none,
            .icon(.send),
            .iconButton(.init(icon: .send)),
            .custom({
                Text("이력서")
            })
        ]
    }
    
    private let bottomSheetResizes: [Modal.BottomSheet.Resize] = [
        .hug,
        .fixedRatio(0.6),
        .fixedHeight(200),
        .flexible,
        .fill
    ]
    
    private enum ItemCountClass: String, CaseIterable {
        case few, medium, many
    }
    
    @State private var items: [Select.Item] = [
        .init(text: "값1"),
        .init(text: "값2"),
        .init(text: "값3")
    ]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack {
                HStack {
                    Text("Preview").bold()
                    Spacer()
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
                .bottomSheetModal(isPresented: $showSheet, {
                    VStack {
                        ForEach(items.indices, id: \.self) { index in
                            Cell(title: items[index].text) {
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
                                }
                            }
                            .active(items[index].isSelected)
                            .trailingContent { active in
                                Control.checkmark(checked: active)
                            }
                        }
                    }
                })
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Options").bold()
                
                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        items: variants.map { .init(title: $0.description)
                        }) { _ in }
                        .size(.small)
                }
                switch variants[variantIndex] {
                case .single:
                    HStack {
                        Text("selectionType")
                        SegmentedControl(
                            selectedIndex: $selectionTypeIndex,
                            items: Select.SingleSelectionType.allCases.map { .init(title: $0.rawValue)
                            }) { _ in }
                            .size(.small)
                    }
                    HStack {
                        Text("menuActionArea")
                        Control.Switch($menuActionArea)
                    }
                    if menuActionArea {
                        HStack {
                            Text("menuButtonTitle")
                            TextInput.TextField(text: $menuButtonTitle)
                        }
                    }
                case .multiple:
                    HStack {
                        Text("render")
                        SegmentedControl(
                            selectedIndex: $renderIndex,
                            items: Select.Render.allCases.map { .init(title: $0.rawValue)
                            }) { _ in }
                            .size(.small)
                        Text("overflow")
                        Control.Switch($overflow)
                    }
                    HStack {
                        Text("menuButtonTitle")
                        TextInput.TextField(text: $menuButtonTitle)
                    }
                }
                HStack {
                    Text("heading")
                    Control.Switch($heading)
                    Text("requiredBadge")
                    Control.Switch($requiredBadge)
                }
                HStack {
                    Text("negative")
                    Control.Switch($negative)
                    Text("disable")
                    Control.Switch($disable)
                    Text("description")
                    Control.Switch($description)
                }
                HStack {
                    Text("leadingContent")
                    SegmentedControl(
                        selectedIndex: $leadingContentIndex,
                        items: leadingContents.map { .init(title: $0?.description ?? "none")
                        }) { _ in }
                        .size(.small)
                }
                HStack {
                    Text("custom menu")
                    Control.Switch($customMenu)
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
        .navigationTitle("Select/Multiple")
        .onChange(of: itemCountClassIndex) { _ in
            switch ItemCountClass.allCases[itemCountClassIndex] {
            case .few:
                items = [
                    .init(text: "값1"),
                    .init(text: "값2"),
                    .init(text: "값3")
                ]
            case .medium:
                items = [
                    .init(text: "값1"),
                    .init(text: "값2"),
                    .init(text: "값3"),
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
                    .init(text: "값2"),
                    .init(text: "값3"),
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
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    SelectPreview()
}
