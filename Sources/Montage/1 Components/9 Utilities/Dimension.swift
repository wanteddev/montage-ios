//
//  Dimension.swift
//  Montage
//

import Foundation
import UIKit

/// 컴포넌트의 너비/높이를 정의하는 시스템
///
/// Dimension은 아이콘, 아바타, 컨트롤 등 컴포넌트의 고정 치수(width/height)에
/// 일관된 값을 적용하기 위한 토큰입니다.
///
/// ```swift
/// // SwiftUI
/// Image(systemName: "star")
///     .frame(width: .dimension24, height: .dimension24)
///
/// // UIKit
/// imageView.widthAnchor.constraint(equalToConstant: .dimension24).isActive = true
/// ```
///
/// - Note: 실제 값은 `CGFloat.dimension{N}` 정적 프로퍼티로 노출됩니다.
/// 이 타입은 문서 그룹핑 용도의 빈 네임스페이스입니다.
public enum Dimension {}

public extension CGFloat {
    /// 14pt
    static let dimension14: CGFloat = .primitive14
    /// 16pt
    static let dimension16: CGFloat = .primitive16
    /// 18pt
    static let dimension18: CGFloat = .primitive18
    /// 20pt
    static let dimension20: CGFloat = .primitive20
    /// 24pt
    static let dimension24: CGFloat = .primitive24
    /// 28pt
    static let dimension28: CGFloat = .primitive28
    /// 32pt
    static let dimension32: CGFloat = .primitive32
    /// 40pt
    static let dimension40: CGFloat = .primitive40
    /// 48pt
    static let dimension48: CGFloat = .primitive48
    /// 56pt
    static let dimension56: CGFloat = .primitive56
    /// 64pt
    static let dimension64: CGFloat = .primitive64
}
