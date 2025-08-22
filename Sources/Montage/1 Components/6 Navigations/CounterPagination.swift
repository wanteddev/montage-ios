//
//  CounterPagination.swift
//  Montage
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI

/// 숫자 카운터 형태의 페이지 표시기 컴포넌트입니다.
///
/// `CounterPagination`은 현재 페이지와 전체, 페이지 수를 숫자로 표시하는 페이지네이션 컴포넌트를 제공합니다.
/// "1/10"과 같은 형식으로 페이지 정보를 시각화하며, 반투명 배경이 적용됩니다.
///
/// ```swift
/// @State private var currentPage = 1
///
/// CounterPagination(selectedPage: $currentPage, totalPages: 10)
///     .size(.medium)
///     .alternative(true)
/// ```
///
/// - Note: 이 컴포넌트는 기본적으로 어두운 배경 위에서 잘 보이도록 설계되었습니다.
public struct CounterPagination: View {
    /// 카운터 페이지네이션의 크기를 지정하는 열거형입니다.
    ///
    /// UI 디자인 요구사항에 따라 카운터의 크기를 선택할 수 있습니다.
    ///
    /// ```swift
    /// // 작은 크기의 카운터 페이지네이션
    /// CounterPagination(selectedPage: $currentPage, totalPages: 5)
    ///     .size(.small)
    /// ```
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
    }
    
    @Binding private var selectedPage: Int
    private let totalPages: Int
    
    /// 카운터 형태의 페이지네이션을 초기화합니다.
    ///
    /// - Parameters:
    ///   - selectedPage: 현재 선택된 페이지 번호 (1부터 시작)
    ///   - totalPages: 전체 페이지 수
    public init(selectedPage: Binding<Int>, totalPages: Int) {
        _selectedPage = selectedPage
        self.totalPages = totalPages
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Text("\(selectedPage)")
                .paragraphNew(
                    variant: typography,
                    weight: .bold,
                    color: .semantic(.staticWhite).opacity(alternative ? 0.88 : 0.74)
                )
            Text("/")
                .paragraphNew(
                    variant: typography,
                    weight: .regular,
                    color: .semantic(.staticWhite).opacity(alternative ? 0.52 : 0.28)
                )
            Text("\(totalPages)")
                .paragraphNew(
                    variant: typography,
                    weight: .bold,
                    color: .semantic(.staticWhite).opacity(alternative ? 0.88 : 0.74)
                )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background {
            if alternative {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(SwiftUI.Color.atomic(.coolNeutral30).opacity(0.61))
            } else {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: height / 2))
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(SwiftUI.Color.atomic(.coolNeutral30).opacity(0.43))
                }
            }
        }
    }
    
    private var size: Size = .medium
    private var alternative = false
    
    /// 카운터 페이지네이션의 크기를 설정합니다.
    ///
    /// - Parameters:
    ///   - size: 적용할 카운터 크기
    /// - Returns: 수정된 Counter 인스턴스
    ///
    /// - Note: 기본값은 `.medium`입니다.
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 카운터 페이지네이션의 대체 스타일을 적용합니다.
    ///
    /// 기본 스타일은 반투명 배경을 사용하고, 대체 스타일은 좀 더 불투명한 회색 배경을 사용합니다.
    ///
    /// - Parameters:
    ///   - alternative: 대체 스타일 적용 여부 (기본값: true)
    /// - Returns: 수정된 Counter 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func alternative(_ alternative: Bool = true) -> Self {
        var zelf = self
        zelf.alternative = alternative
        return zelf
    }
    
    private var typography: Typography.Variant {
        switch size {
        case .medium: .body2
        case .small: .label2
        }
    }
    
    private var width: CGFloat {
        switch size {
        case .medium: 62
        case .small: 52
        }
    }
    
    private var height: CGFloat {
        switch size {
        case .medium: 34
        case .small: 26
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .medium: 12
        case .small: 10
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .medium: 6
        case .small: 4
        }
    }
}
