//
//  FallbackViewPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct FallbackViewPreview: View {
    @State private var showTitle: Bool = true
    @State private var showButton: Bool = true

    var body: some View {
        PreviewLayout {
            FallbackView(
                title: showTitle ? "타이틀이 들어갈수도 있고, 안들어갈 수도 있어요." : nil,
                description: "상황에 대한 설명이 들어가요.\n설명은 최대 두 줄로 작성해요."
            ) {
                Group {
                    if showButton {
                        Button(variant: .outlined, color: .assistive, text: "텍스트")
                    }
                }
            }
        } options: {
            HStack {
                ToggleOption("Title", isOn: $showTitle)
                ToggleOption("Button", isOn: $showButton)
            }
        }
    }
}

#Preview {
    FallbackViewPreview()
}
