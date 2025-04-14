//
//  ProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct ProgressTrackerPreview: View {
    enum Item: Identifiable {
        case horizontal
        case vertical
        var id: Self { self }
    }
    
    @State private var selection: Item?
    init() {}
    var body: some View {
        List {
            SwiftUI.Button("Horizontal") { selection = .horizontal }
            SwiftUI.Button("Vertical") { selection = .vertical }
        }
        .sheet(item: $selection, onDismiss: { selection = nil }) { item in
            switch item {
            case .horizontal:
                HorizontalProgressTrackerPreview()
            case .vertical:
                VerticalProgressTrackerPreview()
            }
        }
    }
}

import Pretendard
#Preview(body: {
    _ = try? Pretendard.registerFonts()
    return ProgressTrackerPreview()
})
