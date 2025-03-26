//
//  Button.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import SwiftUI

public enum Button {}

public enum SolidButton {
    public enum Variant: String {
        case primary, assistive
    }
    
    public enum Size: String {
        case small, medium, large
    }
}

public enum OutlinedButton {
    public enum Variant: String {
        case primary, secondary, assistive
    }
    
    public enum Size: String {
        case small, medium, large
    }
}

public enum TextButton {
    public enum Variant: String {
        case primary, assistive
    }
    
    public enum Size: String {
        case small, medium
    }
}

public struct MontageButton: View {
    // MARK: - Types
    internal enum Style {
        case solid, outlined, text
    }
    
    public enum Variant: String, CaseIterable {
        case primary, secondary, assistive
    }
    
    public enum Size: String, CaseIterable {
        case small, medium, large
    }
    
    // MARK: - Initializers
    
    private let style: Style
    private let variant: Variant
    private let size: Size
    private let text: String?
    private let leadingIcon: Icon?
    private let trailingIcon: Icon?
    private let handler: (() -> Void)?
    
    internal init(
        style: Style,
        variant: Variant = .primary,
        size: Size = .medium,
        text: String? = nil,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) {
        self.style = style
        self.variant = variant
        self.size = size
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.text = text
        self.handler = handler
    }
    
    public static func solid(
        variant: SolidButton.Variant = .primary,
        size: SolidButton.Size = .large,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .solid,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
    }
    
    public static func solid(
        variant: SolidButton.Variant = .primary,
        size: SolidButton.Size = .large,
        icon: Icon,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .solid,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            leadingIcon: icon,
            handler: handler
        )
    }
    
    public static func outlined(
        variant: OutlinedButton.Variant = .primary,
        size: OutlinedButton.Size = .large,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .outlined,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
    }
    
    public static func outlined(
        variant: OutlinedButton.Variant = .primary,
        size: OutlinedButton.Size = .large,
        icon: Icon,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .outlined,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            leadingIcon: icon,
            handler: handler
        )
    }
    
    public static func text(
        variant: TextButton.Variant = .primary,
        size: TextButton.Size = .medium,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .text,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .medium,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
    }
    
    // MARK: - Modifiers
    
    private var disable: Bool = false
    private var contentColor: SwiftUI.Color? = nil
    private var customBackgroundColor: SwiftUI.Color? = nil
    private var customBorderColor: SwiftUI.Color? = nil
    private var fontVariant: Typography.Variant? = nil
    private var fontWeight: Typography.Weight? = nil
    
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    public func contentColor(_ contentColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.contentColor = contentColor
        return zelf
    }
    
    public func backgroundColor(_ backgroundColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.customBackgroundColor = backgroundColor
        return zelf
    }
    
    public func borderColor(_ borderColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.customBorderColor = borderColor
        return zelf
    }
    
    public func fontVariant(_ fontVariant: Typography.Variant?) -> Self {
        var zelf = self
        zelf.fontVariant = fontVariant
        return zelf
    }
    
    public func fontWeight(_ fontWeight: Typography.Weight?) -> Self {
        var zelf = self
        zelf.fontWeight = fontWeight
        return zelf
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    
    public var body: some View {
        HStack(alignment: .center, spacing: 4) {
            if let leadingIcon {
                icon(leadingIcon)
            }
            if let text {
                Text(text)
                    .montage(
                        variant: fontVariant ?? typoVariant,
                        weight: fontWeight ?? typoWeight,
                        color: foregroundColor
                    )
            }
            if let trailingIcon {
                icon(trailingIcon)
            }
        }
        .padding(edgeInsets)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColor)
        }
        .background {
            Decorate.Interaction(
                state: isPressed ? .pressed : .normal,
                variant: interactionVariant,
                color: interactionColor
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .padding(.vertical, -interactionVerticalOffset)
            .padding(.horizontal, -interactionHorizontalOffset)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPressed = value.translation == .zero
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .onTapGesture {
            handler?()
        }
        .allowsHitTesting(disable == false)
    }
}

