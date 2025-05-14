//
//  NormalCardPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 4/22/25.
//


import SwiftUI
import Montage

struct NormalCardPreview: View {
    @State private var multilineTitle: Bool = false
    @State private var bookmarkIsOn: Bool = false
    @State private var skeletonIsOn: Bool = false
    @State private var showCaption: Bool = false
    @State private var showSubCaption: Bool = false
    @State private var showExtraCaption: Bool = false
    @State private var showTopContent: Bool = false
    @State private var showBottomContent: Bool = false
    @State private var showOverlayCaption: Bool = false
    @State private var showOverlayButton: Bool = false
    @State private var invalidImageUrl: Bool = false
    @State private var thumbnailWidth: CGFloat = 180
    
    private let imageUrl = "https://upload.wikimedia.org/wikipedia/commons/7/7d/%22_The_Calutron_Girls%22_Y-12_Oak_Ridge_1944_Large_Format_%2832093954911%29_%282%29.jpg"
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    NormalCard(
                        thumbnail: {
                            Thumbnail(urlString: invalidImageUrl ? "https://invalid-url" : imageUrl, ratio: .r4x3)
                                .width(thumbnailWidth)
                        },
                        skeleton: $skeletonIsOn,
                        title: multilineTitle ? "제목이 매우 매우 매우 매우 매우 매우 길어서 세 줄이 되면 어떻게 될까요?" : "제목"
                    )
                    .caption(showCaption ? "캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션" : nil)
                    .subCaption(showSubCaption ? "서브 캡션" : nil)
                    .extraCaption(showExtraCaption ? "추가 캡션" : nil)
                    .topContent(showTopContent ? {
                        HStack {
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                        }
                    } : nil)
                    .bottomContent(showBottomContent ? {
                        HStack {
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                        }
                    } : nil)
                    .if(showOverlayCaption || showOverlayButton) {
                        $0.overlay(
                            caption: showOverlayCaption ? "오버레이캡션" : nil,
                            buttonIcon: showOverlayButton ? (bookmarkIsOn ? .bookmarkFill : .bookmark) : nil,
                            buttonColor: bookmarkIsOn ? .semantic(.primaryNormal) : .semantic(.staticWhite),
                            onTapButton: showOverlayButton ? { bookmarkIsOn.toggle() } : nil
                        )
                    }
                    Spacer(minLength: 0)
                }
                
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
                        SwiftUI.Slider(value: $thumbnailWidth, in: 120...300)
                        Text("\(Int(thumbnailWidth))")
                    }
                    
                    HStack {
                        Text("multiline title")
                        Control.Switch($multilineTitle)
                        
                        Text("caption")
                        Control.Switch($showCaption)
                    }
                    
                    HStack {
                        Text("sub caption")
                        Control.Switch($showSubCaption)
                        
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
                        Text("overlay caption")
                        Control.Switch($showOverlayCaption)
                        
                        Text("overlay button")
                        Control.Switch($showOverlayButton)
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
    NormalCardPreview()
}
