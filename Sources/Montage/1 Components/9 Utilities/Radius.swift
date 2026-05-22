//
//  Radius.swift
//  Montage
//

import Foundation
import UIKit

/// 모서리 반경(corner radius)을 정의하는 시스템
///
/// Radius는 컴포넌트의 둥근 모서리 반경을 일관되게 적용하기 위한 토큰입니다.
///
/// ```swift
/// // SwiftUI
/// RoundedRectangle(cornerRadius: .radius(.r12))
///
/// // UIKit
/// view.layer.cornerRadius = .radius(.r12)
/// ```
public enum Radius {
    /// 0px (직각)
    case r0
    /// 4px
    case r4
    /// 8px
    case r8
    /// 10px
    case r10
    /// 12px
    case r12
    /// 14px
    case r14
    /// 16px
    case r16
    /// 20px
    case r20
    /// 24px
    case r24
}

extension CGFloat {
    /// Radius 열거형 값에 해당하는 CGFloat 값을 반환합니다.
    ///
    /// - Parameter radius: 사용할 Radius 열거형 값
    /// - Returns: 지정된 모서리 반경에 해당하는 CGFloat 값
    public static func radius(_ radius: Radius) -> CGFloat {
        switch radius {
        case .r0: 0
        case .r4: 4
        case .r8: 8
        case .r10: 10
        case .r12: 12
        case .r14: 14
        case .r16: 16
        case .r20: 20
        case .r24: 24
        }
    }
}

extension Float {
    /// Radius 열거형 값에 해당하는 Float 값을 반환합니다.
    ///
    /// - Parameter radius: 사용할 Radius 열거형 값
    /// - Returns: 지정된 모서리 반경에 해당하는 Float 값
    public static func radius(_ radius: Radius) -> Float {
        switch radius {
        case .r0: 0
        case .r4: 4
        case .r8: 8
        case .r10: 10
        case .r12: 12
        case .r14: 14
        case .r16: 16
        case .r20: 20
        case .r24: 24
        }
    }
}
