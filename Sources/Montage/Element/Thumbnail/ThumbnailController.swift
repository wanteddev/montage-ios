//
//  ThumbnailController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import SwiftUI

public struct ThumbnailController<V: View>: View {
    @State public var ratio: Ratio
    @State public var portrait: Bool
    @State public var width: CGFloat
    @State public var placeholder: UIImage
    
    public var imageLoader: (() -> V)?
    
    public init(
        ratio: Ratio,
        portrait: Bool,
        width: CGFloat,
        image: UIImage?
    ) {
        self.ratio = ratio
        self.portrait = portrait
        self.width = width
        self.placeholder = UIImage(named: "placeholder", in: Bundle.module, with: nil)!
        self.imageLoader = nil
    }
    
    public init(
        ratio: Ratio,
        portrait: Bool,
        width: CGFloat,
        @ViewBuilder imageLoader: @escaping (() -> V)
    ) {
        self.ratio = ratio
        self.portrait = portrait
        self.width = width
        self.placeholder = UIImage(named: "placeholder", in: Bundle.module, with: nil)!
        self.imageLoader = imageLoader
    }
    
    public var body: some View {
        ZStack {
            if let imageLoader {
                imageLoader()
            } else {
                GeometryReader { proxy in
                    Image(uiImage: placeholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                }
            }
        }
        .frame(width: width, height: width * (resolvedRatioSize().height / resolvedRatioSize().width))
    }
    
    private func resolvedRatioSize() -> CGSize {
        portrait ? .init(width: ratio.size.height, height: ratio.size.width) : ratio.size
    }
}

struct ThumbnailControllerPreview: View {
    let url = URL(string: "https://developer.apple.com/xcode/images/xcode-15-hero-large_2x.webp")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                ThumbnailController(
                    ratio: .r1x1,
                    portrait: false,
                    width: 240
                ) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                        } else {
                            ProgressView()
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    ThumbnailController<EmptyView>(ratio: .r1x1, portrait: false, width: 100, image: nil)
                    ThumbnailController<EmptyView>(ratio: .r5x4, portrait: false, width: 100, image: nil)
                    ThumbnailController<EmptyView>(ratio: .r4x3, portrait: false, width: 100, image: nil)
                    
                }
                
                HStack(alignment: .top) {
                    ThumbnailController<EmptyView>(ratio: .r3x2, portrait: false, width: 100, image: nil)
                    ThumbnailController<EmptyView>(ratio: .r16x10, portrait: false, width: 100, image: nil)
                }
                
                HStack(alignment: .top) {
                    ThumbnailController<EmptyView>(ratio: .r1_618x1, portrait: false, width: 100, image: nil)
                    ThumbnailController<EmptyView>(ratio: .r16x9, portrait: false, width: 100, image: nil)
                    ThumbnailController<EmptyView>(ratio: .r2x1, portrait: false, width: 100, image: nil)
                }
                
                HStack(alignment: .top) {
                    ThumbnailController<EmptyView>(ratio: .r21x9, portrait: false, width: 100, image: nil)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ThumbnailController_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailControllerPreview()
    }
}

