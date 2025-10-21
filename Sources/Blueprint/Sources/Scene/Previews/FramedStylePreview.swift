//
//  FramedStylePreview.swift
//  Montage
//
//  Created by 김삼열 on 8/22/25.
//

import SwiftUI
import Montage

struct FramedStylePreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var statusIndex: Int = 0
    @State private var borderRadius: CGFloat = 0
    @State private var shadowIndex: Int = 0
    @State private var selected: Bool = false
    @State private var disabled: Bool = false
    @State private var negative: Bool = false
    
    var body: some View {
        ScrollView {
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
                    Rectangle()
                        .foregroundColor(.semantic(.backgroundNormalAlternative))
                        .frame(height: 80)
                    Text("Preview")
                }
                .framedStyle(
                    status: FramedStyleStatus.allCases[statusIndex],
                    borderRadius: borderRadius,
                    shadowLevel: ShadowLevel.allCases[shadowIndex],
                    disabled: disabled
                )
                
                Text("Options").bold()
                
                HStack {
                    Text("status")
                    SegmentedControl(selectedIndex: $statusIndex, labels: FramedStyleStatus.allCases.map(\.description))
                        .size(.small)
                }
                HStack {
                    Text("borderRadius")
                    Slider(value: $borderRadius, in: 0...20, step: 1)
                }
                HStack {
                    Text("shadow")
                    SegmentedControl(selectedIndex: $shadowIndex, labels: ShadowLevel.allCases.map(\.description))
                        .size(.small)
                }
                HStack {
                    Text("disabled")
                    Control.switch(checked: disabled) { disabled = $0 }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

extension FramedStyleStatus: CaseDescribable {}
    
#Preview {
    FramedStylePreview()
}
