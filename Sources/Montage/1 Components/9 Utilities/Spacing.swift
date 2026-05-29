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
/// // UIKit
/// view.layoutMargins = UIEdgeInsets(
///     top: .spacing16, left: .spacing16, bottom: .spacing16, right: .spacing16
/// )
///
/// // SwiftUI
/// Text("Hello, World!")
///     .padding(.horizontal, .spacing24)
///     .padding(.vertical, .spacing16)
/// ```
///
/// - Note: 간격 이름의 숫자는 포인트 단위의 실제 간격 값을 나타냅니다.
/// 예를 들어 spacing16은 16포인트의 간격을 의미합니다.
///
/// 실제 값은 `CGFloat.spacing{N}` 정적 프로퍼티로 노출됩니다.
/// 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.
public enum Spacing {
    /// 정의된 모든 spacing 토큰 값(오름차순).
    ///
    /// 컴포넌트가 토큰에 스냅하거나 최대/최소 토큰을 동적으로 도출할 때 사용한다.
    /// 토큰이 추가/삭제되면 이 배열만 갱신하면 사용처가 자동으로 반영된다.
    public static let allValues: [CGFloat] = [
        .spacing0, .spacing1, .spacing2, .spacing4, .spacing6, .spacing8,
        .spacing10, .spacing12, .spacing14, .spacing16, .spacing20, .spacing24,
        .spacing32, .spacing40, .spacing48, .spacing56, .spacing64, .spacing72,
        .spacing80
    ]

    /// 정의된 spacing 토큰 중 최소값.
    public static var min: CGFloat { allValues.first ?? 0 }

    /// 정의된 spacing 토큰 중 최대값.
    public static var max: CGFloat { allValues.last ?? 0 }
}

public extension CGFloat {
    /// 0pt의 간격
    static let spacing0: CGFloat = .primitive0
    /// 1pt의 간격
    static let spacing1: CGFloat = .primitive1
    /// 2pt의 간격
    static let spacing2: CGFloat = .primitive2
    /// 4pt의 간격
    static let spacing4: CGFloat = .primitive4
    /// 6pt의 간격
    static let spacing6: CGFloat = .primitive6
    /// 8pt의 간격
    static let spacing8: CGFloat = .primitive8
    /// 10pt의 간격
    static let spacing10: CGFloat = .primitive10
    /// 12pt의 간격
    static let spacing12: CGFloat = .primitive12
    /// 14pt의 간격
    static let spacing14: CGFloat = .primitive14
    /// 16pt의 간격 (기본)
    static let spacing16: CGFloat = .primitive16
    /// 20pt의 간격
    static let spacing20: CGFloat = .primitive20
    /// 24pt의 간격
    static let spacing24: CGFloat = .primitive24
    /// 32pt의 간격
    static let spacing32: CGFloat = .primitive32
    /// 40pt의 간격
    static let spacing40: CGFloat = .primitive40
    /// 48pt의 간격
    static let spacing48: CGFloat = .primitive48
    /// 56pt의 간격
    static let spacing56: CGFloat = .primitive56
    /// 64pt의 간격
    static let spacing64: CGFloat = .primitive64
    /// 72pt의 간격
    static let spacing72: CGFloat = .primitive72
    /// 80pt의 간격
    static let spacing80: CGFloat = .primitive80
}
