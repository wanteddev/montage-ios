//
//  ProgressIndicatorPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/19/24.
//

import SwiftUI
import Montage

struct ProgressIndicatorPreview: View {
    @State private var percentage: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                ProgressIndicator(percentage: $percentage)
                Text("Options").bold()
                HStack {
                    Text("Percentage")
                    Text(String(format: "%.1f%%", percentage * 100))
                        .frame(width: 60, alignment: .trailing)
                    Slider(value: $percentage, in: 0...1)
                }
            }
            .padding()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ProgressIndicatorPreview()
}
