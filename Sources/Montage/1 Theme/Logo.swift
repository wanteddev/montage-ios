//
//  Logo.swift
//  
//
//  Created by GOOK HEE JUNG on 2023/09/14.
//

import Foundation
import SwiftUI
import UIKit

/// Montage 디자인 시스템의 로고 세트
///
/// Logo는 Wanted 브랜드의 공식 로고 이미지들을 정의합니다.
/// 각 로고는 브랜드 아이덴티티를 일관되게 표현하기 위해 
/// 다양한 형태와 방향으로 제공됩니다.
///
/// **사용 예시**:
/// ```swift
/// // UIKit에서 사용
/// let imageView = UIImageView()
/// imageView.image = UIImage.montage(.wantedLogoHorizontal)
///
/// // SwiftUI에서 사용
/// Image.montage(.wantedCircleSymbol)
///     .resizable()
///     .scaledToFit()
///     .frame(width: 40, height: 40)
/// ```
///
/// - Note: 로고를 사용할 때는 브랜드 가이드라인에 따라 적절한 여백과 
/// 비율을 유지해야 합니다.
public enum Logo {
    /// Wanted 원형 심볼 로고
    case wantedCircleSymbol
    /// Wanted 가로형 로고
    case wantedLogoHorizontal
    /// Wanted 세로형 로고
    case wantedLogoVertical

    /// 로고의 리소스 이름을 반환합니다.
    public var name: String {
        switch self {
        case .wantedCircleSymbol:
            "wantedCircleSymbol"
        case .wantedLogoHorizontal:
            "wantedLogoHorizontal"
        case .wantedLogoVertical:
            "wantedLogoVertical"
        }
    }
}

// MARK: - UIKit Extensions
extension UIImage {
    /// Montage 디자인 시스템의 로고를 생성합니다.
    ///
    /// - Parameter type: 생성할 로고 타입
    /// - Returns: 생성된 UIImage 인스턴스
    public static func montage(_ type: Logo) -> UIImage {
        load(name: type.name)
    }
}

// MARK: - SwiftUI Extensions
extension Image {
    /// Montage 디자인 시스템의 로고를 생성합니다.
    ///
    /// - Parameter type: 생성할 로고 타입
    /// - Returns: 생성된 Image 인스턴스
    public static func montage(_ type: Logo) -> Image {
        load(name: type.name)
    }
}
