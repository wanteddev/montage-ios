//
//  SkeletonText.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

extension Skeleton {
    // MARK: - Types
    
    public enum Align: String, CaseIterable {
        case left
        case center
        case right
        
        var horizontalAlignment: HorizontalAlignment {
            switch self {
            case .left: .leading
            case .center: .center
            case .right: .trailing
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .left: .leading
            case .center: .center
            case .right: .trailing
            }
        }
    }
    
    public enum Length: CGFloat, CaseIterable {
        case _100 = 1
        case _75 = 0.75
        case _50 = 0.5
        case _25 = 0.25
    }
    
    public enum Kind {
        case text(alignment: Align = .left, lengths: [Length] = [._100], cornerRadius: CGFloat = 3, lineNumber: Int = 1)
        case rectangle(cornerRadius: CGFloat = 3)
        case circle
    }
    
    // MARK: - Views
    public struct SkeletonView: View {
        // MARK: - Initializer
        private let kind: Kind
        public init(_ kind: Kind) {
            self.kind = kind
        }

        // MARK: - Body
        
        @State private var size: CGSize = .zero
        public var body: some View {
            Group {
                switch kind {
                case .text(let alignment, let lengths, let cornerRadius, let lineNumber):
                    GeometryReader { proxy in
                        VStack(alignment: alignment.horizontalAlignment, spacing: 0) {
                            ForEach(0..<lineNumber, id: \.self) { index in
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .frame(
                                        width: proxy.size.width * (lengths[safe: index]?.rawValue ?? 1.0),
                                        height: max(0, proxy.size.height / CGFloat(lineNumber) - 4)
                                    )
                                    .padding(.vertical, 2)
                            }
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: alignment.alignment)
                    }
                case .rectangle(cornerRadius: let cornerRadius):
                    RoundedRectangle(cornerRadius: cornerRadius)
                case .circle:
                    Circle()
                }
            }
            .foregroundStyle(color)
            .opacity(opacity)
                
        }
        
        // MARK: - Modifiers
        
        private var color: SwiftUI.Color = .component(.fillNormal)
        private var opacity: CGFloat = 1
        
        public func color(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.color = color
            return zelf
        }
        
        public func opacity(_ opacity: CGFloat) -> Self {
            var zelf = self
            zelf.opacity = opacity
            return zelf
        }
    }

    public struct PredefinedSkeletonModifier: ViewModifier {
        private let kind: Skeleton.Kind
        private let color: SwiftUI.Color
        private let opacity: CGFloat

        private var isPresented: Bool
        @State private var originalSize: CGSize = .zero
        
        public init(
            isPresented: Bool,
            kind: Skeleton.Kind,
            color: SwiftUI.Color? = nil,
            opacity: CGFloat? = nil
        ) {
            self.isPresented = isPresented
            self.kind = kind
            self.color = color ?? .component(.fillNormal)
            self.opacity = opacity ?? 1
        }
        
        @State private var size: CGSize = .zero
        
        public func body(content: Content) -> some View {
            ZStack {
                content
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
                    .hidden()
                content
                    .skeleton(isPresented: isPresented) {
                        Skeleton.SkeletonView(kind)
                            .color(color)
                            .opacity(opacity)
                            .frame(width: size.width, height: size.height)
                    }
            }
        }
    }
}
