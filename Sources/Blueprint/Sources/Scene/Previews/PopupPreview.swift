//
//  PopupPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import Montage
import SwiftUI

struct PopupPreview: View {
    @State private var show = false

    @State private var itemCountsIndex: Int = 0

    @State private var resize: Popup.Resize = .hug
    @State private var navigation = true
    @State private var navVariantIndex = 0

    @State private var actionArea = true
    @State private var buttonsIndex = 0
    @State private var caption = false
    @State private var extra = false
    @State private var extraDivider = true

    var body: some View {
        PreviewLayout {
            Button(variant: .outlined, text: "Show Preview") {
                show.toggle()
            }
        } options: {
            HStack {
                SegmentedIndexRow(index: $itemCountsIndex, labels: itemCounts.map { "\($0)" })
                Text("items")
            }

            SegmentedIndexRow("resize", index: Binding(
                get: { if case .hug = resize { 0 } else { 1 } },
                set: { resize = $0 == 0 ? .hug : .fixed(300) }
            ), labels: ["hug", "fixed(300)"])
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
                        Spacer()
                    }
                    if actionArea {
                        SegmentedIndexRow(index: $buttonsIndex, labels: ActionAreaButtons.allCases.map(\.rawValue))
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
        .onAppear {
            show = true
        }
        .popup(
            isPresented: $show,
            resize: resize,
            actionAreaModel: actionArea
                ? .init(
                    variant: actionAreaVariant,
                    caption: caption ? "caption" : nil,
                    extra: {
                        if extra {
                            Rectangle().fill(
                                SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.08)
                            )
                            .frame(height: 50)
                        }
                    },
                    extraDivider: extraDivider
                )
                : nil,
            {
                VStack {
                    ForEach(0..<itemCounts[itemCountsIndex], id: \.self) { index in
                        HStack {
                            Text("Item \(index)")
                            TextField(text: .constant(""))
                        }
                    }
                }
                .background(SwiftUI.Color.semantic(.backgroundNormal))
            },
            navigation: navigation
                ? {
                    ModalNavigation()
                        .variant(navigationVariants[navVariantIndex])
                        .title("제목")
                        .leadingContent {
                            TopNavigation.LeadingButton(
                                .back(action: {})
                            )
                        }
                        .trailingContents(
                            [
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
                                },
                            ]
                        )
                }
                : nil
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

    private var itemCounts = [1, 5, 20]

    private enum ActionAreaButtons: String, CaseIterable {
        case main
        case mainAndSub = "main/sub"
        case mainSubAndAlternative = "main/sub/alt"
    }
}

extension Popup.Resize: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .hug:
            hasher.combine(0)
        case .fixed(let height):
            hasher.combine(1)
            hasher.combine(height)
        @unknown default:
            break
        }
    }

    public static func == (lhs: Popup.Resize, rhs: Popup.Resize) -> Bool {
        switch (lhs, rhs) {
        case (.hug, .hug): return true
        case (.fixed(let l), .fixed(let r)): return l == r
        default: return false
        }
    }
}

#Preview {
    PopupPreview()
}
