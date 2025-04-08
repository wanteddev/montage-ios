//
//  Triangle.swift
//  SwiftUITest
//
//  Created by 김삼열 on 4/9/24.
//

import SwiftUI

public struct Triangle: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines([
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.maxY),
            ])
        }
    }
}
