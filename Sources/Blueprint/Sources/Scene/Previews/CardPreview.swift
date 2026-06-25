//
//  CardPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 4/22/25.
//

import Montage
import SwiftUI

struct CardPreview: View {
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

    private let imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/7/7d/%22_The_Calutron_Girls%22_Y-12_Oak_Ridge_1944_Large_Format_%2832093954911%29_%282%29.jpg"

    var body: some View {
        PreviewLayout {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Card(
                    thumbnail: {
                        Thumbnail(
                            urlString: invalidImageUrl ? "https://invalid-url" : imageUrl,
                            ratio: .r4x3
                        )
                        .width(thumbnailWidth)
                    },
                    skeleton: $skeletonIsOn,
                    title: multilineTitle ? "제목이 매우 매우 매우 매우 매우 매우 길어서 세 줄이 되면 어떻게 될까요?" : "제목"
                )
                .caption(showCaption ? "캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션캡션" : nil)
                .subCaption(showSubCaption ? "서브 캡션 서브 캡션" : nil)
                .extraCaption(showExtraCaption ? "추가 추가 캡션" : nil)
                .topContent {
                    if showTopContent {
                        HStack {
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                        }
                    }
                }
                .bottomContent {
                    if showBottomContent {
                        HStack {
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                            ContentBadge(text: "텍스트")
                        }
                    }
                }
                .if(showOverlayCaption || showOverlayButton) {
                    $0.overlay(
                        caption: showOverlayCaption ? "합격보상금 100만원" : nil,
                        buttonIcon: showOverlayButton
                            ? (bookmarkIsOn ? .bookmarkFill : .bookmark) : nil,
                        buttonColor: bookmarkIsOn
                            ? .semantic(.primaryNormal) : .semantic(.staticWhite),
                        onTapButton: showOverlayButton ? { bookmarkIsOn.toggle() } : nil
                    )
                }
                Spacer(minLength: 0)
            }
        } options: {
            ToggleOptionRow("skeleton", isOn: $skeletonIsOn)
            ToggleOptionRow("invalid image URL", isOn: $invalidImageUrl)
            SliderOptionRow("thumbnail width", value: $thumbnailWidth, in: 120...300)
            HStack {
                ToggleOption("multiline title", isOn: $multilineTitle)
                ToggleOption("caption", isOn: $showCaption)
            }
            HStack {
                ToggleOption("sub caption", isOn: $showSubCaption)
                ToggleOption("extra caption", isOn: $showExtraCaption)
            }
            HStack {
                ToggleOption("top content", isOn: $showTopContent)
                ToggleOption("bottom content", isOn: $showBottomContent)
            }
            HStack {
                ToggleOption("overlay caption", isOn: $showOverlayCaption)
                ToggleOption("overlay button", isOn: $showOverlayButton)
            }
        }
    }
}

#Preview {
    CardPreview()
}
