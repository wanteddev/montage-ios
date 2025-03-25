//
//  Push.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/26.
//

import Pretendard
import SwiftUI

extension Badge {
    public struct Push: View {
        // MARK: - Types
        
        public enum Variant: Equatable, CaseDescribable {
            case dot, new, number(Int)
        }
        
        public enum Size: String, CaseIterable {
            case xsmall, small, medium
        }
        
        public enum Position: CaseDescribable {
            case top(HorizontalPosition = .center)
            case center(HorizontalPosition = .center)
            case bottom(HorizontalPosition = .center)
            
            public enum HorizontalPosition: String, CaseIterable {
                case leading, center, trailing
            }
        }
        
        // MARK: - Initializer
        
        private let variant: Variant
        public init(variant: Variant) {
            self.variant = variant
        }
        
        // MARK: - Body
        
        public var body: some View {
            Group {
                switch variant {
                case .dot:
                    Circle()
                        .frame(width: dotSize.width, height: dotSize.height)
                        .foregroundColor(backgroundColor)
                case .new:
                    Text("N")
                        .font(font)
                        .frame(minWidth: textMinSize.width)
                        .frame(height: textMinSize.height)
                        .foregroundStyle(fontColor)
                        .padding(fontPadding)
                        .background {
                            Circle()
                                .foregroundColor(backgroundColor)
                        }
                case .number(let number):
                    Text("\(number)")
                        .font(font)
                        .frame(minWidth: textMinSize.width)
                        .frame(height: textMinSize.height)
                        .foregroundStyle(fontColor)
                        .padding(fontPadding)
                        .background {
                            RoundedRectangle(cornerRadius: 1000)
                                .foregroundColor(backgroundColor)
                        }
                }
            }
        }
        
        // MARK: - Modifiers
        private var size: Size = .xsmall
        private var fontColor: SwiftUI.Color = .semantic(.staticWhite)
        private var backgroundColor: SwiftUI.Color = .semantic(.primaryNormal)
        
        public func size(_ size: Size) -> Self {
            var zelf = self
            zelf.size = size
            return zelf
        }
        
        public func fontColor(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.fontColor = color
            return zelf
        }
        
        public func backgroundColor(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.backgroundColor = color
            return zelf
        }
    }
}

private extension Badge.Push {
    var font: Font? {
        switch size {
        case .xsmall, .small: .montage(variant: .caption2, weight: .bold)
        case .medium: .montage(variant: .label1, weight: .bold)
        }
    }
    
    var fontPadding: EdgeInsets {
        switch size {
        case .xsmall: .init(top: 1, leading: 4, bottom: 1, trailing: 4)
        case .small: .init(top: 3, leading: 6, bottom: 3, trailing: 6)
        case .medium: .init(top: 2, leading: 7, bottom: 2, trailing: 7)
        }
    }
    
    var dotSize: CGSize {
        switch size {
        case .xsmall: .init(width: 4, height: 4)
        case .small: .init(width: 6, height: 6)
        case .medium: .init(width: 8, height: 8)
        }
    }
    
    var textMinSize: CGSize {
        switch size {
        case .xsmall: .init(width: 8, height: 14)
        case .small: .init(width: 8, height: 14)
        case .medium: .init(width: 10, height: 20)
        }
    }
}

extension Badge.Push {
    public struct Modifier: ViewModifier {
        private let variant: Variant
        private let size: Size
        private let fontColor: SwiftUI.Color
        private let backgroundColor: SwiftUI.Color
        private let position: Position
        private let inset: CGSize
        
        public init(
            variant: Variant,
            size: Size = .xsmall,
            fontColor: SwiftUI.Color = .semantic(.staticWhite),
            backgroundColor: SwiftUI.Color = .semantic(.primaryNormal),
            position: Position = .top(.trailing),
            inset: CGSize = .zero
        ) {
            self.variant = variant
            self.size = size
            self.fontColor = fontColor
            self.backgroundColor = backgroundColor
            self.position = position
            self.inset = inset
        }
        
        @State private var contentSize: CGSize = .zero

        public func body(content: Content) -> some View {
            ZStack {
                content
                    .onGeometryChange(for: CGSize.self, of: { $0.size }, action: {
                        contentSize = $0
                    })
                Badge.Push(variant: variant)
                    .size(size)
                    .fontColor(fontColor)
                    .backgroundColor(backgroundColor)
                    .offset(anchorPosition)
                    .offset(offset)
            }
        }
        
        private var anchorPosition: CGSize {
            let width = switch position {
            case .top(let horizontalAlignment),
                    .center(let horizontalAlignment),
                    .bottom(let horizontalAlignment):
                switch horizontalAlignment {
                case .leading: -contentSize.width / 2
                case .center: CGFloat.zero
                case .trailing: contentSize.width / 2
                }
            }
            let height = switch position {
            case .top: -contentSize.height / 2
            case .center: CGFloat.zero
            case .bottom: contentSize.height / 2
            }
            return .init(width: width, height: height)
        }
        
        private var offset: CGSize {
            let width = switch position {
            case .top(let horizontalAlignment),
                    .center(let horizontalAlignment),
                    .bottom(let horizontalAlignment):
                switch horizontalAlignment {
                case .leading: inset.width / 2
                case .center: CGFloat.zero
                case .trailing: -inset.width / 2
                }
            }
            let height = switch position {
            case .top: inset.height / 2
            case .center: CGFloat.zero
            case .bottom: -inset.height / 2
            }
            return .init(width: width, height: height)
        }
    }
}
