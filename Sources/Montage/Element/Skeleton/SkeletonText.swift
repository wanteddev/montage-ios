//
//  SkeletonText.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

extension Skeleton {
    private struct Text: View {
        private var position: Skeleton.Align
        private var length: Skeleton.Length
        
        private var configuration: Skeleton.Configuration? = nil
        
        @Binding var originalSize: CGSize
        @State private var animate = false
        
        private var cornerRadius: CGFloat {
            if let r = configuration?.borderRadius {
                r
            } else {
                3
            }
        }
        
        private var width: CGFloat {
            if let w = configuration?.width {
                w
            } else {
                originalSize.width * length.rawValue
            }
        }
        
        private var height: CGFloat {
            if let h = configuration?.height {
                h
            } else {
                originalSize.height
            }
        }
        
        private var foregroundColor: SwiftUI.Color {
            if let c = configuration?.color {
                c
            } else {
                .component(.fillNormal)
            }
        }
        
        init(
            position: Skeleton.Align,
            length: Skeleton.Length,
            configuration: Skeleton.Configuration?,
            originalSize: Binding<CGSize>
        ) {
            self.position = position
            self.length = length
            self.configuration = configuration
            _originalSize = originalSize
        }

        public var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(foregroundColor)
                    .padding(.vertical, 2)
            }
            .frame(
                width: width,
                height: height + 4
            )
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
            .opacity(configuration?.opacity ?? 1)
        }
    }

    public struct SkeletonTextModifier: ViewModifier {
        private let model: Skeleton.Model
        private var configuration: Skeleton.Configuration? = nil

        @Binding var show: Bool
        @State private var originalSize: CGSize = .zero
        
        public init(
            show: Binding<Bool>,
            model: Skeleton.Model,
            configuration: Skeleton.Configuration? = nil
        ) {
            _show = show
            self.model = model
            self.configuration = configuration
        }
        
        public func body(content: Content) -> some View {
            content
                .opacity(show == false ? 1 : .zero)
                .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { originalSize = $0 })
                .if(show) {
                    $0.overlay(alignment: model.align.alignment) {
                        Skeleton.Text(
                            position: model.align,
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
    let text = ""
    if text.isEmpty {
        VStack {
            Text("Skeleton")
                .skeleton(
                    show: .constant(true),
                    model: .init(
                        align: .center,
                        length: ._100
                    ),
                    configuration: .init(
                        width: nil,
                        height: nil,
                        color: nil,
                        borderRadius: nil,
                        opacity: nil
                    )
                )
        }
    } else {
        Text(text)
    }
}