private extension MontageButton {
    var backgroundColor: SwiftUI.Color {
        switch style {
        case .solid:
            if disable {
                .semantic(.interactionDisable)
            } else {
                if let customBackgroundColor {
                    customBackgroundColor
                } else {
                    switch variant {
                    case .primary: .semantic(.primaryNormal)
                    case .assistive: .semantic(.fillNormal)
                    default: .clear
                    }
                }
            }
        case .outlined:
            if !disable, let customBackgroundColor {
                customBackgroundColor
            } else {
                .clear
            }
        case .text: .clear
        }
    }
    
    var borderColor: SwiftUI.Color {
        if style == .outlined {
            if disable {
                .semantic(.lineNormal)
            } else {
                if let customBorderColor {
                    customBorderColor
                } else {
                    switch variant {
                    case .primary:
                        .semantic(.primaryNormal)
                    case .secondary, .assistive:
                        .semantic(.lineNeutral)
                    }
                }
            }
        } else {
            .clear
        }
    }
    
    var foregroundColor: SwiftUI.Color {
        switch style {
        case .solid:
            if disable {
                .semantic(.labelAssistive)
            } else if let contentColor {
                contentColor
            } else {
                switch variant {
                case .primary: .semantic(.staticWhite)
                case .assistive: .semantic(.labelNeutral)
                default: .clear
                }
            }
        case .outlined, .text:
            if disable {
                .semantic(.labelDisable)
            } else if let contentColor {
                contentColor
            } else {
                switch variant {
                case .primary, .secondary: .semantic(.primaryNormal)
                case .assistive: .semantic(style == .outlined ? .labelNormal : .labelAlternative)
                }
            }
        }
    }

    func icon(_ i: Icon) -> some View {
        Image.montage(i)
            .resizable()
            .frame(
                width: iconSize.width,
                height: iconSize.height
            )
            .foregroundStyle(foregroundColor)
    }
    
    var iconSize: CGSize {
        switch size {
        case .small:
            .init(width: 16, height: 16)
        case .medium:
                .init(width: style == .text ? 20 : 18, height: style == .text ? 20 : 18)
        case .large:
            .init(width: 20, height: 20)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .small:
            style == .text ? .label1 : .label2
        case .medium:
            style == .text ? .body1 : .body2
        case .large:
            .body1
        }
    }
    
    var typoWeight: Typography.Weight {
        switch variant {
        case .primary, .secondary: .bold
        case .assistive: style == .text ? .bold : .medium
        }
    }
    
    var cornerRadius: CGFloat {
        if style == .text {
            6.0
        } else {
            switch size {
            case .large: 12.0
            case .medium: 10.0
            case .small: 8.0
            }
        }
    }
    
    var edgeInsets: EdgeInsets {
        if style == .text {
            .init()
        } else {
            switch size {
            case .small:
                text == nil && leadingIcon != nil
                ? .init(top: 7, leading: 7, bottom: 7, trailing: 7)
                : .init(top: 7, leading: 14, bottom: 7, trailing: 14)
            case .medium:
                text == nil && leadingIcon != nil
                ? .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                : .init(top: 9, leading: 20, bottom: 9, trailing: 20)
            case .large:
                text == nil && leadingIcon != nil
                ? .init(top: 12, leading: 12, bottom: 12, trailing: 12)
                : .init(top: 12, leading: 28, bottom: 12, trailing: 28)
            }
        }
    }
    
    var interactionVariant: Decorate.Interaction.Variant {
        switch variant {
        case .primary: .normal
        case .secondary, .assistive: .light
        }
    }
    
    var interactionColor: Color.Semantic {
        switch variant {
        case .primary: style == .solid ? .labelNormal : .primaryNormal
        case .secondary, .assistive: .labelNormal
        }
    }

    var interactionVerticalOffset: CGFloat { style == .text ? 4 : 0 }
    var interactionHorizontalOffset: CGFloat { style == .text ? 7 : 0 }
}
