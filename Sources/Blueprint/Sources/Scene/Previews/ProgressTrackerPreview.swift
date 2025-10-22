//
//  ProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct ProgressTrackerPreview: View {
    enum TrackerType: String, CaseIterable, Identifiable {
        case horizontal
        case vertical
        
        var id: String { self.rawValue }
    }
    
    init() {}
    
    var body: some View {
        List(TrackerType.allCases) { type in
            NavigationLink(
                destination: {
                    switch type {
                    case .horizontal:
                        HorizontalProgressTrackerPreview()
                    case .vertical:
                        VerticalProgressTrackerPreview()
                    }
                },
                label: {
                    Text(type.rawValue.capitalized)
                }
            )
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

import Pretendard
#Preview(body: {
    _ = try? Pretendard.registerFonts()
    return ProgressTrackerPreview()
})
