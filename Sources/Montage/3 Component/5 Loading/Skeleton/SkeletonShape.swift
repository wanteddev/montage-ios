//
//  SkeletonText.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

//extension Skeleton {
//        
//        private var shape: ShapeType
//        
//        private var cornerRadius: CGFloat {
//            if let r = configuration?.borderRadius {
//                r
//            } else {
//                .zero
//            }
//        }
//        
//        private var width: CGFloat {
//            if let w = configuration?.width {
//                w
//            } else {
//                originalSize.width * length.rawValue
//            }
//        }
//        
//        private var height: CGFloat {
//            if let h = configuration?.height {
//                h
//            } else {
//                originalSize.height
//            }
//        }
//        
//        private var foregroundColor: SwiftUI.Color {
//            if let c = configuration?.color {
//                c
//            } else {
//                switch shape {
//                case .rectangle:
//                    .component(.fillAlternative)
//                case .circle:
//                    .component(.fillNormal)
//                }
//            }
//        }
//        
//        init(
//            shape: ShapeType,
//            position: Skeleton.Align,
//            length: Skeleton.Length,
//            configuration: Skeleton.Configuration?,
//            originalSize: Binding<CGSize>
//        ) {
//            self.shape = shape
//            self.position = position
//            self.length = length
//            self.configuration = configuration
//            _originalSize = originalSize
//        }
//
//        var body: some View {
//            ZStack {
//                switch shape {
//                case .rectangle:
//                    RoundedRectangle(cornerRadius: cornerRadius)
//                        .foregroundStyle(foregroundColor)
//                case .circle:
//                    Circle()
//                        .foregroundStyle(foregroundColor)
//                }
//            }
//            .frame(
//                width: width,
//                height: height
//            )
//            .opacity(configuration?.opacity ?? 1)
//        }
//    }
//
//    public struct ShapeSkeletonModifier: ViewModifier {
//        private let shape: Skeleton.ShapeType
//        private let color: SwiftUI.Color
//        private let opacity: CGFloat
//
//        @Binding var isPresented: Bool
//        @State private var originalSize: CGSize = .zero
//        
//        public init(
//            isPresented: Binding<Bool>,
//            shape: Skeleton.ShapeType,
//            color: SwiftUI.Color,
//            opacity: CGFloat
//        ) {
//            _isPresented = isPresented
//            self.shape = shape
//            self.color = color
//            self.opacity = opacity
//        }
//        
//        @State private var size: CGSize = .zero
//        
//        public func body(content: Content) -> some View {
//            ZStack {
//                content
//                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
//                    .hidden()
//                content
//                    .skeleton(isPresented: $isPresented) {
//                        switch shape {
//                        case .rectangle(let cornerRadius):
//                            RoundedRectangle(cornerRadius: cornerRadius)
//                                .foregroundStyle(color)
//                                .opacity(opacity)
//                                .frame(width: size.width, height: size.height)
//                        }
//                    }
//            }
//        }
//    }
//}
//
//#Preview {
//    Rectangle()
//        .foregroundStyle(.black)
//        .frame(width: 100, height: 100)
//        .skeleton(shape: .rectangle, show: .constant(true))
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//}
