//
//  PaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI
import Montage

struct PaginationPreview: View {
    enum Item: Identifiable {
        case dot
        case counter
        var id: Self { self }
    }
    
    @State private var selection: Item?
    init() {}
    var body: some View {
        List {
            SwiftUI.Button("Dot") { selection = .dot }
            SwiftUI.Button("Counter") { selection = .counter }
        }
        .sheet(item: $selection, onDismiss: { selection = nil }) { item in
            switch item {
            case .dot:
                DotPaginationPreview()
            case .counter:
                CounterPaginationPreview()
            }
        }
    }
}

import Pretendard
#Preview(body: {
    _ = try? Pretendard.registerFonts()
    return PaginationPreview()
})
