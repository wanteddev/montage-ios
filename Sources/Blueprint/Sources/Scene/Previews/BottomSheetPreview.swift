//
//  BottomSheetPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/20/25.
//

import Montage
import SwiftUI

struct BottomSheetPreview: View {
    @State private var show = true

    @State private var isFullModal = false
    @State private var resizeIndex = 0
    @State private var itemCountsIndex: Int = 0
    @State private var fixedRatio: CGFloat = 0.6
    @State private var fixedHeight: CGFloat = 200
    @State private var handle = false

    @State private var navigation = false
    @State private var navVariantIndex = 0

    @State private var actionArea = false
    @State private var buttonsIndex = 0
    @State private var caption = false
    @State private var extra = false
    @State private var extraDivider = true

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        PreviewLayout {
            Button(variant: .outlined, text: "Show Preview") {
                show.toggle()
            }
        } options: {
            VStack(alignment: .leading) {
                ToggleOptionRow("fullModal", isOn: $isFullModal)
                SegmentedIndexRow("resize", index: $resizeIndex, labels: bottomSheetResizes.map(\.description))
                SegmentedIndexRow("item count", index : $itemCountsIndex, labels: itemCounts.map(\.description))
                switch bottomSheetResizes[resizeIndex] {
                case .fixedRatio:
                    SliderOptionRow("ratio", value: $fixedRatio, in: 0...1, step: 0.01, format: { String(format: "%.2f", Double($0)) })
                case .fixedHeight:
                    SliderOptionRow("height", value: $fixedHeight, in: 0...1000)
                default:
                    EmptyView()
                }
                ToggleOptionRow("handle", isOn: $handle)
                HStack {
                    ToggleOption("navigation", isOn: $navigation)
                    if navigation {
                        SegmentedIndexRow(index: $navVariantIndex, labels: navigationVariants.map(\.description))
                    }
                }
                
                HStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            ToggleOption("actionArea", isOn: $actionArea)
                            if actionArea {
                                SegmentedIndexRow(index: $buttonsIndex, labels: ActionAreaButtons.allCases.map(\.rawValue))
                            }
                        }
                        if actionArea {
                            HStack {
                                ToggleOption("caption", isOn: $caption)
                                ToggleOption("extra", isOn: $extra)
                                if extra {
                                    ToggleOption("divider", isOn: $extraDivider)
                                }
                            }
                        }
                    }
                }
            }
        }
        .bottomSheet(
            isPresented: $show,
            isFullScreenCover: isFullModal,
            needHandle: handle,
            resize: bottomSheetResizes[resizeIndex],
            actionAreaModel: actionArea ? actionAreaModel : nil,
            navigation: navigation ? { navigationContent } : nil,
            { modalContent }
        )
        .onChange(of: isFullModal) { _ in
            show = false
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.6))
                show = true
            }
        }
    }

    private var navigationContent: ModalNavigation {
        ModalNavigation()
            .variant(navigationVariants[navVariantIndex])
            .title("제목")
            .leadingContent {
                TopNavigation.LeadingButton(.back(action: {}))
            }
            .trailingContents(
                {
                    TopNavigation.TrailingIconButton(
                        icon: .plus,
                        action: {}
                    )
                },
                {
                    TopNavigation.TrailingIconButton(
                        icon: .minus,
                        action: {}
                    )
                },
                {
                    TopNavigation.TrailingIconButton(
                        icon: .close,
                        action: {
                            show = false
                        }
                    )
                }
            )
    }

    private var modalContent: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                Text("Color List").font(.largeTitle)
                    .frame(maxWidth: .infinity)
            }
            ForEach(0..<itemCounts[itemCountsIndex], id: \.self) { index in
                ZStack {
                    let color = Color.Semantic.allCases[index % Color.Semantic.allCases.count]
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.semantic(color))
                    Text(color.rawValue)
                        .padding(2)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.semantic(.staticWhite).opacity(0.5))
                        }
                }
                .frame(height: 48)
            }
            .border(.black)
        }
    }

    private var actionAreaModel: ActionArea.Model {
        .init(
            variant: actionAreaVariant,
            caption: caption ? "caption" : nil,
            extra: {
                if extra {
                    Rectangle().fill(SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.08))
                        .frame(height: 50)
                }
            },
            extraDivider: extraDivider
        )
    }

    private var actionAreaVariant: ActionArea.Variant {
        switch ActionAreaButtons.allCases[buttonsIndex] {
        case .main:
            .strong(
                main: .init(
                    text: "눌러봐요",
                    action: {
                        show = false
                    })
            )
        case .mainAndSub:
            .strong(
                main: .init(
                    text: "눌러봐요",
                    action: {
                        show = false
                    }),
                sub: .init(
                    text: "취소",
                    action: {
                        show = false
                    })
            )
        case .mainSubAndAlternative:
            .strong(
                main: .init(
                    text: "눌러봐요",
                    action: {
                        show = false
                    }),
                sub: .init(
                    text: "취소",
                    action: {
                        show = false
                    }),
                alternative: .init(
                    text: "대체",
                    action: {
                        show = false
                    })
            )
        }
    }

    private let navigationVariants: [ModalNavigation.Variant] = [
        .normal,
        .display,
        .emphasized,
        .floating,
    ]

    private var bottomSheetResizes: [BottomSheet.Resize] {
        [
            .hug,
            .fixedRatio(fixedRatio),
            .fixedHeight(fixedHeight),
            .flexible,
            .fill,
        ]
    }

    private var itemCounts = [1, 5, 100]

    private enum ActionAreaButtons: String, CaseIterable {
        case main
        case mainAndSub = "main/sub"
        case mainSubAndAlternative = "main/sub/alt"
    }
}

extension BottomSheet.Resize: CaseDescribable {}

#Preview {
    BottomSheetPreview()
}
