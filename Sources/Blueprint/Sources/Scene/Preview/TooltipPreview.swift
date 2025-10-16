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
    @State private var showTransparentChecker: Bool = false
    @State private var show: Bool = false
    
    @State private var showMultilineText: Bool = true
    @State private var adjustZIndex: Bool = true
    @State private var showArrow: Bool = true
    @State private var showCloseButton: Bool = true
    @State private var showButton: Bool = true
    @State private var buttonText: String = "확인"
    
    private let normalText: String = "툴팁이다!!!"
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
    
    @State private var modeIndex = 0
    @State private var positionIndex: Int = 3
    @State private var arrowPositionIndex: Int = 1
    @State private var vAlignIndex: Int = 1
    @State private var hAlignIndex: Int = 1
    @State private var alertPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
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
            ZStack {
                SwiftUI.Color.clear
                VStack {
                    Spacer(minLength: 0)
                    zIndexTestingButton
                    HStack {
                        zIndexTestingButton
                        iconButton
                            .modifying { origin in
                                if adjustZIndex {
                                    origin.zIndex(1)
                                } else {
                                    origin
                                }
                            }
                        zIndexTestingButton
                    }
                    .modifying { origin in
                        if adjustZIndex {
                            origin.zIndex(1)
                        } else {
                            origin
                        }
                    }
                    zIndexTestingButton
                        
                    Spacer(minLength: 0)
                }
            }
            optionSheet
        }
        .font(.caption)
        .padding()
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 200, checkerColor: .red)
    }
    
    var iconButton: some View {
        Button(color: .primary, size: .small, text: "Push") {
            show.toggle()
        }
        .modifying {
            $0.tooltip(
                isPresented: $show,
                mode: modeIndex == 0 ? .click : .always,
                position: positions[positionIndex],
                message: showMultilineText ? multilineText : normalText,
                showArrow: showArrow,
                showCloseButton: showCloseButton,
                buttonInfo: showButton ? Tooltip.ButtonInfo(title: buttonText, action: {
                    print("버튼 클릭됨")
                    show = false
                }) : nil
            )
            .onChange(of: modeIndex) { _ in
                show = false
            }
        }
        .modifying { origin in
            if adjustZIndex {
                origin.zIndex(1)
            } else {
                origin
            }
        }
    }
    
    var zIndexTestingButton: some View {
        Button(color: .assistive, text: "zIndex\n테스트 버튼") {
            alertPresented = true
        }
        .contentColor(.semantic(.primaryNormal))
        .alert("버튼이 툴팁에 의해 가려지고 툴팁을 통과해서 눌리지 않아야 합니다.", isPresented: $alertPresented) {
            Button("확인") {
                alertPresented = false
            }
        }
    }
    
    var optionSheet: some View {
        VStack(alignment: .leading) {
            options
        }
        .font(.caption)
    }
    
    var options: some View {
        VStack(alignment: .leading) {
            Text("Options").bold()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Mode")
                    SegmentedControl(selectedIndex: $modeIndex, labels: ["click", "always"])
                        .size(.small)
                }
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
                
                HStack {
                    Text("Adjust zIndex")
                    Control.switch(checked: adjustZIndex) { adjustZIndex = $0 }
                    Text("Show Arrow")
                    Control.switch(checked: showArrow) { showArrow = $0 }
                }
                
                HStack {
                    Text("MultiLine Text")
                    Control.switch(checked: showMultilineText) { showMultilineText = $0 }
                    Text("Show Close Button")
                    Control.switch(checked: showCloseButton) { showCloseButton = $0 }
                    Text("Show Button")
                    Control.switch(checked: showButton) { showButton = $0 }
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
