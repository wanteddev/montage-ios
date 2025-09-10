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
                            ContentBadge(variant: .solid, text: "뱃지")
                                .size(.small)
                                .colorStyle(.neutral())
                                .if(isAccessoryExist)
                        },
                        contentView: {
                            TextArea(text: .constant("테스트 텍스트입니다."))
                                .if(isContentExist)
                        }
                    ),
                    .init(
                        label: isLabelExist ? "중간" : "",
                        labelAccessoryView: { AnyView(EmptyView()) },
                        contentView: {
                            Avatar("https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg", variant: .person, size: .small)
                                .if(isContentExist)
                        }
                    ),
                    .init(
                        label: isLabelExist ? "또\n중간" : "",
                        labelAccessoryView: {
                            HStack {
                                Spacer(minLength: 0)
                                Text("뭐라 뭐라 디스크립션")
                                    .typographyNew(variant: .caption1)
                            }
                            .if(isAccessoryExist)
                        },
                        contentView: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(SwiftUI.Color.gray)
                                .if(isContentExist)
                        }
                    ),
                    .init(
                        label: isLabelExist ? "끝입니다\n정말\n정말\n끝" : "",
                        contentView: {
                            Text("Hel\nlo\nWor\nld!")
                                .typographyNew(variant: .title1)
                                .paragraphNew(variant: .title1)
                                .fixedSize()
                                .if(isContentExist)
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
