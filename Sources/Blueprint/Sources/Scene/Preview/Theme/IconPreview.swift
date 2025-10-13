//
//  IconPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 10/2/25.
//

import SwiftUI
import Montage

struct IconPreview: View {
    @State private var searchText: String = ""
    
    var body: some View {
        List {
            ForEach(iconList, id: \.rawValue) { icon in
                ListCell(title: icon.rawValue)
                    .leadingContent {
                        Image.icon(icon)
                            .renderingMode(.original)
                    }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "아이콘을 검색하세요.")
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
