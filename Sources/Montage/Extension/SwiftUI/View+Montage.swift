//
//  View+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import SwiftUI

public extension View {
    public func elevation(_ elevation: Montage.Elevation) -> Self {
        var currentView = self
        var descriptor = elevation.descriptor
        
        currentView.shadow(
            color: Color(descriptor.color.withAlphaComponent(descriptor.alpha)),
            radius: descriptor.blur,
            x: descriptor.offset.width,
            y: descriptor.offset.height
        )
        
        return currentView
    }
}
