//
//  FlowLayout.swift
//  Montage
//
//  Created by 김삼열 on 1/6/25.
//

import SwiftUI

public struct FlowLayout: Layout {
    private let spacing: CGFloat?
    private let lineSpacing: CGFloat
    
    public init(spacing: CGFloat? = nil, lineSpacing: CGFloat = 10.0) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }
    
    public struct Cache {
        var sizes: [CGSize] = []
        var spacing: [CGFloat] = []
    }
    
    public func makeCache(subviews: Subviews) -> Cache {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let spacing: [CGFloat] = subviews.indices.map { index in
            guard index != subviews.count - 1 else {
                return 0
            }
            
            return subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .horizontal
            )
        }
        
        return Cache(sizes: sizes, spacing: spacing)
    }
    
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        var totalHeight = 0.0
        var totalWidth = 0.0
        
        var lineWidth = 0.0
        var lineHeight = 0.0
        
        for index in subviews.indices {
            if lineWidth + cache.sizes[index].width > (proposal.width ?? 0) {
                totalHeight += lineHeight + lineSpacing
                lineWidth = cache.sizes[index].width + (spacing ?? cache.spacing[index])
                lineHeight = cache.sizes[index].height
            } else {
                lineWidth += cache.sizes[index].width + (spacing ?? cache.spacing[index])
                lineHeight = max(lineHeight, cache.sizes[index].height)
            }
            
            totalWidth = max(totalWidth, lineWidth)
        }
        
        totalHeight += lineHeight
        
        return .init(width: totalWidth, height: totalHeight)
    }
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for index in subviews.indices {
            if lineX + cache.sizes[index].width - bounds.minX > (proposal.width ?? 0) {
                lineY += lineHeight + lineSpacing
                lineHeight = 0
                lineX = bounds.minX
            }
            
            let position = CGPoint(
                x: lineX + cache.sizes[index].width / 2,
                y: lineY + cache.sizes[index].height / 2
            )
            
            lineHeight = max(lineHeight, cache.sizes[index].height)
            lineX += cache.sizes[index].width + (spacing ?? cache.spacing[index])
            
            subviews[index].place(
                at: position,
                anchor: .center,
                proposal: ProposedViewSize(cache.sizes[index])
            )
        }
    }
}

#Preview(body: {
    ScrollView {
        FlowLayout {
            ForEach(0 ..< 97) { i in
                Chip.Action(text: "\(i)")
            }
        }
        .borderForPreview()
    }
})
