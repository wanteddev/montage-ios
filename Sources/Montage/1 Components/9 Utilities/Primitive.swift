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
/// (`.spacing{N}`, `.radius{N}`, `.dimension{N}`)을 사용하세요.
///
/// ```swift
/// // 권장: 의도가 명시된 상위 토큰 사용
/// let padding = CGFloat.spacing16
///
/// // 예외: 적합한 상위 토큰이 없을 때만 Primitive 사용
/// let custom = CGFloat.primitive18
/// ```
///
/// - Note: 실제 값은 `CGFloat.primitive{N}` 정적 프로퍼티로 노출됩니다.
/// 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.
public enum Primitive {}

public extension CGFloat {
    /// 0pt
    static let primitive0: CGFloat = 0
    /// 1pt
    static let primitive1: CGFloat = 1
    /// 2pt
    static let primitive2: CGFloat = 2
    /// 4pt
    static let primitive4: CGFloat = 4
    /// 6pt
    static let primitive6: CGFloat = 6
    /// 8pt
    static let primitive8: CGFloat = 8
    /// 10pt
    static let primitive10: CGFloat = 10
    /// 12pt
    static let primitive12: CGFloat = 12
    /// 14pt
    static let primitive14: CGFloat = 14
    /// 16pt
    static let primitive16: CGFloat = 16
    /// 18pt
    static let primitive18: CGFloat = 18
    /// 20pt
    static let primitive20: CGFloat = 20
    /// 24pt
    static let primitive24: CGFloat = 24
    /// 28pt
    static let primitive28: CGFloat = 28
    /// 32pt
    static let primitive32: CGFloat = 32
    /// 36pt
    static let primitive36: CGFloat = 36
    /// 40pt
    static let primitive40: CGFloat = 40
    /// 48pt
    static let primitive48: CGFloat = 48
    /// 56pt
    static let primitive56: CGFloat = 56
    /// 64pt
    static let primitive64: CGFloat = 64
    /// 72pt
    static let primitive72: CGFloat = 72
    /// 80pt
    static let primitive80: CGFloat = 80
    /// 무한대. Figma `9999` 토큰에 대응.
    static let primitiveInfinity: CGFloat = .infinity
}
