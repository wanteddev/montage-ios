//
//  FlowLayout.swift
//  Montage
//
//  Created by 김삼열 on 1/6/25.
//

import SwiftUI

/// 항목들을 자동으로 여러 줄에 배치하는 흐름 레이아웃 컴포넌트입니다.
///
/// 이 레이아웃은 컨테이너의 너비를 초과할 경우 항목을 자동으로 다음 줄로 넘겨 배치합니다.
/// 항목 간 수평 간격과 줄 간 수직 간격을 설정할 수 있습니다.
///
/// **사용 예시**:
/// ```swift
/// FlowLayout(spacing: 8, lineSpacing: 12) {
///     ForEach(tags, id: \.self) { tag in
///         Text(tag)
///             .padding(.horizontal, 12)
///             .padding(.vertical, 6)
///             .background(Color.blue.opacity(0.1))
///             .cornerRadius(16)
///     }
/// }
/// ```
public struct FlowLayout: Layout {
    private let spacing: CGFloat?
    private let lineSpacing: CGFloat
    
    /// FlowLayout을 초기화합니다.
    ///
    /// - Parameters:
    ///   - spacing: 항목 간 수평 간격. nil인 경우 시스템 기본 간격을 사용합니다. (기본값: nil)
    ///   - lineSpacing: 줄 간 수직 간격 (기본값: 10.0)
    public init(spacing: CGFloat? = nil, lineSpacing: CGFloat = 10.0) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }
    
    /// 레이아웃 계산에 사용되는 캐시 구조체입니다.
    ///
    /// 서브뷰의 크기와 간격 정보를 저장하여 레이아웃 계산 성능을 최적화합니다.
    public struct Cache {
        var sizes: [CGSize] = []
        var spacing: [CGFloat] = []
    }
    
    /// 레이아웃 캐시를 생성합니다.
    ///
    /// - Parameter subviews: 배치할 서브뷰 컬렉션
    /// - Returns: 각 서브뷰의 크기와 간격 정보를 포함한 캐시
    public func makeCache(subviews: Subviews) -> Cache {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let spacing: [CGFloat] = subviews.indices.map { index in
            // 마지막 항목은 간격을 추가하지 않음
            guard index != subviews.count - 1 else {
                return 0
            }
            
            return self.spacing ?? subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .horizontal
            )
        }
        
        return Cache(sizes: sizes, spacing: spacing)
    }
    
    /// 레이아웃의 전체 크기를 계산합니다.
    ///
    /// - Parameters:
    ///   - proposal: 제안된 크기
    ///   - subviews: 배치할 서브뷰 컬렉션
    ///   - cache: 레이아웃 캐시
    /// - Returns: 계산된 레이아웃의 전체 크기
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        var totalHeight = 0.0
        var totalWidth = 0.0
        
        var lineWidth = 0.0
        var lineHeight = 0.0
        var isFirstInLine = true
        
        for index in subviews.indices {
            // 줄바꿈 여부 확인
            if !isFirstInLine && lineWidth + cache.spacing[index-1] + cache.sizes[index].width >= (proposal.width ?? 0) - 0.001 {
                totalHeight += lineHeight + lineSpacing
                lineWidth = 0
                lineHeight = 0
                isFirstInLine = true
            }
            
            // 간격 추가
            if !isFirstInLine {
                lineWidth += cache.spacing[index-1]
            }
            
            // 항목 너비 추가
            lineWidth += cache.sizes[index].width
            lineHeight = max(lineHeight, cache.sizes[index].height)
            isFirstInLine = false
            
            totalWidth = max(totalWidth, lineWidth)
        }
        
        totalHeight += lineHeight
        
        return .init(width: totalWidth, height: totalHeight)
    }
    
    /// 서브뷰들을 실제 위치에 배치합니다.
    ///
    /// - Parameters:
    ///   - bounds: 레이아웃의 경계 사각형
    ///   - proposal: 제안된 크기
    ///   - subviews: 배치할 서브뷰 컬렉션
    ///   - cache: 레이아웃 캐시
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        var isFirstInLine = true
        
        for index in subviews.indices {
            // 줄바꿈 여부 확인
            if !isFirstInLine && lineX + cache.spacing[index-1] + cache.sizes[index].width - bounds.minX >= (proposal.width ?? 0) - 0.001 {
                lineY += lineHeight + lineSpacing
                lineHeight = 0
                lineX = bounds.minX
                isFirstInLine = true
            }
            
            // 간격 추가
            if !isFirstInLine {
                lineX += cache.spacing[index-1]
            }
            
            // 항목 배치
            subviews[index].place(
                at: CGPoint(x: lineX, y: lineY),
                anchor: .topLeading,
                proposal: ProposedViewSize(cache.sizes[index])
            )
            
            // 상태 업데이트 - sizeThatFits와 동일한 방식
            lineHeight = max(lineHeight, cache.sizes[index].height)
            lineX += cache.sizes[index].width
            isFirstInLine = false
        }
    }
}
