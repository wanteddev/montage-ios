//
//  TooltipPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/4/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct TooltipPreview: View {
    @State private var show: Bool = false
    @State private var optionsPresented = false
    
    @State private var useSystemAPI: Bool = false
    @State private var showMultilineText: Bool = true
    @State private var adjustZIndex: Bool = true
    @State private var showArrow: Bool = true
    @State private var showCloseButton: Bool = true
    @State private var showButton: Bool = true
    @State private var buttonText: String = "확인"
    
    private let normalText: String = "메시지에 마침표를 찍어요."
    private let multilineText: String = "긴 내용이 필요한 경우 이 영역을 써요. 본래 내용이 입력되기 전까지 공간을 차지하고, 배치를 확인하기 위한 텍스트입니다."
    
    var positions: [Tooltip.Position] {
        [
            .leading(arrowPosition: verticalAlignments[arrowPositionIndex]),
            .trailing(arrowPosition: verticalAlignments[arrowPositionIndex]),
            .top(arrowPosition: horizontalAlignments[arrowPositionIndex]),
            .bottom(arrowPosition: horizontalAlignments[arrowPositionIndex])
        ]
    }
    
    let verticalAlignments: [VerticalAlignment] = [.top, .center, .bottom]
    let horizontalAlignments: [HorizontalAlignment] = [.leading, .center, .trailing]
    
    @State private var positionIndex: Int = 3
    @State private var arrowPositionIndex: Int = 1
    @State private var vAlignIndex: Int = 1
    @State private var hAlignIndex: Int = 1
    @State private var alertPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Preview").bold()
            if usingSystemAPI() {
                if #available(iOS 16.4, *) {
                    VStack(alignment: HAlign.allCases[hAlignIndex] == .leading ? .leading : HAlign.allCases[hAlignIndex] == .trailing ? .trailing : .center) {
                        if VAlign.allCases[vAlignIndex] != .top {
                            Spacer(minLength: 0)
                            zIndexTestingButton
                        }
                        HStack {
                            if HAlign.allCases[hAlignIndex] != .leading {
                                Spacer(minLength: 0)
                                zIndexTestingButton
                            }
                            iconButton
                            if HAlign.allCases[hAlignIndex] != .trailing {
                                zIndexTestingButton
                                Spacer(minLength: 0)
                            }
                        }
                        if VAlign.allCases[vAlignIndex] != .bottom {
                            zIndexTestingButton
                            Spacer(minLength: 0)
                        }
                    }
                    optionSheet
                } else {
                    // Fallback on earlier versions
                }
            } else {
                ZStack {
                    SwiftUI.Color.clear
                    VStack {
                        Spacer(minLength: 0)
                        zIndexTestingButton
                        HStack {
                            zIndexTestingButton
                            iconButton
                                .modifying {
                                    if usingSystemAPI() {
                                        $0
                                    } else {
                                        adjustZIndex ? $0.zIndex(1) : $0
                                    }
                                }
                            zIndexTestingButton
                        }
                        .modifying {
                            if usingSystemAPI() {
                                $0
                            } else {
                                adjustZIndex ? $0.zIndex(1) : $0
                            }
                        }
                        zIndexTestingButton
                        Spacer(minLength: 0)
                    }
                }
                optionSheet
            }
            
        }
        .font(.caption)
        .padding()
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    var iconButton: some View {
        Button.solid(variant: .primary, size: .small, text: "Push") {
            show.toggle()
        }
        .modifying {
            if usingSystemAPI() {
                if #available(iOS 16.4, *) {
                    $0.tooltip(
                        isPresented: $show,
                        message: showMultilineText ? multilineText : normalText,
                        showCloseButton: showCloseButton,
                        buttonInfo: showButton ? Tooltip.ButtonInfo(title: buttonText, action: {
                            print("버튼 클릭됨")
                            show = false
                        }) : nil
                    )
                } else {
                    $0
                }
            } else {
                $0.tooltip(
                    isPresented: $show,
                    position: positions[positionIndex],
                    message: showMultilineText ? multilineText : normalText,
                    showArrow: showArrow,
                    showCloseButton: showCloseButton,
                    buttonInfo: showButton ? Tooltip.ButtonInfo(title: buttonText, action: {
                        print("버튼 클릭됨")
                        show = false
                    }) : nil
                )
            }
        }
        .modifying {
            if usingSystemAPI() {
                $0
            } else {
                adjustZIndex ? $0.zIndex(1) : $0
            }
        }
    }
    
    var zIndexTestingButton: some View {
        Button("zIndex 테스트 버튼") {
            alertPresented = true
        }
        .alert("버튼이 툴팁에 의해 가려지고 툴팁을 통과해서 눌리지 않아야 합니다.", isPresented: $alertPresented) {
            Button("확인") {
                alertPresented = false
            }
        }
    }
    
    var optionSheet: some View {
        VStack(alignment: .leading) {
            if usingSystemAPI() {
                Button("Show Options") {
                    optionsPresented.toggle()
                }
            } else {
                options
            }
        }
        .font(.caption)
        .if(usingSystemAPI()) {
            $0.bottomSheetModal(isPresented: $optionsPresented, resize: .hug) {
                options
            }
        }
    }
    
    var options: some View {
        VStack(alignment: .leading) {
            Text("Options").bold()
            Text("iOS 16.4 이상에서는 position 값 유무에 따라 툴팁의 동작이나 가능한 옵션이 현저히 다릅니다. position 값이 nil인 경우 시스템 API를 사용하여 툴팁을 표시하기 때문입니다.")
                .typographyNew(variant: .caption1, color: .semantic(.labelAlternative))
            VStack(alignment: .leading, spacing: 12) {
                if #available(iOS 16.4, *) {
                    HStack {
                        Text("Use System API (position == nil)")
                        Switch($useSystemAPI)
                    }
                }
                
                if usingSystemAPI() {
                    Text("position은 nil인 경우 anchor가 되는 뷰의 위치에 따라 iOS 시스템이 툴팁의 위치를 자동으로 결정합니다.\n또한, showArrow는 항상 true로 동작하고, zIndex를 조정할 필요가 없습니다.")
                        .typographyNew(variant: .caption1, color: .semantic(.labelAlternative))
                } else {
                    Text("주어진 position 값에 따라 툴팁의 위치가 결정되며, showArrow 옵션을 false 로 주면 화살표가 사라집니다.\n또한, position이 .trailing이거나 .bottom인 경우 zIndex를 조정해야 툴팁이 주변 뷰에 가려지지 않습니다.")
                        .typographyNew(variant: .caption1, color: .semantic(.labelAlternative))
                }
                
                if usingSystemAPI() {
                    Text("Anchor Position")
                    HStack {
                        Text("Vertical")
                        SegmentedControl(
                            selectedIndex: $vAlignIndex,
                            labels: VAlign.allCases.map(\.rawValue)
                        )
                        .size(.small)
                    }
                    
                    HStack {
                        Text("Horizontal")
                        SegmentedControl(
                            selectedIndex: $hAlignIndex,
                            labels: HAlign.allCases.map(\.rawValue)
                        )
                        .size(.small)
                    }
                } else {
                    
                    HStack {
                        Text("Position")
                        SegmentedControl(
                            selectedIndex: $positionIndex,
                            labels: positions.map(\.description)
                        )
                        .size(.small)
                    }
                    
                    HStack {
                        Text("Arrow Position")
                        SegmentedControl(
                            selectedIndex: $arrowPositionIndex,
                            labels: positions[positionIndex].arrowPositions
                        )
                        .size(.small)
                    }
                }
                
                if !usingSystemAPI() {
                    HStack {
                        Text("Adjust zIndex")
                        Switch($adjustZIndex)
                        Text("Show Arrow")
                        Switch($showArrow)
                    }
                }
                
                HStack {
                    Text("MultiLine Text")
                    Switch($showMultilineText)
                    Text("Show Close Button")
                    Switch($showCloseButton)
                    Text("Show Button")
                    Switch($showButton)
                }
                
                if showButton {
                    HStack {
                        Text("Button Text")
                        TextField(text: $buttonText)
                            .placeholder("버튼 텍스트")
                    }
                }
            }
        }
    }
    
    func usingSystemAPI() -> Bool {
        if #available(iOS 16.4, *) {
            useSystemAPI
        } else {
            false
        }
    }
}

enum HAlign: String, CaseIterable {
    case leading
    case center
    case trailing
}

enum VAlign: String, CaseIterable {
    case top
    case center
    case bottom
}

extension Tooltip.Position: CaseDescribable {
    var arrowPositions: [String] {
        switch self {
        case .top, .bottom:
            return HAlign.allCases.map(\.rawValue)
        case .leading, .trailing:
            return VAlign.allCases.map(\.rawValue)
        }
    }
}

#Preview {
    TooltipPreview()
}
