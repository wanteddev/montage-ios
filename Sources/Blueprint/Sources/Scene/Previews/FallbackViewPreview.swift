//
//  FallbackViewPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct FallbackViewPreview: View {
    private let buttonActionAreaLabels = ["none", "single", "horizontal", "vertical"]

    @State private var showTitle: Bool = true
    @State private var buttonActionAreaIndex: Int = 1

    private var buttonActionArea: FallbackView.ButtonActionArea? {
        switch buttonActionAreaIndex {
        case 1:
            return .single(.init(text: "액션", action: {}))
        case 2:
            return .horizontal(
                main: .init(text: "메인 액션", action: {}),
                alternative: .init(text: "대체 액션", action: {})
            )
        case 3:
            return .vertical(
                main: .init(text: "메인 액션", action: {}),
                alternative: .init(text: "대체 액션", action: {})
            )
        default:
            return nil
        }
    }

    var body: some View {
        PreviewLayout {
            FallbackView(
                title: showTitle ? "타이틀이 들어갈수도 있고, 안들어갈 수도 있어요." : nil,
                description: "상황에 대한 설명이 들어가요.\n설명은 최대 두 줄로 작성해요.",
                buttonActionArea: buttonActionArea
            )
        } options: {
            ToggleOptionRow("Title", isOn: $showTitle)
            SegmentedIndexRow(
                "buttonActionArea",
                index: $buttonActionAreaIndex,
                labels: buttonActionAreaLabels
            )
        }
    }
}

#Preview {
    FallbackViewPreview()
}
