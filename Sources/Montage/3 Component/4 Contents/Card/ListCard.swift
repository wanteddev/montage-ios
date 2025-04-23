//
//  ListCard.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

extension Card {
    public struct List: View {
        
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
        private var extraCaption: (() -> any View)?
        private var topContent: (() -> any View)? = nil
        private var bottomContent: (() -> any View)? = nil
        private var leadingContent: (() -> any View)? = nil
        private var trailingContent: (() -> any View)? = nil
        
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
        
        public func leadingContent(_ content: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.leadingContent = content
            return zelf
        }
        
        public func trailingContent(_ content: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.trailingContent = content
            return zelf
        }
        
        // MARK: - Body

        public var body: some View {
            HStack(alignment: .center, spacing: .zero) {
                if let leadingContent {
                    AnyView(leadingContent())
                        .padding(.trailing, 12)
                }
                
                thumbnail()
                    .radius()
                    .border()
                    .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 12))
                    .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 8) {
                    if let topContent {
                        AnyView(topContent())
                            .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 3), size: CGSize(width: 48, height: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        AnyView(title())
                            .skeleton(isPresented: skeleton, kind: .text(lengths: [._75]), size: CGSize(width: 164, height: 20))
                        
                        if let caption {
                            AnyView(caption())
                                .skeleton(isPresented: skeleton, kind: .text(lengths: [._50]), size: CGSize(width: 164, height: 14))
                                .padding(.top, 4)
                        }
                        
                        if let extraCaption {
                            AnyView(extraCaption())
                                .skeleton(
                                    isPresented: skeleton,
                                    kind: .text(lengths: [._25]),
                                    size: CGSize(width: 164, height: 14)
                                )
                                .padding(.top, 4)
                        }
                    }
                    
                    if let bottomContent {
                        AnyView(bottomContent())
                            .skeleton(
                                isPresented: skeleton,
                                kind: .rectangle(cornerRadius: 3),
                                size: CGSize(width: 48, height: 20)
                            )
                    }
                }
                .padding(.trailing, 12)
                
                Spacer()
                
                if let trailingContent {
                    AnyView(trailingContent())
                }
            }
        }
    }
}
