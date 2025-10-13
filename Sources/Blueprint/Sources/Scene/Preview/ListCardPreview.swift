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
                
                ListCard(
                    thumbnail: {
                        Thumbnail(urlString: invalidImageUrl ? "https://invalid-url" : imageUrl, ratio: .r4x3)
                            .width(thumbnailWidth)
                    },
                    skeleton: $skeletonIsOn,
                    title: multilineTitle ? "제목이 매우 매우 매우 매우 매우 매우 매우 길어서 세 줄이 되면 어떻게 될까요?" : "제목"
                )
                .caption(showCaption ? "캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션" : nil)
                .extraCaption(showExtraCaption ? "추가 캡션" : nil)
                .topContent {
                    if showTopContent {
                        HStack {
                            ContentBadge(text: "텍스트")
                        }
                    }
                }
                .bottomContent {
                    if showBottomContent {
                        HStack {
                            ContentBadge(text: "텍스트")
                        }
                    }
                }
                .leadingContent {
                    if showLeadingContent {
                        Control.checkbox(state: .unchecked)
                    }
                }
                .trailingContent {
                    if showTrailingContent {
                        Image.icon(.chevronRight)
                            .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                    }
                }
                
                Text("Options").bold()
                
                Group {
                    HStack {
                        Text("skeleton")
                        Control.switch(checked: skeletonIsOn) { skeletonIsOn = $0 }
                    }
                    
                    HStack {
                        Text("invalid image URL")
                        Control.switch(checked: invalidImageUrl) { invalidImageUrl = $0 }
                    }
                    
                    HStack {
                        Text("thumbnail width")
                        SwiftUI.Slider(value: $thumbnailWidth, in: 80...200)
                        Text("\(Int(thumbnailWidth))")
                    }
                    
                    HStack {
                        Text("multiline title")
                        Control.switch(checked: multilineTitle) { multilineTitle = $0 }
                        
                        Text("caption")
                        Control.switch(checked: showCaption) { showCaption = $0 }
                        
                        Text("extra caption")
                        Control.switch(checked: showExtraCaption) { showExtraCaption = $0 }
                    }
                    
                    HStack {
                        Text("top content")
                        Control.switch(checked: showTopContent) { showTopContent = $0 }
                        
                        Text("bottom content")
                        Control.switch(checked: showBottomContent) { showBottomContent = $0 }
                    }
                    
                    HStack {
                        Text("leading content")
                        Control.switch(checked: showLeadingContent) { showLeadingContent = $0 }
                        
                        Text("trailing content")
                        Control.switch(checked: showTrailingContent) { showTrailingContent = $0 }
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
