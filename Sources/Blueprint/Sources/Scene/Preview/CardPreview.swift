//
//  CardPreview.swift
//  Blueprint
//
//  Created by Claude on 6/12/25.
//

import SwiftUI

struct CardPreview: View {
    
    @State private var subViewTitle: String = ""
    
    private let subViewTitles = [
        "Normal Card",
        "List Card"
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
            case "Normal Card":
                rootView = NormalCardPreview()
            case "List Card":
                rootView = ListCardPreview()
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
        .navigationBarHidden(false)
    }
}

#Preview {
    CardPreview()
} 