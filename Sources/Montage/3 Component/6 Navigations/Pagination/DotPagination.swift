//
//  DotPagination.swift
//  Montage
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI

extension Pagination {
    public struct Dot: View {
        public enum Variant {
            case normal, white
        }
        
        public enum Size {
            case normal, small
        }
        
        @Binding private var selectedPage: Int
        private let totalPages: Int
        private let maxNumberOfVisibleDots: Int = 5
        public init(selectedPage: Binding<Int>, totalPages: Int) {
            self._selectedPage = selectedPage
            self.totalPages = totalPages
        }
        
        public var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<totalPages) { index in
                    let diameter = elementDiameter(at: index)
                    Element(selected: selectedPage == index + 1, variant: variant, diameter: diameter)
                        .onTapGesture { _ in
                            selectedPage = index + 1
                        }
                        .padding(.leading, leadingPadding(at: index))
                        .padding(.trailing, trailingPadding(at: index))
                }
            }
            .animation(.smooth(duration: 0.2), value: selectedPage)
            .measureForPreview(axis: .horizontal)
        }
        
        private func leadingPadding(at index: Int) -> CGFloat {
            !visibleAreaIndices.contains(index) || index == visibleAreaIndices.first ? 0 : 5
        }
        
        private func trailingPadding(at index: Int) -> CGFloat {
            !visibleAreaIndices.contains(index) || index == visibleAreaIndices.last ? 0 : 5
        }
        private var visibleAreaIndices: [Int] {
            let selectedPageIndex = selectedPage - 1
            let fullRange = 0...totalPages - 1
            return if totalPages <= maxNumberOfVisibleDots {
                Array(fullRange.prefix(totalPages))
            } else if selectedPage <= 2 {
                Array(fullRange.prefix(maxNumberOfVisibleDots))
            } else if totalPages - 2 <= selectedPage {
                Array(fullRange.reversed().prefix(maxNumberOfVisibleDots).reversed())
            } else {
                Array((selectedPageIndex - 2...totalPages - 1).prefix(maxNumberOfVisibleDots))
            }
        }
        
        private enum ElementScale {
            case regular, medium, tiny, void
        }
        
        private func elementDiameter(at index: Int) -> CGFloat {
            var scale: ElementScale = {
                if totalPages <= maxNumberOfVisibleDots {
                    .regular
                } else {
                    switch index {
                    case visibleAreaIndices[0], visibleAreaIndices[maxNumberOfVisibleDots - 1]:
                        if index == 0 || index == totalPages - 1 {
                            .regular
                        } else if index == 1 || index == totalPages - 2 {
                            .medium
                        } else {
                            .tiny
                        }
                    case visibleAreaIndices[1], visibleAreaIndices[maxNumberOfVisibleDots - 2]:
                        if index <= 2 || index >= totalPages - 3 {
                            .regular
                        } else {
                            .medium
                        }
                    case visibleAreaIndices[2]...visibleAreaIndices[maxNumberOfVisibleDots - 3]:
                            .regular
                    default:
                            .void
                    }
                }
            }()
            return switch scale {
            case .regular: size == .normal ? 10 : 6
            case .medium: size == .normal ? 8 : 4
            case .tiny: size == .normal ? 6 : 2
            case .void: 0
            }
        }
        
        private var variant: Variant = .normal
        private var size: Size = .normal
        
        public func variant(_ variant: Variant) -> Self {
            var zelf = self
            zelf.variant = variant
            return zelf
        }
        
        public func size(_ size: Size) -> Self {
            var zelf = self
            zelf.size = size
            return zelf
        }
        
        private struct Element: View {
            private var selected: Bool
            private let variant: Variant
            private let diameter: CGFloat
            public init(selected: Bool, variant: Variant, diameter: CGFloat) {
                self.selected = selected
                self.variant = variant
                self.diameter = diameter
            }
            
            public var body: some View {
                Circle()
                    .fill(dotColor)
                    .frame(width: diameter, height: diameter)
                    .overlay {
                        Circle()
                            .stroke(dotBorderColor, lineWidth: 1)
                            .frame(width: diameter == 0 ? 0 : diameter + 2, height: diameter + 2)
                    }
            }
            
            private var dotColor: SwiftUI.Color {
                switch variant {
                case .normal:
                    return .alias(.labelNormal).opacity(selected ? 1 : 0.16)
                case .white:
                    return .alias(.staticWhite).opacity(selected ? 1 : 0.52)
                }
            }
            
            private var dotBorderColor: SwiftUI.Color {
                switch variant {
                case .normal:
                    return .clear
                case .white:
                    return .alias(.lineNeutral).opacity(selected ? 1 : 0.52)
                }
            }
        }
    }
}
