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
        PreviewLayout {
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(SwiftUI.Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(Shadow.Level.allCases[levelIndex])
            }
            .frame(maxWidth: .infinity)
        } options: {
            SegmentedIndexRow("level", index: $levelIndex, labels: Shadow.Level.allCases.map(\.description))
        }
    }
}

extension Shadow.Level: CaseDescribable {}

#Preview {
    ShadowPreview()
}
