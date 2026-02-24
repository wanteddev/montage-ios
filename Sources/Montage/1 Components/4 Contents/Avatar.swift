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
                case .custom(let value): ceil(value * 0.25 / 2) * 2
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
        /// 커스텀 크기
        ///
        /// 커스텀 크기 사용 시 다음 규칙이 자동 적용됩니다:
        /// - pushBadge size: 36pt 이하 `.xsmall`, 37~52pt `.small`, 53pt 이상 `.medium`
        /// - cornerRadius (company/academy): 크기의 25% (짝수로 올림 보정)
        ///
        /// ``Avatar/cornerRadius(_:)``로 cornerRadius를 직접 지정하거나,
        /// ``Avatar/pushBadge(_:size:)``의 `size` 파라미터로 뱃지 크기를 직접 지정할 수 있습니다.
        case custom(CGFloat)

        internal var containerSize: CGSize {
            switch self {
            case .xsmall: .init(width: 24, height: 24)
            case .small: .init(width: 32, height: 32)
            case .medium: .init(width: 40, height: 40)
            case .large: .init(width: 48, height: 48)
            case .xlarge: .init(width: 56, height: 56)
            case .custom(let value): .init(width: value, height: value)
            }
        }

        fileprivate var interactionSize: CGSize {
            .init(width: containerSize.width + 16, height: containerSize.height + 16)
        }
    }
    
    enum ImageSource {
        case url(String)
        case image(Image)
    }

    // MARK: - Initializer

    private let imageSource: ImageSource
    private let variant: Variant
    private let size: Size
    private let onTap: (() -> Void)?

    /// URL 문자열로 아바타를 초기화합니다.
    ///
    /// - Parameters:
    ///   - imageUrl: 표시할 이미지의 URL 문자열
    ///   - variant: 아바타 유형 (.person, .company, .academy)
    ///   - size: 아바타 크기, 생략하면 기본값으로 `.small` 적용
    ///   - onTap: 탭 시 실행할 액션, 생략하면 기본값으로 `nil` 적용
    public init(_ imageUrl: String, variant: Variant, size: Size = .small, onTap: (() -> Void)? = nil) {
        self.imageSource = .url(imageUrl)
        self.variant = variant
        self.size = size
        self.onTap = onTap
    }

    /// SwiftUI Image로 아바타를 초기화합니다.
    ///
    /// - Parameters:
    ///   - image: 표시할 SwiftUI Image
    ///   - variant: 아바타 유형 (.person, .company, .academy)
    ///   - size: 아바타 크기, 생략하면 기본값으로 `.small` 적용
    ///   - onTap: 탭 시 실행할 액션, 생략하면 기본값으로 `nil` 적용
    public init(_ image: Image, variant: Variant, size: Size = .small, onTap: (() -> Void)? = nil) {
        self.imageSource = .image(image)
        self.variant = variant
        self.size = size
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        imageContent
            .frame(width: size.containerSize.width, height: size.containerSize.height)
            .overlay {
                RoundedRectangle(cornerRadius: resolvedCornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            }
            .clipShape(RoundedRectangle(cornerRadius: resolvedCornerRadius))
            .if(pushBadge && variant == .person) { $0.pushBadge(variant: .dot, size: pushBadgeSize) }
            .background {
                if !interactionDisabled {
                    Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .normal,
                        color: .labelNormal
                    )
                    .frame(width: size.interactionSize.width, height: size.interactionSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: resolvedInteractionCornerRadius))
                }
            }
            .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: onTap))
    }
    
    private var pushBadge = false
    private var pushBadgeSizeOverride: PushBadge.Size?
    private var customCornerRadius: CGFloat?
    private var contentMode: ContentMode = .fit
    private var borderColor: SwiftUI.Color = .semantic(.lineAlternative)
    private var borderWidth: CGFloat = 1
    private var interactionDisabled = false
    
    /// 푸시 알림 표시 뱃지를 아바타에 추가합니다.
    ///
    /// 푸시 뱃지는 사용자(.person) 아바타에만 적용 가능합니다.
    ///
    /// - Parameters:
    ///   - pushBadge: 뱃지 표시 여부, 생략하면 기본값으로 `true` 적용
    ///   - size: 뱃지 크기, 생략하면 아바타 크기에 따라 자동 결정
    /// - Returns: 수정된 아바타 인스턴스
    public func pushBadge(_ pushBadge: Bool = true, size: PushBadge.Size? = nil) -> Self {
        var zelf = self
        zelf.pushBadge = pushBadge
        zelf.pushBadgeSizeOverride = size
        return zelf
    }

    /// 아바타의 모서리 반경을 커스텀 값으로 설정합니다.
    ///
    /// - Parameter cornerRadius: 모서리 반경 값
    /// - Returns: 수정된 아바타 인스턴스
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        var zelf = self
        zelf.customCornerRadius = cornerRadius
        return zelf
    }

    /// 이미지의 콘텐츠 모드를 설정합니다.
    ///
    /// - Parameter contentMode: 콘텐츠 모드, `.fit` 또는 `.fill`
    /// - Returns: 수정된 아바타 인스턴스
    public func contentMode(_ contentMode: ContentMode) -> Self {
        var zelf = self
        zelf.contentMode = contentMode
        return zelf
    }

    /// 아바타에 테두리를 추가합니다.
    ///
    /// - Parameters:
    ///   - color: 테두리 색상, 생략하면 기본값으로 `.semantic(.lineAlternative)` 적용
    ///   - width: 테두리 두께, 생략하면 기본값으로 `1` 적용
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
    @ViewBuilder
    var imageContent: some View {
        switch imageSource {
        case .url(let imageUrl):
            WebImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: contentMode)
                    .backgroundStyle(SwiftUI.Color.semantic(.staticWhite))
            } placeholder: {
                Image(variant.placeholderImageName, bundle: .module)
                    .resizable()
                    .background(
                        SwiftUI.Color.semantic(.backgroundNormal)
                    )
            }
        case .image(let image):
            image.resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }

    var resolvedCornerRadius: CGFloat {
        customCornerRadius ?? variant.cornerRadius(size: size)
    }

    var resolvedInteractionCornerRadius: CGFloat {
        if let customCornerRadius {
            return customCornerRadius + 8
        }
        return variant.interactionCornerRadius(size: size)
    }

    var pushBadgeSize: PushBadge.Size {
        if let pushBadgeSizeOverride {
            return pushBadgeSizeOverride
        }
        switch size {
        case .xsmall, .small: return .xsmall
        case .medium, .large: return .small
        case .xlarge: return .medium
        case .custom(let value):
            if value <= 36 {
                return .xsmall
            } else if value <= 52 {
                return .small
            } else {
                return .medium
            }
        }
    }
}
