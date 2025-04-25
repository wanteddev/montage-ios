//
//  Thumbnail.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import SDWebImageSwiftUI
import SwiftUI

public struct Thumbnail: View {
    
    // MARK: - Ratio Enum
    
    public enum Ratio {
        case r21x9, r2x1, r16x9, r1_618x1, r16x10, r3x2, r4x3, r5x4
        case r1x1
        case r4x5, r3x4, r2x3, r10x16, r1x1_618, r9x16, r1x2, r9x21
        
        public var rawValue: CGFloat {
            size.width / size.height
        }
        
        var size: CGSize {
            switch self {
            // 가로가 긴 비율
            case .r21x9: .init(width: 21, height: 9)
            case .r2x1: .init(width: 2, height: 1)
            case .r16x9: .init(width: 16, height: 9)
            case .r1_618x1: .init(width: 1.618, height: 1)
            case .r16x10: .init(width: 16, height: 10)
            case .r3x2: .init(width: 3, height: 2)
            case .r4x3: .init(width: 4, height: 3)
            case .r5x4: .init(width: 5, height: 4)
            
            // 정사각형
            case .r1x1: .init(width: 1, height: 1)
            
            // 세로가 긴 비율
            case .r4x5: .init(width: 4, height: 5)
            case .r3x4: .init(width: 3, height: 4)
            case .r2x3: .init(width: 2, height: 3)
            case .r10x16: .init(width: 10, height: 16)
            case .r1x1_618: .init(width: 1, height: 1.618)
            case .r9x16: .init(width: 9, height: 16)
            case .r1x2: .init(width: 1, height: 2)
            case .r9x21: .init(width: 9, height: 21)
            }
        }
    }
    
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

