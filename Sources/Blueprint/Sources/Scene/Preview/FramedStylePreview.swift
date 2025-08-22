//
//  FramedStylePreview.swift
//  Montage
//
//  Created by 김삼열 on 8/22/25.
//

import SwiftUI
import Montage

struct FramedStylePreview: View {
    @State private var sizeIndex: Int = 0
    @State private var statusIndex: Int = 0
    @State private var shadowIndex: Int = 0
    @State private var selected: Bool = false
    @State private var disabled: Bool = false
    @State private var negative: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Preview").bold()
            
            ZStack {
                Text("Preview")
                Rectangle()
                    .foregroundColor(.semantic(.accentBackgroundViolet).opacity(0.08))
                    .frame(height: 80)
            }
            .framedStyle(
                    size: FramedStyleSize.allCases[sizeIndex],
                    status: FramedStyleStatus.allCases[statusIndex],
                    shadowLevel: ShadowLevel.allCases[shadowIndex],
                    disabled: disabled
                )
                .padding(.horizontal, 16)
            
            Text("Options").bold()
            
            HStack {
                Text("size")
                SegmentedControl(selectedIndex: $sizeIndex, labels: FramedStyleSize.allCases.map(\.description))
                    .size(.small)
            }
            HStack {
                Text("shadow")
                SegmentedControl(selectedIndex: $shadowIndex, labels: ShadowLevel.allCases.map(\.description))
                    .size(.small)
            }
            HStack {
                Text("status")
                SegmentedControl(selectedIndex: $statusIndex, labels: FramedStyleStatus.allCases.map(\.description))
                    .size(.small)
            }
            HStack {
                Text("disabled")
                Switch($disabled)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

extension FramedStyleSize: CaseDescribable {}
extension FramedStyleStatus: CaseDescribable {}
    
#Preview {
    FramedStylePreview()
}
