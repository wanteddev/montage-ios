//
//  ShadowPreview.swift
//  Montage
//
//  Created by 김삼열 on 8/21/25.
//

import SwiftUI
import Montage

struct ShadowPreview: View {
    @State private var levelIndex = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Preview").bold()
            
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(SwiftUI.Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(ShadowModifier.Level.allCases[levelIndex])
            }
            .frame(maxWidth: .infinity)
            
            Text("Options").bold()
            
            SegmentedControl(selectedIndex: $levelIndex, labels: ShadowModifier.Level.allCases.map(\.description))
                .size(.small)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

extension ShadowModifier.Level: CaseDescribable {}

#Preview {
    ShadowPreview()
}
