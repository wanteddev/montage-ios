//
//  Avatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SDWebImageSwiftUI
import SwiftUI

/// 사용자, 회사, 학원의 프로필 이미지를 표시하는 아바타 컴포넌트입니다.
///
/// 원형 또는 둥근 모서리 사각형 형태로 프로필 이미지를 표시합니다.
/// 이미지 URL이 유효하지 않을 경우 각 유형별 기본 이미지를 표시합니다.
///
/// ```swift
/// // 기본 사용자 아바타
/// Avatar("https://example.com/profile.jpg", variant: .person)
///
/// // 테두리가 있는 회사 아바타
/// Avatar("https://example.com/company-logo.png", variant: .company, size: .medium)
///     .border(color: .red, width: 2)
///
/// // 푸시 알림 표시가 있는 아바타
/// Avatar("https://example.com/profile.jpg", variant: .person)
///     .pushBadge()
/// ```
///
/// - Note: 이미지 로딩은 SDWebImage를 통해 처리되며, 탭 상호작용을 지원합니다.
public struct Avatar: View {
    // MARK: - Types
    
    /// 아바타의 유형을 정의하는 열거형입니다.
    public enum Variant {
        /// 사용자 프로필 (원형)
        case person
        /// 회사 프로필 (둥근 모서리 사각형)
        case company
        /// 학원 프로필 (둥근 모서리 사각형)
        case academy
        
        fileprivate var placeholderImageName: String {
            switch self {
            case .person:
                "avatarPlaceholderPerson"
            case .company:
                "avatarPlaceholderCompany"
            case .academy:
                "avatarPlaceholderAcademy"
            }
        }
        
        internal func cornerRadius(size: Size) -> CGFloat {
            switch self {
            case .person: 1000
            default:
                switch size {
                case .xsmall: 6
                case .small: 8
                case .medium: 10
                case .large: 12
                case .xlarge: 14
                }
            }
        }
        
        internal func interactionCornerRadius(size: Size) -> CGFloat {
            switch self {
            case .person: 1000
            default: cornerRadius(size: size) + 8
            }
        }
    }
    
    /// 아바타의 크기를 정의하는 열거형입니다.
    public enum Size {
        /// 가장 작은 크기
        case xsmall
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 큰 크기
        case large
        /// 가장 큰 크기
        case xlarge
        
        internal var containerSize: CGSize {
            switch self {
            case .xsmall: .init(width: 24, height: 24)
            case .small: .init(width: 32, height: 32)
            case .medium: .init(width: 40, height: 40)
            case .large: .init(width: 48, height: 48)
            case .xlarge: .init(width: 56, height: 56)
            }
        }
        
        fileprivate var interactionSize: CGSize {
            .init(width: containerSize.width + 16, height: containerSize.height + 16)
        }
        
        fileprivate var badgeSize: CGSize {
            switch self {
            case .xsmall, .small: .init(width: 20, height: 20)
            case .medium: .init(width: 22, height: 22)
            case .large, .xlarge: .init(width: 24, height: 24)
            }
        }
    }
    
    // MARK: - Initializer
    
    private let imageUrl: String
    private let variant: Variant
    private let size: Size
    private let onTap: (() -> Void)?
    
    /// 아바타를 초기화합니다.
    ///
    /// - Parameters:
    ///   - imageUrl: 표시할 이미지의 URL 문자열
    ///   - variant: 아바타 유형 (.person, .company, .academy)
    ///   - size: 아바타 크기 (기본값: .small)
    ///   - onTap: 탭 시 실행할 액션 (기본값: nil)
    public init(_ imageUrl: String, variant: Variant, size: Size = .small, onTap: (() -> Void)? = nil) {
        self.imageUrl = imageUrl
        self.variant = variant
        self.size = size
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    
    public var body: some View {
        WebImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .backgroundStyle(SwiftUI.Color.semantic(.staticWhite))
        } placeholder: {
            Image(variant.placeholderImageName, bundle: .module)
                .resizable()
                .background( // WebImage에서 placeholder가 두 장 겹쳐지는 문제가 있어서 흰색 배경을 깔아줌
                    SwiftUI.Color.semantic(.backgroundNormal)
                )
        }
        .frame(width: size.containerSize.width, height: size.containerSize.height)
        .overlay {
            RoundedRectangle(cornerRadius: variant.cornerRadius(size: size))
                .strokeBorder(borderColor, lineWidth: borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: variant.cornerRadius(size: size)))
        .if(pushBadge && variant == .person) { $0.pushBadge(variant: .dot, size: pushBadgeSize) }
        .background {
            if !interactionDisabled {
                Interaction(
                    state: isPressed ? .pressed : .normal,
                    variant: .normal,
                    color: .labelNormal
                )
                .frame(width: size.interactionSize.width, height: size.interactionSize.height)
                .clipShape(RoundedRectangle(cornerRadius: variant.interactionCornerRadius(size: size)))
            }
        }
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: onTap))
    }
    
    private var pushBadge = false
    private var borderColor: SwiftUI.Color = .semantic(.lineAlternative)
    private var borderWidth: CGFloat = 1
    private var interactionDisabled = false
    
    /// 푸시 알림 표시 뱃지를 아바타에 추가합니다.
    ///
    /// 푸시 뱃지는 사용자(.person) 아바타에만 적용 가능합니다.
    ///
    /// - Parameter pushBadge: 뱃지 표시 여부 (기본값: true)
    /// - Returns: 수정된 아바타 인스턴스
    public func pushBadge(_ pushBadge: Bool = true) -> Self {
        var zelf = self
        zelf.pushBadge = pushBadge
        return zelf
    }
    
    /// 아바타에 테두리를 추가합니다.
    ///
    /// - Parameters:
    ///   - color: 테두리 색상 (기본값: .semantic(.lineAlternative))
    ///   - width: 테두리 두께 (기본값: 1)
    /// - Returns: 수정된 아바타 인스턴스
    public func border(color: SwiftUI.Color = .semantic(.lineAlternative), width: CGFloat = 1) -> Self {
        var zelf = self
        zelf.borderColor = color
        zelf.borderWidth = width
        return zelf
    }
    
    internal func interactionDisabled(_ interactionDisabled: Bool = true) -> Self {
        var zelf = self
        zelf.interactionDisabled = interactionDisabled
        return zelf
    }
}

private extension Avatar {
    var pushBadgeSize: PushBadge.Size {
        switch size {
        case .xsmall, .small: return .xsmall
        case .medium, .large: return .small
        case .xlarge: return .medium
        }
    }
}
