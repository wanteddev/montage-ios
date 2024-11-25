//
//  Avatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

public enum Avatar {
    public enum Variant {
        case icon
        case image(Image)
        case url(URL?)
    }
    
    public enum Size {
        case xsmall
        case small
        case medium
        case large
        case xlarge
        
        var imageSize: CGSize {
            switch self {
            case .xsmall: .init(width: 16, height: 16)
            case .small: .init(width: 21.3, height: 21.3)
            case .medium: .init(width: 26.67, height: 26.67)
            case .large: .init(width: 32, height: 32)
            case .xlarge: .init(width: 37.3, height: 37.3)
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .xsmall: 4
            case .small: 5.3
            case .medium: 6.67
            case .large: 8
            case .xlarge: 9.3
            }
        }
        
        var componentSize: CGSize {
            switch self {
            case .xsmall: .init(width: 24, height: 24)
            case .small: .init(width: 32, height: 32)
            case .medium: .init(width: 40, height: 40)
            case .large: .init(width: 48, height: 48)
            case .xlarge: .init(width: 56, height: 56)
            }
        }
    }
}
