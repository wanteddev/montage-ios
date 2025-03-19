//
//  Skeleton.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

public enum Skeleton {
    // MARK: - Types
    
    public enum Align: String, CaseIterable {
        case leading
        case center
        case trailing
        
        var horizontalAlignment: HorizontalAlignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
    }
    
    public enum Length: CGFloat, CaseIterable {
        case _100 = 1
        case _75 = 0.75
        case _50 = 0.5
        case _25 = 0.25
    }
    
    public enum Kind: CaseDescribable {
        case text(
            alignment: Align = .leading,
            lengths: [Length] = [._100],
            cornerRadius: CGFloat = 3,
            lineNumber: Int = 1
        )
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
                            ForEach(0 ..< lineNumber, id: \.self) { index in
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .frame(
                                        width: proxy.size.width * (lengths[safe: index]?.rawValue ?? 1.0),
                                        height: max(0, proxy.size.height / CGFloat(lineNumber) - 4)
                                    )
                                    .padding(.vertical, 2)
                            }
                        }
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height,
                            alignment: alignment.alignment
                        )
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
        
        private var color: SwiftUI.Color = .semantic(.fillNormal)
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

    struct PredefinedSkeletonModifier: ViewModifier {
        private let kind: Skeleton.Kind
        private let color: SwiftUI.Color
        private let opacity: CGFloat
        private let size: CGSize?

        private var isPresented: Bool
        
        init(
            isPresented: Bool,
            kind: Skeleton.Kind,
            color: SwiftUI.Color? = nil,
            opacity: CGFloat? = nil,
            size: CGSize? = nil
        ) {
            self.isPresented = isPresented
            self.kind = kind
            self.color = color ?? .semantic(.fillNormal)
            self.opacity = opacity ?? 1
            self.size = size
        }
        
        @State private var contentSize: CGSize = .zero
        
        func body(content: Content) -> some View {
            ZStack {
                content
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
                    .hidden()
                content
                    .skeleton(isPresented: isPresented) {
                        Skeleton.SkeletonView(kind)
                            .color(color)
                            .opacity(opacity)
                            .frame(
                                width: size?.width ?? contentSize.width,
                                height: size?.height ?? contentSize.height
                            )
                    }
            }
        }
    }
    
    struct SkeletonModifier: ViewModifier {
        private var isPresented: Bool
        @ViewBuilder private let skeletonView: () -> any View

        init(isPresented: Bool, @ViewBuilder skeletonView: @escaping () -> any View) {
            self.isPresented = isPresented
            self.skeletonView = skeletonView
        }
        
        @State var animationOpacity: CGFloat = 1
        
        func body(content: Content) -> some View {
            if isPresented {
                AnyView(skeletonView())
                    .opacity(animationOpacity)
                    .onChange(of: animationOpacity) { _ in
                        if animationOpacity == 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)) {
                                    animationOpacity = 0.5
                                }
                            }
                        } else if animationOpacity == 0.5 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)) {
                                    animationOpacity = 1
                                }
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)) {
                                animationOpacity = 0.5
                            }
                        }
                    }
            } else {
                content
            }
        }
    }
}
