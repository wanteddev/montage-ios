//
//  ModalPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI

struct ModalPreview: View {
    enum ModalStyle: String, CaseIterable, Identifiable {
        case popupModal
        case bottomSheetModal
        case fullModal
        case modalNavigation
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        List(ModalStyle.allCases) { style in
            NavigationLink {
                switch style {
                case .popupModal:
                    PopupModalPreview()
                case .bottomSheetModal:
                    BottomSheetModalPreview()
                case .fullModal:
                    FullModalPreview()
                case .modalNavigation:
                    ModalNavigationPreview()
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
