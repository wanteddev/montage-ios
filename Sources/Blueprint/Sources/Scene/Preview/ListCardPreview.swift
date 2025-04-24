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
    @State private var thumbnailWidth: CGFloat = 120
    
    private let imageUrl = "https://upload.wikimedia.org/wikipedia/commons/7/7d/%22_The_Calutron_Girls%22_Y-12_Oak_Ridge_1944_Large_Format_%2832093954911%29_%282%29.jpg"
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                Card.List(
                    thumbnail: {
                        Thumbnail(urlString: invalidImageUrl ? "https://invalid-url" : imageUrl, ratio: .r4x3)
                            .width(thumbnailWidth)
                    },
                    skeleton: $skeletonIsOn,
                    title: multilineTitle ? "제목이 매우 매우 매우 매우 매우 매우 매우 길어서 세 줄이 되면 어떻게 될까요?" : "제목"
                )
                .caption(showCaption ? "캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션" : nil)
                .extraCaption(showExtraCaption ? "추가 캡션" : nil)
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
                        Text("thumbnail width")
                        SwiftUI.Slider(value: $thumbnailWidth, in: 80...200)
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
            .onChange(of: "\(thumbnailWidth)\(showLeadingContent)\(showTrailingContent)") { _ in
                skeletonIsOn = false
            }
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ListCardPreview()
}
