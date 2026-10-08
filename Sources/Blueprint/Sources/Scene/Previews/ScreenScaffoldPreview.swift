//
//  ScreenScaffoldPreview.swift
//  Blueprint
//
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct ScreenScaffoldPreview: View {
    @State private var itemCountIndex = 1
    @State private var scrollContainerIndex = 0
    @State private var navigation = true
    @State private var actionArea = true
    @State private var actionAreaSub = false
    @State private var actionAreaCaption = false
    @State private var backgroundColor: SwiftUI.Color = .semantic(.backgroundNeutralPrimary)

    @Environment(\.presentationMode) private var presentationMode

    /// 항목 1개는 스크롤이 생기지 않는 화면이다. ``ActionArea``가 자리를 어떻게 잡는지 대조하는 기준.
    private let itemCounts = [1, 3, 30]

    var body: some View {
        // .navigation 모드: PreviewLayout이 NavigationView·push 버튼·체커 적용까지 담당한다.
        PreviewLayout(mode: .navigation) {
            preview
        } options: {
            HStack {
                SegmentedIndexRow(index: $itemCountIndex, labels: itemCounts.map { "\($0)" })
                Text("items")
            }
            SegmentedIndexRow(
                "scrollContainer",
                index: $scrollContainerIndex,
                labels: ["builtIn", "custom"]
            )
            HStack {
                ToggleOption("navigation", isOn: $navigation)
                ToggleOption("actionArea", isOn: $actionArea)
                Spacer(minLength: 0)
            }
            if actionArea {
                HStack {
                    ToggleOption("sub", isOn: $actionAreaSub)
                    ToggleOption("caption", isOn: $actionAreaCaption)
                    Spacer(minLength: 0)
                }
            }
            ColorPickerOptionRow("backgroundColor", selection: $backgroundColor)
        }
    }

    var preview: some View {
        ScreenScaffold(
            scrollContainer: scrollContainerIndex == 0 ? .builtIn : .custom,
            navigation: navigation ? navigationSlot : nil,
            actionArea: actionArea ? actionAreaSlot : nil,
            {
                content
            }
        )
        .backgroundColor(backgroundColor)
    }
}

// MARK: - Slots

private extension ScreenScaffoldPreview {
    @ViewBuilder
    var content: some View {
        switch scrollContainerIndex {
        case 0:
            // 스캐폴드가 ScrollView를 깔아 주므로 콘텐츠는 스크롤을 신경 쓰지 않는다.
            itemList
                .padding(.horizontal, 20)
                // 체커를 스크롤 콘텐츠에 붙여 함께 움직이게 한다(콘텐츠 범위가 드러난다).
                .previewCheckered()

        default:
            // List는 스크롤을 스스로 쥐므로 신호를 직접 올린다.
            List {
                ForEach(0..<itemCounts[itemCountIndex], id: \.self) { index in
                    ListCell(label: "Item \(index)")
                        // 하단 도달 신호는 iOS 18 미만에서 이 마커를 근거로 삼는다.
                        .scrollContentBottomMarker(isLast: index == itemCounts[itemCountIndex] - 1)
                        // List는 행 단위로만 배경을 줄 수 있어 체커도 행마다 건다. ScrollView처럼
                        // 격자가 콘텐츠 전체로 이어지지는 않지만, 행과 함께 움직인다.
                        .previewCheckered()
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                // List는 행 배경과 스크롤 배경을 각각 깐다. 둘 다 걷어내지 않으면 스캐폴드
                // 배경색이 가려져, ActionArea가 투명해지는 구간에서 경계로 드러난다.
                .listRowBackground(SwiftUI.Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .reportsScrollReachedEnd()
            // 오프셋 수정자는 iOS 18 이상이라, 그 아래에서는 TopNavigation 배경이 불투명으로 고정된다.
            .modifying { view in
                if #available(iOS 18, *) {
                    view.reportsScrollOffset()
                } else {
                    view
                }
            }
        }
    }

    var itemList: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<itemCounts[itemCountIndex], id: \.self) { index in
                ListCell(label: "Item \(index)")
            }
        }
    }

    var navigationSlot: () -> TopNavigation {
        {
            TopNavigation()
                .title("제목")
                .leadingContent {
                    TopNavigation.LeadingButton(
                        .back(action: { presentationMode.wrappedValue.dismiss() })
                    )
                }
        }
    }

    var actionAreaSlot: () -> ActionArea {
        {
            ActionArea(
                variant: .strong(
                    main: .init(text: "메인", action: {}),
                    sub: actionAreaSub ? .init(text: "서브", action: {}) : nil
                )
            )
            .caption(actionAreaCaption ? "캡션" : nil)
        }
    }
}

#Preview {
    ScreenScaffoldPreview()
}
