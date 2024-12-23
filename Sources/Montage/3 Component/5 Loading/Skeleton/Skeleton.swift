//
//  Skeleton.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

public enum Skeleton {
    public enum Align {
        case left
        case center
        case right
        
        var alignment: Alignment {
            switch self {
            case .left: .leading
            case .center: .center
            case .right: .trailing
            }
        }
    }
    
    public enum Length: CGFloat {
        case _100 = 1
        case _75 = 0.75
        case _50 = 0.5
        case _25 = 0.25
    }
    
    public enum ShapeType {
        case rectangle
        case circle
    }
    
    public struct Model {
        let align: Skeleton.Align
        let length: Skeleton.Length
        
        public init(
            align: Skeleton.Align = .left,
            length: Skeleton.Length = ._100
        ) {
            self.align = align
            self.length = length
        }
    }
    
    public struct Configuration {
        let width: CGFloat?
        let height: CGFloat?
        let color: SwiftUI.Color?
        let borderRadius: CGFloat?
        let opacity: Double?
        
        public init(
            width: CGFloat? = nil,
            height: CGFloat? = nil,
            color: SwiftUI.Color? = nil,
            borderRadius: CGFloat? = nil,
            opacity: Double? = nil
        ) {
            self.width = width
            self.height = height
            self.color = color
            self.borderRadius = borderRadius
            self.opacity = opacity
        }
    }
}
