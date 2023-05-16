//
//  Thumbnail.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import SwiftUI

public struct Thumbnail: View {
    @State public var ratio: Ratio
    @State public var portrait: Bool
    @State public var image: UIImage
    
    public init(ratio: Ratio, portrait: Bool, image: UIImage?) {
        self.ratio = ratio
        self.portrait = portrait
        self.image = image ?? UIImage(named: "placeholder", in: Bundle.module, with: nil)!
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
        }
        .aspectRatio(resolvedRatioSize(), contentMode: portrait ? .fill : .fit)
    }
    
    private func resolvedRatioSize() -> CGSize {
        portrait ? .init(width: ratio.size.height, height: ratio.size.width) : ratio.size
    }
}

struct ThumbnailControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Thumbnail(ratio: .r3x2, portrait: true, image: nil)
            Thumbnail(ratio: .r1x1, portrait: false, image: nil)
        }
    }
}

struct ThumbnailController_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailControllerPreview()
            .padding()
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
    }
}

