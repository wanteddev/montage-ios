//
//  ListCard.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

extension Card {
    public struct List<
        ImageLoader: View,
        T: View,
        C: View,
        EC: View,
        TC: View,
        BC: View,
        LC: View,
        RC: View
    >: View {
        @Binding private var skeleton: Bool
        private let imageRatio: Ratio
        private let imageWidth: CGFloat
        private let imageLoader: () -> ImageLoader
        private let title: () -> T
        private let caption: () -> C
        private let extraCaption: () -> EC
        private let topContent: () -> TC
        private let bottomContent: () -> BC
        private let leftContent: () -> LC
        private let rightContent: () -> RC
        
        public init(
            skeleton: Binding<Bool>,
            imageRatio: Ratio = .r3x2,
            imageWidth: CGFloat,
            @ViewBuilder imageLoader: @escaping (() -> ImageLoader),
            @ViewBuilder title: @escaping (() -> T) = { EmptyView() },
            @ViewBuilder caption: @escaping (() -> C) = { EmptyView() },
            @ViewBuilder extraCaption: @escaping (() -> EC) = { EmptyView() },
            @ViewBuilder topContent: @escaping (() -> TC) = { EmptyView() },
            @ViewBuilder bottomContent: @escaping (() -> BC) = { EmptyView() },
            @ViewBuilder leftContent: @escaping (() -> LC) = { EmptyView() },
            @ViewBuilder rightContent: @escaping (() -> RC) = { EmptyView() }
        ) {
            _skeleton = skeleton
            self.imageRatio = imageRatio
            self.imageWidth = imageWidth
            self.imageLoader = imageLoader
            self.title = title
            self.caption = caption
            self.extraCaption = extraCaption
            self.topContent = topContent
            self.bottomContent = bottomContent
            self.leftContent = leftContent
            self.rightContent = rightContent
        }

        public var body: some View {
            HStack(alignment: .center, spacing: .zero) {
                leftContent()
                    .padding(.trailing, 12)
                
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
                .skeleton(isPresented: skeleton, kind: .rectangle())
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 8) {
                    topContent()
                        .skeleton(isPresented: skeleton, kind: .rectangle())
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        title()
                            .skeleton(isPresented: skeleton, kind: .text())
                        
                        caption()
                            .skeleton(isPresented: skeleton, kind: .text())
                            .padding(.top, 4)
                        
                        extraCaption()
                            .skeleton(isPresented: skeleton, kind: .text())
                            .padding(.top, 4)
                    }
                    
                    bottomContent()
                        .skeleton(isPresented: skeleton, kind: .rectangle())
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                .padding(.trailing, 12)
                
                Spacer()
                
                rightContent()
            }
            .frame(height: imageWidth * (imageRatio.size.height / imageRatio.size.width))
        }
    }
}

import Pretendard

#Preview {
    let _ = try? Pretendard.registerFonts()
    Card.List(
        skeleton: .constant(false),
        imageWidth: 96,
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
        extraCaption: {
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
        },
        leftContent: {
            Control.Checkbox(state: .unchecked)
        },
        rightContent: {
            Image.montage(.chevronRight)
                .foregroundStyle(SwiftUI.Color.alias(.labelAssistive))
        }
    )
}
