//
//  SwiftUIView.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

extension Card {
    public struct Normal: View {
        
        // MARK: - Initializer
        
        private let thumbnail: () -> Thumbnail
        @Binding private var skeleton: Bool
        private let title: () -> any View

        public init(
            thumbnail: @escaping () -> Thumbnail,
            skeleton: Binding<Bool>,
            title: @escaping () -> any View
        ) {
            self.thumbnail = thumbnail
            _skeleton = skeleton
            self.title = title
        }
        
        // MARK: - Modifiers
        
        private var caption: (() -> any View)?
        private var overlayCaption: String?
        private var extraCaption: (() -> any View)?
        private var overlayButtonIcon: Montage.Icon?
        private var onTapOverlayButton: (() -> Void)?
        private var topContent: (() -> any View)?
        private var bottomContent: (() -> any View)?
        
        public func caption(_ caption: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.caption = caption
            return zelf
        }
        
        public func extraCaption(_ extraCaption: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.extraCaption = extraCaption
            return zelf
        }
        
        public func overlay(
            caption: String? = nil,
            buttonIcon: Montage.Icon? = nil,
            onTapButton: (() -> Void)? = nil
        ) -> Self {
            var zelf = self
            zelf.overlayCaption = caption
            zelf.overlayButtonIcon = buttonIcon
            zelf.onTapOverlayButton = onTapButton
            return zelf
        }
        
        public func topContent(_ content: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.topContent = content
            return zelf
        }
        
        public func bottomContent(_ content: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.bottomContent = content
            return zelf
        }
        
        // MARK: - Body
        @State private var thumbnailWidth: CGFloat = 0
        
        public var body: some View {
            Grid(alignment: .leading, verticalSpacing: 12) {
                GridRow {
                    thumbnail()
                        .radius()
                        .border()
                        .modifier(
                            ThumbnailOverlayModifier(
                                caption: overlayCaption,
                                buttonIcon: overlayButtonIcon,
                                onTapButton: onTapOverlayButton
                            )
                        )
                        .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .onGeometryChange(for: CGFloat.self, of: { $0.size.width }, action: { thumbnailWidth = $0 })
                
                GridRow {
                    VStack(alignment: .leading, spacing: 8) {
                        if let topContent {
                            AnyView(topContent())
                                .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 3), size: CGSize(width: 48, height: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            AnyView(title())
                                .skeleton(isPresented: skeleton, kind: .text(lengths: [._100]), size: CGSize(width: thumbnailWidth - 12, height: 20))
                            
                            if let caption {
                                AnyView(caption())
                                    .skeleton(isPresented: skeleton, kind: .text(lengths: [._50]), size: CGSize(width: thumbnailWidth - 12, height: 14))
                            }
                            
                            if let extraCaption {
                                AnyView(extraCaption())
                                    .skeleton(isPresented: skeleton, kind: .text(lengths: [._25]), size: CGSize(width: thumbnailWidth - 12, height: 14))
                            }
                        }
                        
                        if let bottomContent {
                            AnyView(bottomContent())
                                .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 3), size: CGSize(width: 48, height: 20))
                        }
                    }
                    .padding(.horizontal, 6)
                    .frame(maxWidth: thumbnailWidth, alignment: .leading)
                }
            }
        }
    }
}

extension Card.Normal {
    private struct ThumbnailOverlayModifier: ViewModifier {
        private let caption: String?
        private let buttonIcon: Montage.Icon?
        private let onTapButton: (() -> Void)?

        public init(
            caption: String? = nil,
            buttonIcon: Montage.Icon? = nil,
            onTapButton: (() -> Void)? = nil
        ) {
            self.caption = caption
            self.buttonIcon = buttonIcon
            self.onTapButton = onTapButton
        }

        private let gradientColors: [SwiftUI.Color] = [
            1.0, 0.97, 0.95, 0.92, 0.89, 0.86, 0.82, 0.77, 0.71, 0.64, 0.57, 0.48, 0.38, 0.26, 0.14, 0
        ].map { .semantic(.staticBlack).opacity($0) }
        
        public func body(content: Content) -> some View {
            content
                .if(!caption.isNilOrEmpty || buttonIcon != nil) {
                    $0.overlay(alignment: .top) {
                        ZStack {
                            HStack(spacing: 4) {
                                if let caption {
                                    HStack(spacing: 0) {
                                        Text(caption)
                                            .montage(variant: .label2, weight: .bold, semantic: .staticWhite)
                                            .paragraph(variant: .label2)
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.bottom, 6)
                                }
                                
                                if let buttonIcon {
                                    HStack(spacing: 0) {
                                        Spacer(minLength: 0)
                                        Montage.IconButton(
                                            icon: buttonIcon,
                                            iconColor: SwiftUI.Color.semantic(.staticWhite)
                                        ) {
                                            onTapButton?()
                                        }
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

