//
//  VerticalProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct VerticalProgressTrackerPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var progress: Int = 1
    @State private var isLabelExist = true
    @State private var isAccessoryExist = true
    @State private var isContentExist = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                
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
                    .init(
                        label: isLabelExist ? "끝입니다\n정말\n정말\n끝" : "",
                        contentView: {
                            Text("Hel\nlo\nWor\nld!")
                                .typography(variant: .title1)
                                .paragraph(variant: .title1)
                                .fixedSize()
                                .if(isContentExist)
                        }
                    )
                ]
            )
            
            Text("Options").bold()
            
            HStack {
                Text("Label")
                Control.switch(checked: isLabelExist) {
                    isLabelExist = $0
                    isAccessoryExist = $0
                }
                Text("Label Accessory")
                Control.switch(checked: isAccessoryExist) { isAccessoryExist = $0 }
                Text("Content")
                Control.switch(checked: isContentExist) { isContentExist = $0 }
            }
            
            HStack {
                Spacer()
                Button(variant: .outlined, text: "Previous") {
                    progress = max(1, progress - 1)
                }
                .disable(progress <= 1)
                
                Button(variant: .outlined, text: "Next") {
                    progress = min(progress + 1, 5)
                }
                .disable(progress >= 5)
                Spacer()
            }
            
            Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    VerticalProgressTrackerPreview()
}
