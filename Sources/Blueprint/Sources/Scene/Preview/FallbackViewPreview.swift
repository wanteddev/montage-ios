//
//  FallbackViewPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct FallbackViewPreview: View {
    var body: some View {
        FallbackView(
            image: {
                AsyncImage(url: URL(string: "https://static.wanted.co.kr/images/error/lighthouse.png")) {
                    $0.image?.resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 20)
                }
            },
            title: "타이틀이 들어갈수도 있고, 안들어dasfasdasfasda갈 수 도 있어요.",
            description: "상황에 대한 설명이 들어fdsasdasfasdasfasdasf asdasfasdafasd가요.\n설명은 최대 두 줄로 작성해요."
        ) {
            Button.outlined(text: "텍스트")
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    FallbackViewPreview()
}
