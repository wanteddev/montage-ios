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
    
    @State private var refreshTask: Task<(), Never>?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        SwiftUI.Button("PUSH") {
            show.toggle()
        }
        .if(isFullModal) {
            $0.fullModal(
                isPresented: $show,
                actionAreaModel: actionArea ? actionAreaModel : nil,
                navigation: navigation ? { navigationContent } : nil,
                { modalContent }
            )
        }
        .if(!isFullModal) {
            $0.bottomSheetModal(
                isPresented: $show,
                needHandle: handle,
                resize: bottomSheetResizes[resizeIndex],
                actionAreaModel: actionArea ? actionAreaModel : nil,
                navigation: navigation ? { navigationContent } : nil,
                { modalContent }
            )
        }
        .onChange(of: isFullModal) { _ in
            show = false
            show = true
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
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
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Options").bold()
                    Spacer()
                    Button(action: {
                        show = false
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image.icon(.flipBackward).foregroundColor(.semantic(.primaryNormal))
                    }
                }
                HStack {
                    Text("fullModal")
                    Control.switch(checked: isFullModal) { isFullModal = $0 }
                }
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
                    Control.switch(checked: handle) { handle = $0 }
                    Spacer()
                }
                HStack {
                    Text("navigation")
                    Control.switch(checked: navigation) { navigation = $0 }
                    if navigation {
                        SegmentedControl(selectedIndex: $navVariantIndex, labels: navigationVariants.map(\.description))
                            .size(.small)
                    }
                }
                
                HStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("actionArea")
                            Control.switch(checked: actionArea) { actionArea = $0 }
                            if actionArea {
                                SegmentedControl(selectedIndex: $buttonsIndex, labels: ActionAreaButtons.allCases.map(\.rawValue))
                                    .size(.small)
                            }
                        }
                        if actionArea {
                            HStack {
                                Text("caption")
                                Control.switch(checked: caption) { caption = $0 }
                                Text("extra")
                                Control.switch(checked: extra) { extra = $0 }
                                if extra {
                                    Text("divider")
                                    Control.switch(checked: extraDivider) { extraDivider = $0 }
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: "\(handle)\(isFullModal)\(resizeIndex)\(navigation)\(navVariantIndex)\(actionArea)\(buttonsIndex)\(caption)\(extra)\(extraDivider)\(fixedRatio)\(fixedHeight)\(itemCountsIndex)") { _ in
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
                ForEach(0..<itemCounts[itemCountsIndex], id: \.self) { index in
                    ZStack {
                        let color = Color.Semantic.allCases[index % Color.Semantic.allCases.count]
                        Rectangle()
                            .foregroundStyle(SwiftUI.Color.semantic(color))
                        Text(color.rawValue)
                            .shadow(color: .white, radius: 1)
                    }
                    .frame(height: 48)
                }
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
        .floating(alternative: false, background: false)
    ]
    
    private var bottomSheetResizes: [BottomSheetModal.Resize] {
        [
            .hug,
            .fixedRatio(fixedRatio),
            .fixedHeight(fixedHeight),
            .flexible,
            .fill
        ]
    }
    
    private var itemCounts = [1, 5, 100]
    
    private enum ActionAreaButtons: String, CaseIterable {
        case main
        case mainAndSub = "main/sub"
        case mainSubAndAlternative = "main/sub/alt"
    }
}

extension BottomSheetModal.Resize: CaseDescribable {}

#Preview {
    BottomSheetModalPreview()
}
