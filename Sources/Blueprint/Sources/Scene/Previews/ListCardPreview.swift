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
        PreviewLayout {
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
                    Checkbox(state: .unchecked)
                }
            }
            .trailingContent {
                if showTrailingContent {
                    Image.icon(.chevronRight)
                        .foregroundStyle(SwiftUI.Color.semantic(.labelAssistive))
                }
            }
            .onChange(of: "\(thumbnailWidth)\(showLeadingContent)\(showTrailingContent)") { _ in
                skeletonIsOn = false
            }
        } options: {
            HStack {
                ToggleOption("skeleton", isOn: $skeletonIsOn)
                ToggleOption("invalid image URL", isOn: $invalidImageUrl)
            }
            SliderOptionRow("thumbnail width", value: $thumbnailWidth, in: 80...200, step: 1)
            HStack {
                ToggleOption("multiline title", isOn: $multilineTitle)
                ToggleOption("caption", isOn: $showCaption)
                ToggleOption("extra caption", isOn: $showExtraCaption)
            }
            HStack {
                ToggleOption("top content", isOn: $showTopContent)
                ToggleOption("bottom content", isOn: $showBottomContent)
            }
            HStack {
                ToggleOption("leading content", isOn: $showLeadingContent)
                ToggleOption("trailing content", isOn: $showTrailingContent)
            }
        }
    }
}

#Preview {
    ListCardPreview()
}
