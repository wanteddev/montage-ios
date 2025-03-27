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
                switch size {
                case .xsmall: 6
                case .small: 8
                case .medium: 10
                case .large: 12
                case .xlarge: 14
                }
            }
        }
        
        internal func interactionCornerRadius(size: Size) -> CGFloat {
            switch self {
            case .person: 1000
            default: cornerRadius(size: size) + 8
            }
        }
    }
    
    public enum Size: String, CaseIterable {
        case xsmall
        case small
        case medium
        case large
        case xlarge
        
        internal var containerSize: CGSize {
            switch self {
            case .xsmall: .init(width: 24, height: 24)
            case .small: .init(width: 32, height: 32)
            case .medium: .init(width: 40, height: 40)
            case .large: .init(width: 48, height: 48)
            case .xlarge: .init(width: 56, height: 56)
            }
        }
        
        fileprivate var interactionSize: CGSize {
            .init(width: containerSize.width + 16, height: containerSize.height + 16)
        }
        
        fileprivate var badgeSize: CGSize {
            switch self {
            case .xsmall, .small: .init(width: 20, height: 20)
            case .medium: .init(width: 22, height: 22)
            case .large, .xlarge: .init(width: 24, height: 24)
            }
        }
    }
    
    // MARK: - Initializer
    
    private let imageUrl: String
    private let variant: Variant
    private let size: Size
    private let onTap: (() -> Void)?
    
    public init(_ imageUrl: String, variant: Variant, size: Size = .small, onTap: (() -> Void)? = nil) {
        self.imageUrl = imageUrl
        self.variant = variant
        self.size = size
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    
    public var body: some View {
        WebImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .backgroundStyle(SwiftUI.Color.semantic(.staticWhite))
        } placeholder: {
            Image(variant.placeholderImageName, bundle: .module)
                .resizable()
                .background( // WebImage에서 placeholder가 두 장 겹쳐지는 문제가 있어서 흰색 배경을 깔아줌
                    SwiftUI.Color.semantic(.backgroundNormal)
                )
        }
        .frame(width: size.containerSize.width, height: size.containerSize.height)
        .overlay {
            RoundedRectangle(cornerRadius: variant.cornerRadius(size: size))
                .strokeBorder(borderColor, lineWidth: borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: variant.cornerRadius(size: size)))
        .pushBadge(variant: .dot, size: pushBadgeSize)
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
                .onEnded { _ in
                    isPressed = false
                }
        )
        .onTapGesture {
            onTap?()
        }
    }
    
    private var pushBadge = false
    private var borderColor: SwiftUI.Color = .semantic(.lineAlternative)
    private var borderWidth: CGFloat = 1
    private var interactionDisabled = false
    
    public func pushBadge(_ pushBadge: Bool = true) -> Self {
        var zelf = self
        zelf.pushBadge = pushBadge
        return zelf
    }
    
    public func border(color: SwiftUI.Color = .semantic(.lineAlternative), width: CGFloat = 1) -> Self {
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

private extension Avatar {
    var pushBadgeSize: PushBadge.Size {
        switch size {
        case .xsmall, .small: return .xsmall
        case .medium, .large: return .small
        case .xlarge: return .medium
        }
    }
}
