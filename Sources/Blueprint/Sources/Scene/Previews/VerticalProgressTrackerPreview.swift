//
//  VerticalProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct VerticalProgressTrackerPreview: View {
    @State private var progress: Int = 1
    @State private var isLabelExist = true
    @State private var isAccessoryExist = true
    @State private var isContentExist = true
    @State private var testText = "테스트 텍스트입니다."

    var body: some View {
        PreviewLayout {
            ProgressTracker(
                progress: $progress,
                variant: .vertical(stepContents: [
                    ProgressTracker.VerticalStepContent(
                        label: isLabelExist ? "1단계" : "",
                        labelAccessoryView: {
                            ContentBadge(variant: .solid, text: "뱃지")
                                .size(.small)
                                .colorStyle(.neutral())
                                .if(isAccessoryExist)
                        },
                        contentView: {
                            TextArea(text: $testText)
                                .if(isContentExist)
                        }
                    ),
                    ProgressTracker.VerticalStepContent(
                        label: isLabelExist ? "2단계" : "",
                        labelAccessoryView: { AnyView(EmptyView()) },
                        contentView: {
                            Avatar(
                                "https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg",
                                variant: .person, size: .small
                            )
                            .if(isContentExist)
                        }
                    ),
                    ProgressTracker.VerticalStepContent(
                        label: isLabelExist ? "3단계" : "",
                        labelAccessoryView: {
                            HStack {
                                Spacer(minLength: 0)
                                Text("설명")
                                    .typography(variant: .caption1)
                            }
                            .if(isAccessoryExist)
                        },
                        contentView: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(SwiftUI.Color.gray)
                                .if(isContentExist)
                        }
                    ),
                    ProgressTracker.VerticalStepContent(
                        label: isLabelExist ? "마지막\n단계" : "",
                        contentView: {
                            Text("Hello\nWorld!")
                                .typography(variant: .title1)
                                .paragraph(variant: .title1)
                                .fixedSize()
                                .if(isContentExist)
                        }
                    ),
                ])
            )
        } options: {
            PrevNextOptionRow(value: $progress, in: 1...5)

            HStack {
                ToggleOption("Label", isOn: Binding(
                    get: { isLabelExist },
                    set: {
                        isLabelExist = $0
                        isAccessoryExist = $0
                    }
                ))
                ToggleOption("Label Accessory", isOn: $isAccessoryExist)
                ToggleOption("Content", isOn: $isContentExist)
            }
        }
    }
}

#Preview {
    VerticalProgressTrackerPreview()
}
