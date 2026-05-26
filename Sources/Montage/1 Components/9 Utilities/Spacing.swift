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
public enum Spacing {}

public extension CGFloat {
    /// 0pt
    static let spacing0: CGFloat = .primitive0
    /// 1pt
    static let spacing1: CGFloat = .primitive1
    /// 2pt
    static let spacing2: CGFloat = .primitive2
    /// 4pt
    static let spacing4: CGFloat = .primitive4
    /// 6pt
    static let spacing6: CGFloat = .primitive6
    /// 8pt
    static let spacing8: CGFloat = .primitive8
    /// 10pt
    static let spacing10: CGFloat = .primitive10
    /// 12pt
    static let spacing12: CGFloat = .primitive12
    /// 14pt
    static let spacing14: CGFloat = .primitive14
    /// 16pt (기본 간격)
    static let spacing16: CGFloat = .primitive16
    /// 20pt
    static let spacing20: CGFloat = .primitive20
    /// 24pt
    static let spacing24: CGFloat = .primitive24
    /// 32pt
    static let spacing32: CGFloat = .primitive32
    /// 40pt
    static let spacing40: CGFloat = .primitive40
    /// 48pt
    static let spacing48: CGFloat = .primitive48
    /// 56pt
    static let spacing56: CGFloat = .primitive56
    /// 64pt
    static let spacing64: CGFloat = .primitive64
    /// 72pt
    static let spacing72: CGFloat = .primitive72
    /// 80pt
    static let spacing80: CGFloat = .primitive80
}
