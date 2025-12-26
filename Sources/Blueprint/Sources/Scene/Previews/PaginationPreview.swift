//
//  PaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import Montage
import SwiftUI

struct PaginationPreview: View {
    enum PaginationType: String, CaseIterable, Identifiable {
        case paginationDots
        case pageCounter

        var id: String { self.rawValue }
        
        var displayName: String {
            rawValue.prefix(1).uppercased() + rawValue.dropFirst()
        }
    }

    init() {}

    var body: some View {
        List(PaginationType.allCases) { type in
            NavigationLink(
                destination: {
                    Group {
                        switch type {
                        case .paginationDots:
                            PaginationDotsPreview()
                        case .pageCounter:
                            PageCounterPreview()
                        }
                    }
                    .navigationTitle(type.displayName)
                },
                label: {
                    Text(type.displayName)
                }
            )
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview(body: {
    return PaginationPreview()
})
