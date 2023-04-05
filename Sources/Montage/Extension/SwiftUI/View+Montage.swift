//
//  View+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import SwiftUI

public extension View {
    public func elevation(_ elevation: Elevation) -> Self {
        var currentView = self
        
        guard elevation != .none else {
            return currentView
        }
        
        var descriptor = elevation.descriptor
        
        guard let color = descriptor.color else {
            return currentView
        }
        
        currentView.shadow(
            color: SwiftUI.Color(color.withAlphaComponent(descriptor.alpha)),
            radius: descriptor.blur,
            x: descriptor.offset.width,
            y: descriptor.offset.height
        )
        
        return currentView
    }
}
