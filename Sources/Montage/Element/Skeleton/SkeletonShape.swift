//
//  SkeletonText.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

extension Skeleton {
    struct Shape: View {
        private var shape: Skeleton.ShapeType
        private var variant: Skeleton.Variant
        private var position: Skeleton.Position
        private var length: Skeleton.Length
        
        private var configuration: Skeleton.Configuration? = nil
        
        @Binding var originalSize: CGSize
        
        private var cornerRadius: CGFloat {
            if let r = configuration?.borderRadius {
                return r
            } else {
                return .zero
            }
        }
        
        private var width: CGFloat {
            if let w = configuration?.width {
                return w
            } else {
                return originalSize.width * length.rawValue
            }
        }
        
        private var height: CGFloat {
            if let h = configuration?.height {
                return h
            } else {
                return originalSize.height
            }
        }
        
        private var foregroundColor: SwiftUI.Color {
            if let c = configuration?.color {
                return c
            } else {
                switch shape {
                case .rectangle:
                    return variant == .normal ? .component(.fillAlternative) : .alias(.staticWhite)
                case .ellipse:
                    return variant.foregroundColor
                }
            }
        }
        
        init(
            shape: ShapeType,
            variant: Skeleton.Variant,
            position: Skeleton.Position,
            length: Skeleton.Length,
            configuration: Skeleton.Configuration?,
            originalSize: Binding<CGSize>
        ) {
            self.shape = shape
            self.variant = variant
            self.position = position
            self.length = length
            self.configuration = configuration
            self._originalSize = originalSize
        }

        var body: some View {
            ZStack {
                switch shape {
                case .rectangle:
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(foregroundColor)
                case .ellipse:
                    Ellipse()
                        .foregroundStyle(foregroundColor)
                }
            }
            .frame(
                width: width,
                height: height
            )
            .opacity(configuration?.opacity ?? 1)
        }
    }

    public struct SkeletonShapeModifier: ViewModifier {
        var shape: Skeleton.ShapeType
        var model: Skeleton.Model
        var configuration: Skeleton.Configuration? = nil

        @Binding var show: Bool
        @State private var originalSize: CGSize = .zero
        
        public init(
            shape: Skeleton.ShapeType,
            show: Binding<Bool>,
            model: Skeleton.Model,
            configuration: Skeleton.Configuration? = nil
        ) {
            self.shape = shape
            self._show = show
            self.model = model
            self.configuration = configuration
        }
        
        public func body(content: Content) -> some View {
            content
                .opacity(show == false ? 1 : .zero)
                .readSize(onChange: { originalSize = $0 })
                .if(show) {
                    $0.overlay(alignment: model.position.alignment) {
                        Skeleton.Shape(
                            shape: shape,
                            variant: model.variant,
                            position: model.position,
                            length: model.length,
                            configuration: configuration,
                            originalSize: $originalSize
                        )
                        .frame(alignment: .leading)
                    }
                }
        }
    }
}

#Preview {
    Rectangle()
        .foregroundStyle(.black)
        .frame(width: 100, height: 100)
        .skeleton(shape: .rectangle, show: .constant(true))
        .clipShape(RoundedRectangle(cornerRadius: 12))
}
