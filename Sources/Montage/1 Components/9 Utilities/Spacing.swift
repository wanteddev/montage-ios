//
//  Spacing.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/23.
//

import Foundation
import UIKit

/// UI 요소 간의 간격(gap, padding)을 정의하는 시스템
///
/// Spacing은 Montage 디자인 시스템에서 UI 요소 간의 일관된
/// 간격을 제공하기 위한 규격화된 값들을 정의합니다.
///
/// ```swift
/// // UIKit에서 사용
/// let padding = CGFloat.spacing(.s16)
/// view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
///
/// // SwiftUI에서 사용
/// Text("Hello, World!")
///     .padding(.horizontal, .spacing(.s24))
///     .padding(.vertical, .spacing(.s16))
/// ```
///
/// - Note: 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다.
/// 예를 들어 s16은 16포인트의 간격을 의미합니다.
public enum Spacing {
    /// 0px
    case s0
    /// 1px
    case s1
    /// 2px
    case s2
    /// 4px
    case s4
    /// 6px
    case s6
    /// 8px
    case s8
    /// 10px
    case s10
    /// 12px
    case s12
    /// 14px
    case s14
    /// 16px (기본 간격)
    case s16
    /// 20px
    case s20
    /// 24px
    case s24
    /// 32px
    case s32
    /// 40px
    case s40
    /// 48px
    case s48
    /// 56px
    case s56
    /// 64px
    case s64
    /// 72px
    case s72
    /// 80px
    case s80
}

extension CGFloat {
    /// Spacing 열거형 값에 해당하는 CGFloat 값을 반환합니다.
    ///
    /// 디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.
    ///
    /// ```swift
    /// let padding = CGFloat.spacing(.s16) // 16.0
    /// ```
    ///
    /// - Parameter spacing: 사용할 간격 열거형 값
    /// - Returns: 지정된 간격에 해당하는 CGFloat 값
    public static func spacing(_ spacing: Spacing) -> CGFloat {
        switch spacing {
        case .s0: 0
        case .s1: 1
        case .s2: 2
        case .s4: 4
        case .s6: 6
        case .s8: 8
        case .s10: 10
        case .s12: 12
        case .s14: 14
        case .s16: 16
        case .s20: 20
        case .s24: 24
        case .s32: 32
        case .s40: 40
        case .s48: 48
        case .s56: 56
        case .s64: 64
        case .s72: 72
        case .s80: 80
        }
    }
}

extension Float {
    /// Spacing 열거형 값에 해당하는 Float 값을 반환합니다.
    ///
    /// 디자인 시스템에서 정의된 일관된 간격 값을 사용할 수 있도록 합니다.
    ///
    /// ```swift
    /// let padding = Float.spacing(.s16) // 16.0
    /// ```
    ///
    /// - Parameter spacing: 사용할 간격 열거형 값
    /// - Returns: 지정된 간격에 해당하는 Float 값
    public static func spacing(_ spacing: Spacing) -> Float {
        switch spacing {
        case .s0: 0
        case .s1: 1
        case .s2: 2
        case .s4: 4
        case .s6: 6
        case .s8: 8
        case .s10: 10
        case .s12: 12
        case .s14: 14
        case .s16: 16
        case .s20: 20
        case .s24: 24
        case .s32: 32
        case .s40: 40
        case .s48: 48
        case .s56: 56
        case .s64: 64
        case .s72: 72
        case .s80: 80
        }
    }
}
