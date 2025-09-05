//
//  FullModalPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI
import Montage

struct FullModalPreview: View {
    @State private var show = true
    
    @State private var itemCountsIndex: Int = 0
    
    @State private var navigation = true
    @State private var navVariantIndex = 0
    
    @State private var action = false
    @State private var buttonsIndex = 0
    @State private var caption = false
    @State private var extra = false
    @State private var extraDivider = true
    
    @State private var refreshTask: Task<(), Never>?
    
    var body: some View {
        SwiftUI.Button("PUSH") {
            show.toggle()
        }
        .fullModal(
            isPresented: $show,
            actionAreaModel: action
            ? .init(
                variant: variant,
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
                    VStack(alignment: .leading) {
                        Text("Options").bold()
                        HStack {
                            SegmentedControl(selectedIndex: $itemCountsIndex, labels: itemCounts.map(\.description))
                                .size(.small)
                            Text("items")
                        }
                        HStack {
                            Text("navigation")
                            Switch($navigation)
                            Spacer()
                        }
                        if navigation {
                            HStack {
                                Text("variant")
                                SegmentedControl(selectedIndex: $navVariantIndex, labels: navigationVariants.map(\.description))
                                    .size(.small)
                            }
                        }
                        HStack {
                            Text("action")
                            Switch($action)
                            Spacer()
                        }
                        if action {
                            HStack {
                                Text("buttons")
                                SegmentedControl(selectedIndex: $buttonsIndex, labels: ActionAreaButtons.allCases.map(\.rawValue))
                                    .size(.small)
                            }
                            HStack {
                                Text("caption")
                                Switch($caption)
                                Text("extra")
                                Switch($extra)
                                if extra {
                                    Text("extraDivider")
                                    Switch($extraDivider)
                                }
                            }
                        }
                    }
                    .onChange(of: "\(navigation)\(navVariantIndex)\(action)\(buttonsIndex)\(caption)\(extra)\(extraDivider)\(itemCountsIndex)") { _ in
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
                    
                    VStack(spacing: 0) {
                        ForEach(0...itemCounts[itemCountsIndex], id: \.self) { _ in
                            Text("텍스트입니다")
                        }
                    }
                }
            },
            navigation: navigation
            ? {
                ModalNavigation(title: "제목")
                    .variant(navigationVariants[navVariantIndex])
                    .leadingButton(.back(action: {}))
                    .trailingButtons([
                        .icon(.plus, action: {}),
                        .icon(.minus, action: {}),
                        .icon(.close, action: { show = false })
                    ])
            }
            : nil
        )
    }
    
    private var variant: ActionArea.Variant {
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
        .floating(alternative: true)
    ]
    
    private var itemCounts = [10, 50]
    
    private enum ActionAreaButtons: String, CaseIterable {
        case main
        case mainAndSub = "main/sub"
        case mainSubAndAlternative = "main/sub/alt"
    }
}

#Preview {
    FullModalPreview()
}
