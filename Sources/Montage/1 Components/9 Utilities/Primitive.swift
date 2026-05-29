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
public enum Primitive {
    /// 정의된 모든 primitive 토큰 값(오름차순).
    ///
    /// 컴포넌트가 토큰에 스냅하거나 최대/최소 토큰을 동적으로 도출할 때 사용한다.
    /// 토큰이 추가/삭제되면 이 배열만 갱신하면 사용처가 자동으로 반영된다.
    public static let allValues: [CGFloat] = [
        .primitive0, .primitive1, .primitive2, .primitive4, .primitive6, .primitive8,
        .primitive10, .primitive12, .primitive14, .primitive16, .primitive18, .primitive20,
        .primitive24, .primitive28, .primitive32, .primitive36, .primitive40, .primitive48,
        .primitive56, .primitive64, .primitive72, .primitive80, .primitiveInfinity
    ]

    /// 정의된 primitive 토큰 중 최소값.
    public static var min: CGFloat { allValues.first ?? 0 }

    /// 정의된 primitive 토큰 중 최대값(`primitiveInfinity` 포함).
    public static var max: CGFloat { allValues.last ?? 0 }
}

public extension CGFloat {
    /// 0pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive0: CGFloat = 0
    /// 1pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive1: CGFloat = 1
    /// 2pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive2: CGFloat = 2
    /// 4pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive4: CGFloat = 4
    /// 6pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive6: CGFloat = 6
    /// 8pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive8: CGFloat = 8
    /// 10pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive10: CGFloat = 10
    /// 12pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive12: CGFloat = 12
    /// 14pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive14: CGFloat = 14
    /// 16pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive16: CGFloat = 16
    /// 18pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive18: CGFloat = 18
    /// 20pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive20: CGFloat = 20
    /// 24pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive24: CGFloat = 24
    /// 28pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive28: CGFloat = 28
    /// 32pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive32: CGFloat = 32
    /// 36pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive36: CGFloat = 36
    /// 40pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive40: CGFloat = 40
    /// 48pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive48: CGFloat = 48
    /// 56pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive56: CGFloat = 56
    /// 64pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive64: CGFloat = 64
    /// 72pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive72: CGFloat = 72
    /// 80pt의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용
    static let primitive80: CGFloat = 80
    /// 무한대의 원시 값 — Spacing/Radius/Dimension에 없는 값이 필요할 때만 직접 사용. Figma `9999` 토큰에 대응
    static let primitiveInfinity: CGFloat = .infinity
}
