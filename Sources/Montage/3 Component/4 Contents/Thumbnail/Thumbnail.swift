//
//  Thumbnail.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import SDWebImageSwiftUI
import SwiftUI

public struct Thumbnail: View {
    
    // MARK: - Initializer
    
    private let url: URL?
    private let content: ((Image) -> any View)?
    private let placeholder: (() -> any View)?
    
    public init(
        url: URL?,
        content: ((Image) -> any View)? = nil,
        placeholder: (() -> any View)? = nil
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    // MARK: - Modifiers
    
    private var ratio: Ratio = .r1x1
    private var width: CGFloat? = nil
    private var height: CGFloat? = nil
    private var radius = false
    private var border = false
    
    public func ratio(_ ratio: Ratio, width: CGFloat) -> Self {
        var zelf = self
        zelf.ratio = ratio
        zelf.width = width
        zelf.height = nil
        return zelf
    }
    
    public func ratio(_ ratio: Ratio, height: CGFloat) -> Self {
        var zelf = self
        zelf.ratio = ratio
        zelf.width = nil
        zelf.height = height
        return zelf
    }
    
    public func radius(_ radius: Bool = true) -> Self {
        var zelf = self
        zelf.radius = radius
        return zelf
    }
    
    public func border(_ border: Bool = true) -> Self {
        var zelf = self
        zelf.border = border
        return zelf
    }
    
    // MARK: - Body
    
    public var body: some View {
        WebImage(url: url) { phase in
            switch phase {
            case .success(let image):
                if let content {
                    AnyView(content(image))
                } else {
                    image
                        .resizable()
                        .scaledToFill()
                }
            default:
                SwiftUI.Color.clear
            }
        }
        .background {
            Group {
                if let placeholder {
                    AnyView(placeholder())
                } else {
                    SwiftUI.Color.semantic(.fillAlternative)
                }
            }
        }
        .modifying {
            if let width {
                $0.frame(width: width, height: width * (ratio.size.height / ratio.size.width))
            } else if let height {
                $0.frame(width: height * (ratio.size.width / ratio.size.height), height: height)
            } else {
                $0
            }
        }
        .clipped()
        .cornerRadius(radius ? 12 : 0)
        .overlay {
            RoundedRectangle(cornerRadius: radius ? 12 : 0)
                .strokeBorder(SwiftUI.Color.semantic(.lineNormal), lineWidth: border ? 1 : 0)
        }
    }
}

