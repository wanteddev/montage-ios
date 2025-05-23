//
//  Playtime.swift
//  Montage
//
//  Created by 김삼열 on 1/14/25.
//

import SwiftUI

/// 재생 버튼이 있는 배지 컴포넌트입니다.
///
/// `PlayBadge`는 미디어 콘텐츠에서 재생 기능을 나타내는 원형 아이콘을 제공합니다.
/// 다양한 크기와 스타일로 커스터마이징할 수 있으며, 이미지나 비디오 위에 오버레이로 표시하기 적합합니다.
///
/// ```swift
/// // 기본 재생 배지
/// PlayBadge()
///
/// // 커스텀 크기의 재생 배지
/// PlayBadge()
///     .size(.large)
///
/// // 대체 스타일의 재생 배지
/// PlayBadge()
///     .size(.medium)
///     .alternative(true)
/// ```
///
/// - Note: 기본 스타일은 반투명 배경에 흰색 재생 아이콘을 사용합니다.
///   alternative 스타일은 불투명 회색 배경을 사용합니다.
public struct PlayBadge: View {
    // MARK: - Types
    /// 재생 배지의 크기를 정의하는 열거형입니다.
    ///
    /// 미디어 콘텐츠의 크기나 중요도에 따라 적절한 배지 크기를 선택할 수 있습니다.
    ///
    /// ```swift
    /// PlayBadge()
    ///     .size(.large) // 큰 크기의 배지 사용
    /// ```
    public enum Size {
        /// 작은 크기 배지
        case small
        /// 중간 크기 배지
        case medium
        /// 큰 크기 배지
        case large
    }
    
    // MARK: - Initiailizer
    /// 기본 설정의 재생 배지를 생성합니다.
    ///
    /// 초기화 시 기본 크기는 `.medium`이며, 반투명 배경의 기본 스타일이 적용됩니다.
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        Image.montage(.play)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
            .frame(width: playIconSize.width, height: playIconSize.height)
            .background {
                Group {
                    if alternative {
                        Circle()
                            .fill(SwiftUI.Color.atomic(.coolNeutral30).opacity(0.61))
                    } else {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .frame(width: circleDiameter, height: circleDiameter)
            }
    }
    
    // MARK: - Modifiers
    private var size: Size = .medium
    private var alternative = false
    
    /// 재생 배지의 크기를 설정합니다.
    ///
    /// - Parameters:
    ///   - size: 적용할 배지 크기
    /// - Returns: 수정된 PlayBadge 인스턴스
    ///
    /// - Note: 기본값은 `.medium`입니다.
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 대체 스타일을 적용합니다.
    ///
    /// 기본 스타일은 반투명 배경을 사용하고, 대체 스타일은 불투명한 회색 배경을 사용합니다.
    ///
    /// - Parameters:
    ///   - alternative: 대체 스타일 적용 여부 (기본값: true)
    /// - Returns: 수정된 PlayBadge 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다.
    public func alternative(_ alternative: Bool = true) -> Self {
        var zelf = self
        zelf.alternative = alternative
        return zelf
    }
    
    // MARK: - private
    private var circleDiameter: CGFloat {
        switch size {
        case .small: 36
        case .medium: 60
        case .large: 80
        }
    }
    
    private var playIconSize: CGSize {
        switch size {
        case .small: CGSize(width: 24, height: 24)
        case .medium: CGSize(width: 40, height: 40)
        case .large: CGSize(width: 56, height: 56)
        }
    }
}
