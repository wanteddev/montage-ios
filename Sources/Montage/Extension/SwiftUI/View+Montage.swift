//
//  View+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import SwiftUI

extension View {
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
    
    public func paragraph(variant: Typography.Variant) -> some View {
        lineSpacing(variant.lineSpacing).padding(.vertical, variant.padding)
    }
}

extension View {
    public func toast(_ model: Binding<Toast.Model?>) -> some View {
        self.modifier(Toast.ToastModifier(model: model))
    }
}

extension View {
    public func snackBar(_ model: Binding<SnackBar.Model?>) -> some View {
        self.modifier(SnackBar.SnackBarModifier(model: model))
    }
}
