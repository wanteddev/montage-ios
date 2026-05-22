//
//  Primitive.swift
//  Montage
//

import Foundation
import UIKit

/// 모든 치수 토큰의 원시 척도(Primitive scale)
///
/// Primitive는 Spacing, Radius, Dimension 등 상위 토큰의 기반이 되는 원시 수치 값입니다.
/// 일반적으로 컴포넌트 구현에서 직접 사용하지 말고, 의도가 명시된 상위 토큰
/// (`Spacing`, `Radius`, `Dimension`)을 사용하세요.
///
/// ```swift
/// // 권장: 의도가 명시된 상위 토큰 사용
/// let padding = CGFloat.spacing(.s16)
///
/// // 예외: 적합한 상위 토큰이 없을 때만 Primitive 사용
/// let custom = CGFloat.primitive(.p18)
/// ```
public enum Primitive {
    /// 0px
    case p0
    /// 1px
    case p1
    /// 2px
    case p2
    /// 4px
    case p4
    /// 6px
    case p6
    /// 8px
    case p8
    /// 10px
    case p10
    /// 12px
    case p12
    /// 14px
    case p14
    /// 16px
    case p16
    /// 18px
    case p18
    /// 20px
    case p20
    /// 24px
    case p24
    /// 32px
    case p32
    /// 40px
    case p40
    /// 48px
    case p48
    /// 56px
    case p56
    /// 64px
    case p64
    /// 72px
    case p72
    /// 80px
    case p80
    /// 9999px (pill/원형 등 사실상 무한대 값)
    case p9999
}

extension CGFloat {
    /// Primitive 열거형 값에 해당하는 CGFloat 값을 반환합니다.
    ///
    /// - Parameter primitive: 사용할 Primitive 열거형 값
    /// - Returns: 지정된 Primitive에 해당하는 CGFloat 값
    public static func primitive(_ primitive: Primitive) -> CGFloat {
        switch primitive {
        case .p0: 0
        case .p1: 1
        case .p2: 2
        case .p4: 4
        case .p6: 6
        case .p8: 8
        case .p10: 10
        case .p12: 12
        case .p14: 14
        case .p16: 16
        case .p18: 18
        case .p20: 20
        case .p24: 24
        case .p32: 32
        case .p40: 40
        case .p48: 48
        case .p56: 56
        case .p64: 64
        case .p72: 72
        case .p80: 80
        case .p9999: 9999
        }
    }
}

extension Float {
    /// Primitive 열거형 값에 해당하는 Float 값을 반환합니다.
    ///
    /// - Parameter primitive: 사용할 Primitive 열거형 값
    /// - Returns: 지정된 Primitive에 해당하는 Float 값
    public static func primitive(_ primitive: Primitive) -> Float {
        switch primitive {
        case .p0: 0
        case .p1: 1
        case .p2: 2
        case .p4: 4
        case .p6: 6
        case .p8: 8
        case .p10: 10
        case .p12: 12
        case .p14: 14
        case .p16: 16
        case .p18: 18
        case .p20: 20
        case .p24: 24
        case .p32: 32
        case .p40: 40
        case .p48: 48
        case .p56: 56
        case .p64: 64
        case .p72: 72
        case .p80: 80
        case .p9999: 9999
        }
    }
}
