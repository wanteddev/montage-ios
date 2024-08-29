//
//  View+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import SwiftUI

extension View {
    public func elevation(_ elevation: Elevation) -> Self {
        let currentView = self
        
        guard elevation != .none else {
            return currentView
        }
        
        let descriptor = elevation.descriptor
        
        guard let color = descriptor.color else {
            return currentView
        }
        
        let _ = currentView.shadow(
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

// MARK: - Component

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

extension View {
    public func tooltip(
        config: TooltipConfigurable,
        show: Binding<Bool>,
        content: String
    ) -> some View {
        modifier(
            Tooltip.TooltipModifier(
                config: config,
                show: show,
                content: content
            )
        )
    }
    
    public func tooltip(
        variant: Tooltip.Variant = .extended,
        position: Tooltip.Position,
        show: Binding<Bool>,
        inverse: Bool = false,
        showCloseButton: Bool = false,
        content: String,
        action: (() -> Void)? = nil
    ) -> some View {
        tooltip(
            config: Tooltip.DefaultTooltipConfig(
                variant: variant,
                position: position,
                inverse: inverse,
                showCloseButton: showCloseButton,
                action: action
            ),
            show: show,
            content: content
        )
    }
    
    public func tooltip(
        position: Tooltip.Position,
        show: Binding<Bool>,
        content: String
    ) -> some View {
        tooltip(
            config: Tooltip.DefaultTooltipConfig(position: position),
            show: show,
            content: content
        )
    }
    
    public func tooltip(
        show: Binding<Bool>,
        content: String
    ) -> some View {
        tooltip(
            config: Tooltip.DefaultTooltipConfig(),
            show: show,
            content: content
        )
    }
}

extension View {
    public func topNavigation(
        variant: Bar.TopNavigation.Variant = .normal,
        title: String,
        left: Bar.TopNavigation.Resource.Left? = nil,
        backgroundColorResolvable: ColorResolvable? = nil,
        actions: [Bar.TopNavigation.Resource.Action] = []
    ) -> some View {
        modifier(
            Bar.TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title,
                left: left,
                backgroundColorResolvable: backgroundColorResolvable,
                actions: actions
            )
        )
    }
    
    public func topNavigation(
        variant: Bar.TopNavigation.Variant = .normal,
        title: String,
        left: Bar.TopNavigation.Resource.Left? = nil,
        backgroundColorResolvable: ColorResolvable? = nil,
        actions: [Bar.TopNavigation.Resource.Action] = [],
        withBottom model: ActionArea.Bottom.Model<AnyView>
    ) -> some View {
        modifier(
            Bar.TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title,
                left: left,
                backgroundColorResolvable: backgroundColorResolvable,
                actions: actions,
                model: model
            )
        )
    }
}
