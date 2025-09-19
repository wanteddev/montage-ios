//
//  PopupModalPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI
import Montage

struct PopupModalPreview: View {
    @State private var show = false

    @State private var itemCountsIndex: Int = 0
    
    @State private var resize: PopupModal.Resize = .hug
    @State private var navigation = true
    @State private var navVariantIndex = 0
    
    @State private var actionArea = true
    @State private var buttonsIndex = 0
    @State private var caption = false
    @State private var extra = false
    @State private var extraDivider = true
    
    @State private var refreshTask: Task<(), Never>?

    var body: some View {
        SwiftUI.ScrollView {
            SwiftUI.Button("PUSH") {
                show = true
            }
            VStack(alignment: .leading) {
                Text("Options").bold()
                HStack {
                    SegmentedControl(selectedIndex: $itemCountsIndex, labels: itemCounts.map { "\($0)" })
                        .size(.small)
                    Text("items")
                }
                
                HStack {
                    Text("resize")
                    Picker("resize", selection: $resize) {
                        Text("hug").tag(PopupModal.Resize.hug)
                        Text("fixed(300)").tag(PopupModal.Resize.fixed(300))
                    }
                    .pickerStyle(.segmented)
                }
                HStack {
                    Text("navigation")
                    Switch($navigation)
                    if navigation {
                        SegmentedControl(selectedIndex: $navVariantIndex, labels: navigationVariants.map(\.description))
                            .size(.small)
                    }
                }
                
                HStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("actionArea")
                            Switch($actionArea)
                            Spacer()
                        }
                        if actionArea {
                            SegmentedControl(selectedIndex: $buttonsIndex, labels: ActionAreaButtons.allCases.map(\.rawValue))
                                .size(.small)
                            HStack {
                                Text("caption")
                                Switch($caption)
                                Text("extra")
                                Switch($extra)
                                if extra {
                                    Text("divider")
                                    Switch($extraDivider)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onChange(of: "\(resize)\(navigation)\(navVariantIndex)\(actionArea)\(buttonsIndex)\(caption)\(extra)\(extraDivider)\(itemCountsIndex)") { _ in
                refreshTask?.cancel()
                refreshTask = Task {
                    do {
                        try await Task.sleep(for: .seconds(1))
                        try Task.checkCancellation()
                        show = true
                    } catch {
                    }
                }
            }
            .font(.caption)
        }
        .popupModal(
            isPresented: $show,
            resize: resize,
            actionAreaModel: actionArea
            ? .init(
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
                    .title({
                        ModalNavigation.TitleView(
                            variant: navigationVariants[navVariantIndex],
                            title: "제목"
                        )
                    })
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
                            }
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
                    main: .init(text: "눌러봐요", action: {
                        show = false
                    })
                )
        case .mainAndSub:
                .strong(
                    main: .init(text: "눌러봐요", action: {
                        show = false
                    }),
                    sub: .init(text: "취소", action: {
                        show = false
                    })
                )
        case .mainSubAndAlternative:
                .strong(
                    main: .init(text: "눌러봐요", action: {
                        show = false
                    }),
                    sub: .init(text: "취소", action: {
                        show = false
                    }),
                    alternative: .init(text: "대체", action: {
                        show = false
                    })
                )
        }
    }
    
    private let navigationVariants: [ModalNavigation.Variant] = [
        .normal,
        .extended,
        .emphasized,
        .floating(alternative: true, background: true)
    ]
    
    private var itemCounts = [1, 5, 20]
    
    private enum ActionAreaButtons: String, CaseIterable {
        case main
        case mainAndSub = "main/sub"
        case mainSubAndAlternative = "main/sub/alt"
    }
}

extension PopupModal.Resize: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .hug:
            hasher.combine(0)
        case .fixed(let height):
            hasher.combine(1)
            hasher.combine(height)
        }
    }
    
    public static func == (lhs: PopupModal.Resize, rhs: PopupModal.Resize) -> Bool {
        switch (lhs, rhs) {
        case (.hug, .hug): return true
        case (.fixed(let l), .fixed(let r)): return l == r
        default: return false
        }
    }
}

#Preview {
    PopupModalPreview()
}
