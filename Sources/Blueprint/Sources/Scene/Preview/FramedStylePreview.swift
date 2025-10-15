//
//  FramedStylePreview.swift
//  Montage
//
//  Created by 김삼열 on 8/22/25.
//

import SwiftUI
import Montage

struct FramedStylePreview: View {
    @State private var isBackgroundClear = false
    @State private var statusIndex: Int = 0
    @State private var borderRadius: CGFloat = 0
    @State private var shadowIndex: Int = 0
    @State private var selected: Bool = false
    @State private var disabled: Bool = false
    @State private var negative: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Preview").bold()
            
            ZStack {
                Rectangle()
                    .foregroundColor(isBackgroundClear ? .clear : .semantic(.backgroundNormalAlternative))
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
                Text("isBackgroundClear(for test only)")
                Control.switch(checked: isBackgroundClear) { isBackgroundClear = $0 }
            }
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
        .padding(.horizontal, 16)
    }
}

extension FramedStyleStatus: CaseDescribable {}
    
#Preview {
    FramedStylePreview()
}
