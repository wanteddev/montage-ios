//
//  ChipPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/24/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI
import Montage

struct ChipPreview: View {
    enum ChipStyle: String, CaseIterable, Identifiable {
        case action
        case filter
        
        var id: String { self.rawValue }
    }
    var body: some View {
        List(ChipStyle.allCases) { style in
            NavigationLink(
                destination: {
                    switch style {
                    case .action:
                        ActionChipPreview()
                    case .filter:
                        FilterChipPreview()
                    }
                }, label: {
                    Text(style.rawValue.capitalized)
                }
            )
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ChipPreview()
}
