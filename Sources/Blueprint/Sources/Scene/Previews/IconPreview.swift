//
//  IconPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 10/2/25.
//

import SwiftUI
import Montage

struct IconPreview: View {
    // .clear이면 tint를 적용하지 않고 아이콘 원본 색을 쓴다. (헤더 ColorPicker로 조절)
    @State private var color: SwiftUI.Color = .clear
    @State private var searchText: String = ""

    var body: some View {
        PreviewLayout {
            // stacked 모드는 콘텐츠를 ScrollView로 감싸므로 List(자체 스크롤)는 높이가 붕괴된다.
            // 바깥 ScrollView 하나로 전체를 스크롤하도록 LazyVStack을 쓴다.
            LazyVStack(spacing: 0) {
                ForEach(iconList, id: \.rawValue) { icon in
                    ListCell(title: icon.rawValue)
                        .leadingContent {
                            Image.icon(
                                icon,
                                renderingMode: .original,
                                color: color == .clear ? nil : color
                            )
                        }
                }
            }
        } options: {
            EmptyView()
        } accessory: {
            // 탭하면 시스템 컬러 피커를 띄우는 스와치 버튼. opacity 0(.clear)으로 두면 tint 해제.
            ColorPicker("color", selection: $color, supportsOpacity: true)
                .labelsHidden()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
