//
//  ModalPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI

struct ModalPreview: View {
    enum ModalStyle: String, CaseIterable, Identifiable {
        case popup
        case bottomSheet

        var id: String { self.rawValue }
    }

    var body: some View {
        List(ModalStyle.allCases) { style in
            NavigationLink {
                switch style {
                case .popup:
                    PopupPreview()
                case .bottomSheet:
                    BottomSheetModalPreview()
                }
            } label: {
                Text(style.rawValue)
            }
        }
    }
}

#Preview {
    ModalPreview()
}
