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
    private let paddingLabels = ["normal", "compact", "custom"]

    @State private var title: String = "타이틀이 들어가요."
    @State private var description: String = "상황에 대한 설명이 들어가요.\n설명은 최대 두 줄로 작성해요."
    @State private var buttonActionAreaIndex: Int = 1
    @State private var paddingIndex: Int = 0
    @State private var customPadding: CGFloat = 40

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

    private var padding: FallbackView.Padding {
        switch paddingIndex {
        case 1:
            return .compact
        case 2:
            return .custom(customPadding)
        default:
            return .normal
        }
    }

    var body: some View {
        PreviewLayout {
            FallbackView(
                title: title.isEmpty ? nil : title,
                description: description,
                buttonActionArea: buttonActionArea,
                padding: padding
            )
        } options: {
            TextAreaOptionRow("title", text: $title, placeholder: "비우면 타이틀을 표시하지 않아요")
            TextAreaOptionRow("description", text: $description)
            SegmentedIndexRow(
                "buttonActionArea",
                index: $buttonActionAreaIndex,
                labels: buttonActionAreaLabels
            )
            SegmentedIndexRow(
                "padding",
                index: $paddingIndex,
                labels: paddingLabels
            )
            if paddingIndex == 2 {
                SliderOptionRow("customPadding", value: $customPadding, in: 0...200, step: 1)
            }
        }
    }
}

#Preview {
    FallbackViewPreview()
}
