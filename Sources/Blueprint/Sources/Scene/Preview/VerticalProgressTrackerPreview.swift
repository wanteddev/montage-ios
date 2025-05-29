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
    
    var body: some View {
        VStack {
            HStack {
                Text("Label")
                Switch($isLabelExist) {
                    isLabelExist = $0
                    isAccessoryExist = $0
                }
                Text("Label Accessory")
                Switch($isAccessoryExist) { isAccessoryExist = $0 }
                Text("Content")
                Switch($isContentExist) { isContentExist = $0 }
            }
            .font(.caption)
            
            VerticalProgressTracker(
                progress: $progress,
                stepContents: [
                    .init(
                        label: isLabelExist ? "처음이에요\n진짜" : "",
                        labelAccessoryView: {
                            isAccessoryExist
                            ? AnyView(
                                ContentBadge(variant: .solid, text: "뱃지")
                                    .size(.small)
                                    .colorStyle(.neutral())
                            )
                            : AnyView(EmptyView())
                        },
                        contentView: {
                            isContentExist
                            ? AnyView(TextArea(text: .constant("테스트 텍스트입니다.")))
                            : AnyView(EmptyView())
                        }
                    ),
                    .init(
                        label: isLabelExist ? "중간" : "",
                        labelAccessoryView: { AnyView(EmptyView()) },
                        contentView: {
                            isContentExist
                            ? AnyView(
                                Avatar("https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg", variant: .person, size: .small)
                            )
                            : AnyView(EmptyView())
                        }
                    ),
                    .init(
                        label: isLabelExist ? "또\n중간" : "",
                        labelAccessoryView: {
                            isAccessoryExist
                            ? AnyView(
                                HStack {
                                    Spacer(minLength: 0)
                                    Text("뭐라 뭐라 디스크립션")
                                        .typography(variant: .caption1)
                                }
                            )
                            : AnyView(EmptyView())
                        },
                        contentView: {
                            isContentExist
                            ? AnyView(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(SwiftUI.Color.gray)
                            )
                            : AnyView(EmptyView())
                        }
                    ),
                    .init(
                        label: isLabelExist ? "끝입니다\n정말\n정말\n끝" : "",
                        labelAccessoryView: { AnyView(EmptyView()) },
                        contentView: {
                            isContentExist
                            ? AnyView(
                                Text("Hel\nlo\nWor\nld!")
                                    .typography(variant: .title1)
                                    .paragraph(variant: .title1)
                                    .fixedSize()
                            )
                            : AnyView(EmptyView())
                        }
                    )
                ]
            )
            Spacer(minLength: 0)
            HStack {
                SwiftUI.Button("Prev") { progress = max(1, progress - 1) }
                SwiftUI.Button("Next") { progress = min(progress + 1, 5) }
            }
        }
        .padding()
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    VerticalProgressTrackerPreview()
}
