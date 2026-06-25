//
//  FallbackViewPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct FallbackViewPreview: View {
    @State private var showImage: Bool = true
    @State private var showTitle: Bool = true
    @State private var showButton: Bool = true

    var body: some View {
        PreviewLayout {
            FallbackView(
                image: showImage ? {
                    AsyncImage(url: URL(string: "https://static.wanted.co.kr/images/error/lighthouse.png")) {
                        $0.image?.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 20)
                    }
                    .frame(height: 320)
                } : nil,
                title: showTitle ? "타이틀이 들어갈수도 있고, 안들어갈 수도 있어요." : nil,
                description: "상황에 대한 설명이 들어가요.\n설명은 최대 두 줄로 작성해요."
            ) {
                Group {
                    if showButton {
                        Button(variant: .outlined, text: "텍스트")
                    }
                }
            }
        } options: {
            HStack {
                ToggleOption("Image", isOn: $showImage)
                ToggleOption("Title", isOn: $showTitle)
                ToggleOption("Button", isOn: $showButton)
            }
        }
    }
}

#Preview {
    FallbackViewPreview()
}
