//
//  PaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import Montage
import Pretendard
import SwiftUI

struct PaginationPreview: View {
    enum PaginationType: String, CaseIterable, Identifiable {
        case dot
        case counter

        var id: String { self.rawValue }
    }

    init() {}

    var body: some View {
        List(PaginationType.allCases) { type in
            NavigationLink(
                destination: {
                    switch type {
                    case .dot:
                        PaginationDotsPreview()
                    case .counter:
                        PageCounterPreview()
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

#Preview(body: {
    _ = try? Pretendard.registerFonts()
    return PaginationPreview()
})
