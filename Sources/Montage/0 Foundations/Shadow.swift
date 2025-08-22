//
//  Shadow.swift
//  Views
//
//  Created by 김삼열 on 8/21/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public struct ShadowModifier: ViewModifier {
    public enum Level: CaseIterable {
        case none
        case xsmall
        case small
        case medium
        case large
        case xlarge
    }
    
    private enum Layer {
        case key
        case ambient
    }
    
    private let level: Level
    
    public init(level: Level) {
        self.level = level
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: .init(red: 0.09, green: 0.09, blue: 0.09, opacity: colorOpacity(layer: .ambient)),
                radius: radius(layer: .ambient),
                x: position(layer: .ambient).x,
                y: position(layer: .ambient).y
            )
            .shadow(
                color: .init(red: 0.09, green: 0.09, blue: 0.09, opacity: colorOpacity(layer: .key)),
                radius: radius(layer: .key),
                x: position(layer: .key).x,
                y: position(layer: .key).y
            )
    }
    
    private func colorOpacity(layer: Layer) -> CGFloat {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return layer == .ambient ? .zero : 0.1
        case .small:
            return 0.06
        case .medium:
            return 0.07
        case .large:
            return 0.08
        case .xlarge:
            return layer == .ambient ? 0.1 : 0.12
        }
    }
    
    private func radius(layer: Layer) -> CGFloat {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return layer == .ambient ? .zero : 1
        case .small:
            return layer == .ambient ? 2 : 3
        case .medium:
            return layer == .ambient ? 3 : 7.5
        case .large:
            return layer == .ambient ? 5 : 12
        case .xlarge:
            return layer == .ambient ? 7.5 : 19
        }
    }
    
    private func position(layer: Layer) -> CGPoint {
        switch level {
        case .none:
            return .zero
        case .xsmall:
            return CGPoint(x: 0, y: layer == .ambient ? .zero : 1)
        case .small:
            return CGPoint(x: 0, y: layer == .ambient ? 2 : 4)
        case .medium:
            return CGPoint(x: 0, y: layer == .ambient ? 4 : 10)
        case .large:
            return CGPoint(x: 0, y: layer == .ambient ? 6 : 16)
        case .xlarge:
            return CGPoint(x: 0, y: layer == .ambient ? 10 : 24)
        }
    }
}

extension View {
    public func shadow(_ level: ShadowModifier.Level) -> some View {
        modifier(ShadowModifier(level: level))
    }
}
