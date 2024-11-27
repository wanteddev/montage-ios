//
//  AutoScrollModifier.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import SwiftUI

struct AutoScrollModifier: ViewModifier {
    private let axis: Axis.Set
    @Binding private var contentOffset: CGPoint
    
    init(axis: Axis.Set, contentOffset: Binding<CGPoint>) {
        self.axis = axis
        self._contentOffset = contentOffset
    }
    
    @State private var scrollNotNeeded: Bool = false
    @State private var contentSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        Group {
            if scrollNotNeeded == false {
                OffsettableScrollView {
                    contentView(content)
                } onOffsetChanged: {
                    contentOffset = $0
                }
                .axis(axis)
                .showIndicators(false)
            } else {
                contentView(content)
            }
        }
        .onGeometryChange(for: CGSize.self, of: { $0.size }) { scrollViewSize = $0 }
        .onAppear {
            scrollNotNeeded = switch axis {
            case .horizontal:
                contentSize.width <= scrollViewSize.width
            case .vertical:
                contentSize.height <= scrollViewSize.height
            default:
                true
            }
        }
    }
    
    // MARK: - private
    
    private func contentView(_ content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }) { contentSize = $0 }
    }
}
