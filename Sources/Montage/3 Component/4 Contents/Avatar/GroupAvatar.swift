//
//  GroupAvatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

extension Avatar {
    public struct Group: View {
        // MARK: - Types
        
        public enum Size: String, CaseIterable {
            case xsmall
            case small
            
            var space: CGFloat {
                switch self {
                case .xsmall: 6
                case .small: 8
                }
            }
        }
        
        // MARK: - Initializer
        
        private let imageUrls: [String]
        private let variant: Avatar.Variant
        private let size: Size
        private let onTap: ((_ index: Int) -> Void)?
        
        public init(
            _ imageUrls: [String],
            variant: Avatar.Variant,
            size: Size,
            onTap: ((_ index: Int) -> Void)? = nil
        ) {
            self.imageUrls = Array(imageUrls.prefix(5))
            self.variant = variant
            self.size = size
            self.onTap = onTap
        }
        
        // MARK: - Body
        
        public var body: some View {
            HStack(spacing: 10) {
                ZStack {
                    ForEach(imageUrls.indices, id: \.self) { index in
                        ZStack {
                            Avatar(imageUrls[index], variant: variant, size: avatartSize) {
                                onTap?(index)
                            }
                            .interactionDisabled()
                            
                            if index < imageUrls.count - 1 {
                                RoundedRectangle(cornerRadius: variant.cornerRadius(size: avatartSize))
                                    .scaleEffect(1.1)
                                    .offset(x: avatartSize.containerSize.width - size.space)
                                    .blendMode(.destinationOut)
                            }
                        }
                        .compositingGroup()
                        .frame(
                            width: avatartSize.containerSize.width,
                            height: avatartSize.containerSize.height
                        )
                        .offset(
                            x: avatartSize.containerSize
                                .width * CGFloat(index) - (size.space * CGFloat(index))
                        )
                    }
                }
                .offset(x: -(avatartSize.containerSize.width - size.space) * CGFloat(imageUrls.count - 1) / 2)
                .frame(
                    width: avatartSize.containerSize
                        .width * CGFloat(imageUrls.count) - (size.space * CGFloat(imageUrls.count - 1)),
                    height: avatartSize.containerSize.height
                )
                
                if let trailingButtonLabel, let onTrailingButtonTap {
                    Button.TextButton(variant: .assistive, size: .small, text: trailingButtonLabel) {
                        onTrailingButtonTap()
                    }
                }
            }
        }
        
        // MARK: - Modifiers
        
        private var trailingButtonLabel: String?
        private var onTrailingButtonTap: (() -> Void)?
        
        public func trailingButton(_ label: String, onTap: @escaping () -> Void) -> Self {
            var zelf = self
            zelf.trailingButtonLabel = label
            zelf.onTrailingButtonTap = onTap
            return zelf
        }
    }
}

private extension Avatar.Group {
    var avatartSize: Avatar.Size {
        size == .xsmall ? .xsmall : .small
    }
}
