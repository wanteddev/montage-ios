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
        List {
            Section {
                ForEach(TrackerType.allCases) { type in
                    NavigationLink(
                        destination: {
                            Group {
                                switch type {
                                case .horizontal:
                                    HorizontalProgressTrackerPreview()
                                case .vertical:
                                    VerticalProgressTrackerPreview()
                                }
                            }
                            .navigationTitle(type.rawValue.capitalized)
                        },
                        label: {
                            Text(type.rawValue.capitalized)
                        }
                    )
                }
            } header: {
                Text("variant")
            }
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview(body: {
    return ProgressTrackerPreview()
})
