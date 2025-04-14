//
//  ModalPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI

struct ModalPreview: View {
    
    @State private var subViewTitle: String = ""
    
    private let subViewTitles = [
        "Popup Modal",
        "Bottom Sheet Modal",
        "Full Modal",
        "Modal Navigation"
    ]
    
    var body: some View {
        List {
            ForEach(0..<subViewTitles.count, id: \.self) { index in
                Button(action: {
                    self.subViewTitle = self.subViewTitles[index]
                }) {
                    Text(self.subViewTitles[index])
                }
            }
        }
        .onChange(of: subViewTitle) { _ in
            let rootView: (any View)?
            switch subViewTitle {
            case "Popup Modal":
                rootView = PopupModalPreivew()
            case "Bottom Sheet Modal":
                rootView = BottomSheetModalPreview()
            case "Full Modal":
                rootView = FullModalPreivew()
            case "Modal Navigation":
                rootView = ModalNavigationPreview()
            default:
                return
            }
            guard let rootView else { return }
            let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
            let naviVC = (window?.rootViewController as? UINavigationController)
            naviVC?.navigationItem.title = subViewTitle
            naviVC?.navigationItem.largeTitleDisplayMode = .never
            naviVC?.pushViewController(UIHostingController(rootView: AnyView(rootView)), animated: true)
        }
        .onAppear {
            subViewTitle = ""
        }
    }
}

#Preview {
    ModalPreview()
}
