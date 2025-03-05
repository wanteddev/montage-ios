//
//  Avatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SDWebImageSwiftUI
import SwiftUI

public struct Avatar: View {
    // MARK: - Types
    
    public enum Variant: String, CaseIterable {
        case person, company, academy
        
        fileprivate var placeholderImageName: String {
            switch self {
            case .person:
                "avatarPlaceholderPerson"
            case .company:
                "avatarPlaceholderCompany"
            case .academy:
                "avatarPlaceholderAcademy"
            }
        }
        
        internal func cornerRadius(size: Size) -> CGFloat {
            switch self {
            case .person: 1000
            default:
                size.containerSize.width / 4
            }
        }
        
        internal func interactionCornerRadius(size: Size) -> CGFloat {
            switch self {
            case .person: 1000
            default: cornerRadius(size: size) + 8
            }
        }
    }
    
    public enum Size: CaseDescribable {
        case xsmall
        case small
        case medium
        case large
        case xlarge
        case custom(_ side: CGFloat)
        
        internal var containerSize: CGSize {
            switch self {
            case .xsmall: .init(width: 24, height: 24)
            case .small: .init(width: 32, height: 32)
            case .medium: .init(width: 40, height: 40)
            case .large: .init(width: 48, height: 48)
            case .xlarge: .init(width: 56, height: 56)
            case .custom(let side): .init(width: side, height: side)
            }
        }
        
        fileprivate var interactionSize: CGSize {
            .init(width: containerSize.width + 16, height: containerSize.height + 16)
        }
        
        fileprivate var badgeSize: CGSize {
            .init(width: containerSize.width * 0.55, height: containerSize.height * 0.55)
        }
    }
    
    // MARK: - Initializer
    
    private let imageUrl: String
    private let variant: Variant
    private let size: Size
    private let onTap: (() -> Void)?
    
    public init(_ imageUrl: String, variant: Variant, size: Size, onTap: (() -> Void)? = nil) {
        self.imageUrl = imageUrl
        self.variant = variant
        self.size = size
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    
    public var body: some View {
        WebImage(url: URL(string: imageUrl)) {
            if let image = $0.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(variant.placeholderImageName, bundle: .module)
                    .resizable()
            }
        }
        .frame(width: size.containerSize.width, height: size.containerSize.height)
        .overlay {
            RoundedRectangle(cornerRadius: variant.cornerRadius(size: size))
                .strokeBorder(borderColor, lineWidth: borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: variant.cornerRadius(size: size)))
        .overlay {
            if variant == .person, pushBadge {
                Badge.Push(variant: .dot)
                    .frame(width: size.badgeSize.width, height: size.badgeSize.height)
                    .position(x: size.containerSize.width)
            }
        }
        .background {
            if !interactionDisabled {
                Decorate.Interaction(
                    state: isPressed ? .pressed : .normal,
                    variant: .normal,
                    color: .labelNormal
                )
                .frame(width: size.interactionSize.width, height: size.interactionSize.height)
                .clipShape(RoundedRectangle(cornerRadius: variant.interactionCornerRadius(size: size)))
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPressed = value.translation == .zero
                }
                .onEnded { value in
                    isPressed = false
                    if value.translation == .zero {
                        onTap?()
                    }
                }
        )
    }
    
    private var pushBadge = false
    private var borderColor: SwiftUI.Color = .alias(.lineAlternative)
    private var borderWidth: CGFloat = 1
    private var interactionDisabled = false
    
    public func pushBadge(_ pushBadge: Bool = true) -> Self {
        var zelf = self
        zelf.pushBadge = pushBadge
        return zelf
    }
    
    public func border(color: SwiftUI.Color = .alias(.lineAlternative), width: CGFloat = 1) -> Self {
        var zelf = self
        zelf.borderColor = color
        zelf.borderWidth = width
        return zelf
    }
    
    internal func interactionDisabled(_ interactionDisabled: Bool = true) -> Self {
        var zelf = self
        zelf.interactionDisabled = interactionDisabled
        return zelf
    }
}
