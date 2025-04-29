//
//  Opacity.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/14.
//

import Foundation
import UIKit

/// 색상의 투명도를 정의한 열거형입니다.
///
/// Montage 디자인 시스템에서 사용하는 정규화된 투명도 값을 제공합니다.
/// 각 케이스는 백분율 형식으로 이름이 지정되어 있습니다 (예: p005는 5% 투명도).
///
/// ## 사용 예시
/// ```swift
/// // CGFloat 값으로 변환
/// let alpha: CGFloat = .opacity(.p052)
///
/// // 뷰 투명도 설정
/// myView.alpha = .opacity(.p088)
///
/// // 색상 투명도 설정
/// let transparentColor = UIColor.black.withAlphaComponent(.opacity(.p043))
/// ```
///
/// - Note: 표준화된 투명도 값을 사용하면 디자인의 일관성을 유지하는 데 도움이 됩니다.
public enum Opacity {
    /// 0% 투명도 (완전 불투명)
    case p000
    /// 5% 투명도
    case p005
    /// 8% 투명도
    case p008
    /// 12% 투명도
    case p012
    /// 16% 투명도
    case p016
    /// 22% 투명도
    case p022
    /// 28% 투명도
    case p028
    /// 32% 투명도
    case p032
    /// 35% 투명도
    case p035
    /// 43% 투명도
    case p043
    /// 52% 투명도
    case p052
    /// 61% 투명도
    case p061
    /// 74% 투명도
    case p074
    /// 88% 투명도
    case p088
    /// 97% 투명도
    case p097
    /// 100% 투명도 (완전 투명)
    case p100
}

public extension CGFloat {
    /// Opacity 열거형 값에 해당하는 CGFloat 불투명도 값을 반환합니다.
    ///
    /// 디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// let alpha = CGFloat.opacity(.p052) // 0.52
    /// ```
    ///
    /// - Parameter opacityComponent: 사용할 불투명도 열거형 값
    /// - Returns: 지정된 불투명도에 해당하는 CGFloat 값 (0.0 ~ 1.0 범위)
    static func opacity(_ opacityComponent: Opacity) -> CGFloat {
        switch opacityComponent {
        case .p000:
            0
        case .p005:
            0.05
        case .p008:
            0.08
        case .p012:
            0.12
        case .p016:
            0.16
        case .p022:
            0.22
        case .p028:
            0.28
        case .p032:
            0.32
        case .p035:
            0.35
        case .p043:
            0.43
        case .p052:
            0.52
        case .p061:
            0.61
        case .p074:
            0.74
        case .p088:
            0.88
        case .p097:
            0.97
        case .p100:
            1
        }
    }
}

public extension Float {
    /// Opacity 열거형 값에 해당하는 Float 불투명도 값을 반환합니다.
    ///
    /// 디자인 시스템에서 정의된 일관된 불투명도 값을 사용할 수 있도록 합니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// let alpha = Float.opacity(.p050) // 0.5
    /// ```
    ///
    /// - Parameter opacityComponent: 사용할 불투명도 열거형 값
    /// - Returns: 지정된 불투명도에 해당하는 Float 값 (0.0 ~ 1.0 범위)
    static func opacity(_ opacityComponent: Opacity) -> Float {
        switch opacityComponent {
        case .p000:
            0
        case .p005:
            0.05
        case .p008:
            0.08
        case .p012:
            0.12
        case .p016:
            0.16
        case .p022:
            0.22
        case .p028:
            0.28
        case .p032:
            0.32
        case .p035:
            0.35
        case .p043:
            0.43
        case .p052:
            0.52
        case .p061:
            0.61
        case .p074:
            0.74
        case .p088:
            0.88
        case .p097:
            0.97
        case .p100:
            1
        }
    }
}
