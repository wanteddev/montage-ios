//
//  BottomSheetModalPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/20/25.
//

import SwiftUI
import Montage

struct BottomSheetModalPreview: View {
    @State private var show = true
    
    @State private var text: String = ""
    
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
    @State private var extraDivider = false
    
    @State private var refreshTask: Task<(), Never>?
    
    var body: some View {
        SwiftUI.Button("PUSH") {
            show.toggle()
        }
        .bottomSheetModal(
            isPresented: $show,
            needHandle: handle,
            resize: bottomSheetResizes[resizeIndex],
            actionAreaModel: actionArea
            ? .init(
                variant: actionAreaVariant,
                caption: caption ? "caption" : nil,
                extra: extra ? {
                    Rectangle().fill(SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.08))
                        .frame(height: 50)
                } : nil,
                extraDivider: extraDivider
            )
            : nil,
            {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Options").bold()
                        HStack {
                            Text("resize")
                            SegmentedControl(selectedIndex: $resizeIndex, labels: bottomSheetResizes.map(\.description))
                                .size(.small)
                        }
                        HStack {
                            SegmentedControl(selectedIndex: $itemCountsIndex, labels: itemCounts.map { "\($0)" })
                                .size(.small)
                            Text("items")
                        }
                        HStack {
                            switch bottomSheetResizes[resizeIndex] {
                            case .fixedRatio:
                                Text("ratio")
                                Slider(value: $fixedRatio, in: 0...1)
                            case .fixedHeight:
                                Text("height")
                                Slider(value: $fixedHeight, in: 0...1000)
                            default:
                                Spacer(minLength: 0)
                            }
                        }
                        HStack {
                            Text("handle")
                            Control.Switch($handle)
                            Spacer()
                        }
                        HStack {
                            Text("navigation")
                            Control.Switch($navigation)
                            if navigation {
                                SegmentedControl(selectedIndex: $navVariantIndex, labels: navigationVariants.map(\.description))
                                    .size(.small)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("actionArea")
                                    Control.Switch($actionArea)
                                    if actionArea {
                                        SegmentedControl(selectedIndex: $buttonsIndex, labels: ActionAreaButtons.allCases.map(\.rawValue))
                                            .size(.small)
                                    }
                                }
                                if actionArea {
                                    HStack {
                                        Text("caption")
                                        Control.Switch($caption)
                                        Text("extra")
                                        Control.Switch($extra)
                                        if extra {
                                            Text("divider")
                                            Control.Switch($extraDivider)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: "\(handle)\(resizeIndex)\(navigation)\(navVariantIndex)\(actionArea)\(buttonsIndex)\(caption)\(extra)\(extraDivider)\(fixedRatio)\(fixedHeight)\(itemCountsIndex)") { _ in
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
                    
                    VStack(spacing: 0) {
                        ForEach(0..<itemCounts[itemCountsIndex], id: \.self) { _ in
                            HStack {
                                Text("텍스트입니다")
                                TextInput.TextField(text: $text)
                            }
                        }
                    }
                }
            },
            navigation: navigation
            ? {
                Modal.Navigation(title: "제목")
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
        .background(SwiftUI.Color.semantic(.backgroundNormal))
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
    
    private let navigationVariants: [Modal.Navigation.Variant] = [
        .normal,
        .extended,
        .emphasized,
        .floating(alternative: false, background: false)
    ]
    
    private var bottomSheetResizes: [Modal.BottomSheet.Resize] {
        [
            .hug,
            .fixedRatio(fixedRatio),
            .fixedHeight(fixedHeight),
            .flexible,
            .fill
        ]
    }
    
    private var itemCounts = [1, 5, 10]
    
    private enum ActionAreaButtons: String, CaseIterable {
        case main
        case mainAndSub = "main/sub"
        case mainSubAndAlternative = "main/sub/alt"
    }
}

extension Modal.BottomSheet.Resize: CaseDescribable {}

#Preview {
    BottomSheetModalPreview()
}
