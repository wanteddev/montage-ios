//
//  Divider.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/09.
//

import SwiftUI

/// 구획을 나누기 위해 사용되는 구분선 컴포넌트입니다.
///
/// 이 컴포넌트는 UI 요소 간의 시각적 구분을 제공하기 위해 사용됩니다.
/// 수직 또는 수평 방향으로 배치할 수 있으며, 두 가지 두께 변형을 지원합니다.
///
/// ```swift
/// // 기본 수평 구분선
/// Divider(.horizontal)
///
/// // 두꺼운 수직 구분선
/// Divider(.vertical, variant: .thick)
///
/// // 스택 안에서 사용
/// VStack {
///    Text("첫 번째 항목")
///    Divider(.horizontal)
///    Text("두 번째 항목")
/// }
/// ```
public struct Divider: View {
    // MARK: - Types
    
    /// 구분선의 두께 변형을 정의합니다.
    public enum Variant {
        /// 표준 두께
        case normal
        /// 두꺼운 두께
        case thick

        var size: CGFloat {
            switch self {
            case .normal: 1
            case .thick: 12
            }
        }
    }

    // MARK: - Initializer
    private let axis: Axis
    private let variant: Variant
    
    /// 구분선 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - axis: 구분선의 방향 (`.horizontal` 또는 `.vertical`)
    ///   - variant: 구분선의 두께 변형, 기본값은 `.normal`
    /// - Returns: 구성된 구분선 인스턴스
    public init(_ axis: Axis, variant: Variant = .normal) {
        self.axis = axis
        self.variant = variant
    }

    // MARK: - Body
    public var body: some View {
        Rectangle()
            .if(axis == .vertical) {
                $0.frame(width: variant.size)
            }
            .if(axis == .horizontal) {
                $0.frame(height: variant.size)
            }
            .foregroundStyle(SwiftUI.Color.semantic(.lineNormal))
    }
}

#Preview {
    ZStack {
        Divider(.vertical)
        Divider(.horizontal)
    }
    ZStack {
        Divider(.vertical, variant: .thick)
        Divider(.horizontal, variant: .thick)
    }
}
