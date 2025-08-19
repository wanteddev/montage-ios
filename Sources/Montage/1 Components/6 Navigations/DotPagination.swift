//
//  DotPagination.swift
//  Montage
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI

/// 점 형태의 페이지 표시기 컴포넌트입니다.
///
/// `DotPagination`은 페이지 간 이동 및 현재 페이지 표시를 위한 점 형태의 페이지네이션 컴포넌트를 제공합니다.
/// 현재 선택된 페이지는 강조 표시되며, 점을 탭하여 해당 페이지로 이동할 수 있습니다.
/// 페이지 수가 많을 경우 표시되는 점의 개수와 크기가 자동으로 조정됩니다.
///
/// ```swift
/// @State private var currentPage = 1
///
/// DotPagination(selectedPage: $currentPage, totalPages: 10)
///     .variant(.normal)
///     .size(.normal)
/// ```
///
/// - Note: 최대 표시 가능한 점의 개수는 5개이며, 페이지 수가 더 많을 경우 동적으로 조정됩니다.
public struct DotPagination: View {
    /// 점 페이지네이션의 색상 변형을 지정하는 열거형입니다.
    ///
    /// 배경색이나 사용 컨텍스트에 따라 적합한 색상 테마를 선택할 수 있습니다.
    ///
    /// ```swift
    /// // 어두운 배경에 사용
    /// DotPagination(selectedPage: $currentPage, totalPages: 5)
    ///     .variant(.white)
    /// ```
    public enum Variant {
        /// 기본 스타일 (회색 배경에 검은색 점)
        case normal
        /// 흰색 스타일 (어두운 배경에 적합)
        case white
    }
    
    /// 점 페이지네이션의 크기를 지정하는 열거형입니다.
    ///
    /// UI 디자인 요구사항에 따라 점의 크기를 선택할 수 있습니다.
    ///
    /// ```swift
    /// // 작은 크기의 점 페이지네이션
    /// DotPagination(selectedPage: $currentPage, totalPages: 5)
    ///     .size(.small)
    /// ```
    public enum Size {
        /// 표준 크기
        case normal
        /// 작은 크기
        case small
    }
    
    @Binding private var selectedPage: Int
    private let totalPages: Int
    private let maxNumberOfVisibleDots = 5
    
    /// 점 형태의 페이지네이션을 초기화합니다.
    ///
    /// - Parameters:
    ///   - selectedPage: 현재 선택된 페이지 번호 (1부터 시작)
    ///   - totalPages: 전체 페이지 수
    public init(selectedPage: Binding<Int>, totalPages: Int) {
        _selectedPage = selectedPage
        self.totalPages = totalPages
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< totalPages, id: \.self) { index in
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
    }
    
    private func leadingPadding(at index: Int) -> CGFloat {
        if !visibleAreaIndices.contains(index) || index == visibleAreaIndices.first {
            0
        } else {
            size == .normal ? 5 : 3
        }
    }
    
    private func trailingPadding(at index: Int) -> CGFloat {
        if !visibleAreaIndices.contains(index) || index == visibleAreaIndices.last {
            0
        } else {
            size == .normal ? 5 : 3
        }
    }

    private var visibleAreaIndices: [Int] {
        let selectedPageIndex = selectedPage - 1
        let fullRange = 0 ... totalPages - 1
        return if totalPages <= maxNumberOfVisibleDots {
            Array(fullRange.prefix(totalPages))
        } else if selectedPage <= 2 {
            Array(fullRange.prefix(maxNumberOfVisibleDots))
        } else if totalPages - 2 <= selectedPage {
            Array(fullRange.reversed().prefix(maxNumberOfVisibleDots).reversed())
        } else {
            Array((selectedPageIndex - 2 ... totalPages - 1).prefix(maxNumberOfVisibleDots))
        }
    }
    
    private enum ElementScale {
        case regular, medium, tiny, void
    }
    
    private func elementDiameter(at index: Int) -> CGFloat {
        let scale: ElementScale = {
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
                case visibleAreaIndices[2] ... visibleAreaIndices[maxNumberOfVisibleDots - 3]:
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
    
    /// 점 페이지네이션의 색상 변형을 설정합니다.
    ///
    /// - Parameters:
    ///   - variant: 적용할 색상 변형
    /// - Returns: 수정된 Dot 인스턴스
    ///
    /// - Note: 기본값은 `.normal`입니다.
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    /// 점 페이지네이션의 크기를 설정합니다.
    ///
    /// - Parameters:
    ///   - size: 적용할 점 크기
    /// - Returns: 수정된 Dot 인스턴스
    ///
    /// - Note: 기본값은 `.normal`입니다.
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
                .semantic(.labelNormal).opacity(selected ? 1 : 0.16)
            case .white:
                .semantic(.staticWhite).opacity(selected ? 1 : 0.52)
            }
        }
        
        private var dotBorderColor: SwiftUI.Color {
            switch variant {
            case .normal:
                .clear
            case .white:
                .semantic(.lineNeutral).opacity(selected ? 1 : 0.52)
            }
        }
    }
}
