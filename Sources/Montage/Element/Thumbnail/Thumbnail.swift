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
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                Image("placeholder", bundle: Bundle.module)
                    .resizable()
                    .aspectRatio(.init(width: 1, height: 1), contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .clipped()
            }
        }
        .aspectRatio(resolvedRatioSize(), contentMode: .fill)
    }
    
    private func resolvedRatioSize() -> CGSize {
        portrait ? .init(width: ratio.size.height, height: ratio.size.width) : ratio.size
    }
}

struct ThumbnailControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Thumbnail(ratio: .r16x10, portrait: true)
            Thumbnail(ratio: .r1x1, portrait: false)
            Thumbnail(ratio: .r3x2, portrait: false)
            Thumbnail(ratio: .r3x2, portrait: false)
            Thumbnail(ratio: .r3x2, portrait: true)
        }
    }
}

struct ThumbnailController_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailControllerPreview()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

