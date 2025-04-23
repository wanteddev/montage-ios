//
//  ListCardPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 4/22/25.
//


import SwiftUI
import Montage

struct ListCardPreview: View {
    @State private var multilineTitle: Bool = false
    @State private var skeletonIsOn: Bool = false
    @State private var showCaption: Bool = false
    @State private var showExtraCaption: Bool = false
    @State private var showTopContent: Bool = false
    @State private var showBottomContent: Bool = false
    @State private var showLeadingContent: Bool = false
    @State private var showTrailingContent: Bool = false
    @State private var invalidImageUrl: Bool = false
    @State private var selectedRatio: Ratio = .r3x2
    @State private var thumbnailWidth: CGFloat = 96
    
    private let imageUrl = "https://developer.apple.com/xcode/images/xcode-15-hero-large_2x.webp"
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                Card.List(
                    thumbnail: {
                        Thumbnail(
                            url: URL(string: invalidImageUrl ? "https://invalid-url" : imageUrl),
                            content: {
                                $0.resizable()
                                    .scaledToFill()
                            },
                            placeholder: {
                                Rectangle()
                                    .fill(SwiftUI.Color.semantic(.lineNeutral))
                                    .overlay {
                                        Image.montage(.image)
                                            .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                                    }
                            }
                        )
                        .ratio(selectedRatio, width: thumbnailWidth)
                    },
                    skeleton: $skeletonIsOn,
                    title: {
                        Text(multilineTitle ? "제목이 길어서 두 줄이 되면 어떻게 될까요?" : "제목")
                            .montage(variant: .body1, weight: .bold)
                            .paragraph(variant: .body1)
                    }
                )
                .caption(showCaption ? {
                    Text("캡션")
                        .montage(variant: .label2, weight: .medium, semantic: .labelAlternative)
                        .paragraph(variant: .label2)
                } : nil)
                .extraCaption(showExtraCaption ? {
                    Text("추가 캡션")
                        .montage(variant: .label2, weight: .medium, semantic: .labelAlternative)
                        .paragraph(variant: .label2)
                } : nil)
                .topContent(showTopContent ? {
                    HStack {
                        ContentBadge(text: "텍스트")
                        ContentBadge(text: "텍스트")
                    }
                } : nil)
                .bottomContent(showBottomContent ? {
                    HStack {
                        ContentBadge(text: "텍스트")
                        ContentBadge(text: "텍스트")
                    }
                } : nil)
                .leadingContent(showLeadingContent ? {
                    Control.checkbox(state: .unchecked)
                } : nil)
                .trailingContent(showTrailingContent ? {
                    Image.montage(.chevronRight)
                        .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                } : nil)
                
                Text("Options").bold()
                
                Group {
                    HStack {
                        Text("skeleton")
                        Control.Switch($skeletonIsOn)
                    }
                    
                    HStack {
                        Text("invalid image URL")
                        Control.Switch($invalidImageUrl)
                    }
                    
                    HStack {
                        Text("Ratio")
                        Picker("Ratio", selection: $selectedRatio) {
                            // 가로가 긴 비율
                            Group {
                                Text("21:9").tag(Ratio.r21x9)
                                Text("2:1").tag(Ratio.r2x1)
                                Text("16:9").tag(Ratio.r16x9)
                                Text("1.618:1").tag(Ratio.r1_618x1)
                                Text("16:10").tag(Ratio.r16x10)
                                Text("3:2").tag(Ratio.r3x2)
                                Text("4:3").tag(Ratio.r4x3)
                                Text("5:4").tag(Ratio.r5x4)
                            }
                            
                            // 정사각형
                            Text("1:1").tag(Ratio.r1x1)
                            
                            
                            // 세로가 긴 비율
                            Group {
                                Text("4:5").tag(Ratio.r4x5)
                                Text("3:4").tag(Ratio.r3x4)
                                Text("2:3").tag(Ratio.r2x3)
                                Text("10:16").tag(Ratio.r10x16)
                                Text("1:1.618").tag(Ratio.r1x1_618)
                                Text("9:16").tag(Ratio.r9x16)
                                Text("1:2").tag(Ratio.r1x2)
                                Text("9:21").tag(Ratio.r9x21)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                    }
                    
                    HStack {
                        Text("thumbnail width")
                        SwiftUI.Slider(value: $thumbnailWidth, in: 60...150)
                        Text("\(Int(thumbnailWidth))")
                    }
                    
                    HStack {
                        Text("multiline title")
                        Control.Switch($multilineTitle)
                        
                        Text("caption")
                        Control.Switch($showCaption)
                        
                        Text("extra caption")
                        Control.Switch($showExtraCaption)
                    }
                    
                    HStack {
                        Text("top content")
                        Control.Switch($showTopContent)
                        
                        Text("bottom content")
                        Control.Switch($showBottomContent)
                    }
                    
                    HStack {
                        Text("leading content")
                        Control.Switch($showLeadingContent)
                        
                        Text("trailing content")
                        Control.Switch($showTrailingContent)
                    }
                }
                .font(.caption)
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ListCardPreview()
}
