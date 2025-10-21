//
//  IconPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 10/2/25.
//

import SwiftUI
import Montage

struct IconPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Preview").bold()
                Spacer()
                Button(action: {
                    showTransparentChecker.toggle()
                }) {
                    Image(systemName: "checkerboard.rectangle")
                        .foregroundColor(.semantic(.primaryNormal))
                }
            }
            .padding()
            
            List {
                ForEach(iconList, id: \.rawValue) { icon in
                    ListCell(title: icon.rawValue)
                        .leadingContent {
                            Image.icon(icon)
                                .renderingMode(.original)
                        }
                        .divider()
                        .padding(.horizontal, 16)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(SwiftUI.Color.clear)
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "아이콘을 검색하세요.")
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
    
    var iconList: [Icon] {
        Icon.allCases.filter { icon in
            searchText.isEmpty || icon.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    IconPreview()
}
