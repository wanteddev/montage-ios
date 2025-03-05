//
//  SwiftUIView.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

extension Card {
    public struct Normal: View {
        @Binding private var skeleton: Bool
        private let imageRatio: Ratio
        private let imageWidth: CGFloat
        private let imageLoader: () -> any View
        private let title: (() -> any View)?
        private let caption: (() -> any View)?
        private let extraCaption: (() -> any View)?
        private let topContent: (() -> any View)?
        private let bottomContent: (() -> any View)?

        @State var overlay: OverlayModel = .init()

        public init(
            skeleton: Binding<Bool>,
            imageRatio: Ratio = .r3x2,
            imageWidth: CGFloat,
            @ViewBuilder imageLoader: @escaping () -> any View,
            title: (() -> any View)? = nil,
            caption: (() -> any View)? = nil,
            extraCpation: (() -> any View)? = nil,
            topContent: (() -> any View)? = nil,
            bottomContent: (() -> any View)? = nil
        ) {
            _skeleton = skeleton
            self.imageRatio = imageRatio
            self.imageWidth = imageWidth
            self.imageLoader = imageLoader
            self.title = title
            self.caption = caption
            extraCaption = extraCpation
            self.topContent = topContent
            self.bottomContent = bottomContent
        }

        public var body: some View {
            VStack(spacing: 12) {
                ZStack {
                    ThumbnailController(
                        ratio: imageRatio,
                        portrait: false,
                        width: imageWidth,
                        imageLoader: imageLoader
                    )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .strokeBorder(SwiftUI.Color.alias(.lineAlternative), lineWidth: 1)
                )
                .modifier(
                    ThumbnailOverlayModifier(
                        model: overlay
                    )
                )
                .skeleton(isPresented: skeleton, kind: .rectangle())
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        if let topContent {
                            AnyView(topContent())
                                .skeleton(isPresented: skeleton, kind: .rectangle())
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }

                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: .zero) {
                        if let title {
                            AnyView(title())
                                .skeleton(isPresented: skeleton, kind: .text())
                        }

                        if let caption {
                            AnyView(caption())
                                .skeleton(isPresented: skeleton, kind: .text())
                                .padding(.top, 4)
                        }

                        if let extraCaption {
                            AnyView(extraCaption())
                                .skeleton(isPresented: skeleton, kind: .text())
                                .padding(.top, 4)
                        }
                    }

                    if let bottomContent {
                        AnyView(bottomContent())
                            .skeleton(isPresented: skeleton, kind: .rectangle())
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                }
                .frame(width: imageWidth)
                .padding(.horizontal, 6)
            }
        }
    }
}

extension Card.Normal {
    private struct ThumbnailOverlayModifier: ViewModifier {
        private let model: OverlayModel

        init(model: OverlayModel) {
            self.model = model
        }

        private var show: Bool {
            if let caption = model.caption, caption.isEmpty == false {
                true
            } else if model.toggleIcon != nil {
                true
            } else {
                false
            }
        }

        private let gradientColors: [SwiftUI.Color] = [
            .alias(.staticBlack),
            .alias(.staticBlack).opacity(0.97),
            .alias(.staticBlack).opacity(0.95),
            .alias(.staticBlack).opacity(0.92),
            .alias(.staticBlack).opacity(0.89),
            .alias(.staticBlack).opacity(0.86),
            .alias(.staticBlack).opacity(0.82),
            .alias(.staticBlack).opacity(0.77),
            .alias(.staticBlack).opacity(0.71),
            .alias(.staticBlack).opacity(0.64),
            .alias(.staticBlack).opacity(0.57),
            .alias(.staticBlack).opacity(0.48),
            .alias(.staticBlack).opacity(0.38),
            .alias(.staticBlack).opacity(0.26),
            .alias(.staticBlack).opacity(0.14),
            .alias(.staticBlack).opacity(0)
        ]

        public func body(content: Content) -> some View {
            content
                .if(show) {
                    $0.overlay(alignment: .top) {
                        ZStack {
                            HStack(spacing: 4) {
                                if let caption = model.caption {
                                    HStack {
                                        Text(caption)
                                            .montage(variant: .label2, weight: .bold, alias: .staticWhite)
                                            .paragraph(variant: .label2)
                                        Spacer()
                                    }
                                    .padding(.bottom, 6)
                                }

                                if let icons = model.toggleIcon {
                                    Montage.Button.IconButton(
                                        icon: model.toggleIsOn ? icons.on : icons.off,
                                        iconColor: SwiftUI.Color.alias(.staticWhite)
                                    ) {
                                        model.onToggleTap?()
                                    }
                                }
                            }
                            .padding(.all, 14)
                        }
                        .background(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .init(x: 0, y: 0),
                                endPoint: .init(x: 0, y: 1)
                            )
                            .opacity(0.35)
                        )
                    }
                }
        }
    }
}

extension Card.Normal {
    /// Card Normal의 Overlay를 나타내기 위한 Model
    /// toggleIcon을 전달하지 않으면 Icon이 표시되지 않습니다.
    public struct OverlayModel {
        let caption: String?
        let toggleIsOn: Bool
        let toggleIcon: (on: Montage.Icon, off: Montage.Icon)?
        let onToggleTap: (() -> Void)?

        public init(
            caption: String? = nil,
            toggleIsOn: Bool = false,
            toggleIcon: (on: Montage.Icon, off: Montage.Icon)? = nil,
            onToggleTap: (() -> Void)? = nil
        ) {
            self.caption = caption
            self.toggleIsOn = toggleIsOn
            self.toggleIcon = toggleIcon
            self.onToggleTap = onToggleTap
        }
    }
}

extension Card.Normal {
    /// Card Normal의 overlay를 표시합니다.
    public func overlay(_ model: OverlayModel) -> Self {
        overlay = model
        return self
    }
}

import Pretendard

#Preview {
    let _ = try? Pretendard.registerFonts()
    Card.Normal(
        skeleton: .constant(false),
        imageWidth: 240,
        imageLoader: {
            AsyncImage(
                url: URL(string: "https://developer.apple.com/xcode/images/xcode-15-hero-large_2x.webp")!
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("placeholder", bundle: .module)
                        .resizable()
                        .scaledToFill()
                }
            }
        },
        title: {
            Text("제목")
                .montage(variant: .body1, weight: .bold)
                .paragraph(variant: .body1)
        },
        caption: {
            Text("캡션")
                .montage(variant: .label2, weight: .medium, alias: .labelAlternative)
                .paragraph(variant: .label2)
        },
        extraCpation: {
            Text("추가 캡션")
                .montage(variant: .label2, weight: .medium, alias: .labelAlternative)
                .paragraph(variant: .label2)
        },
        topContent: {
            HStack {
                Badge.Content(text: "텍스트")
                Badge.Content(text: "텍스트")
                Badge.Content(text: "텍스트")
                Badge.Content(text: "텍스트")
            }
        },
        bottomContent: {
            HStack {
                Badge.Content(text: "텍스트")
                Badge.Content(text: "텍스트")
                Badge.Content(text: "텍스트")
            }
        }
    )
    .overlay(.init(
        caption: "캡션",
        toggleIsOn: true,
        toggleIcon: (.bookmarkFill, .bookmark),
        onToggleTap: { print("hello") }
    ))
}
