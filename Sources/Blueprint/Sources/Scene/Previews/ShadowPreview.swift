//
//  ShadowPreview.swift
//  Montage
//
//  Created by 김삼열 on 8/21/25.
//

import SwiftUI
import Montage

struct ShadowPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var levelIndex = 0
    
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
            
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(SwiftUI.Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(Shadow.Level.allCases[levelIndex])
            }
            .frame(maxWidth: .infinity)
            
            Text("Options").bold()
            
            SegmentedControl(selectedIndex: $levelIndex, labels: Shadow.Level.allCases.map(\.description))
                .size(.small)
            
            Spacer()
        }
        .padding(.horizontal)
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

extension Shadow.Level: CaseDescribable {}

#Preview {
    ShadowPreview()
}
