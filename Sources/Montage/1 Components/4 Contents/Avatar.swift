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
/// 이미지 URL이 유효하지 않을 경우 각 유형별 기본 아이콘을 표시합니다.
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
        
        var accessibilityDescription: String {
            switch self {
            case .person: String(localized: "프로필 이미지", bundle: .module)
            case .company: String(localized: "회사 로고", bundle: .module)
            case .academy: String(localized: "학원 로고", bundle: .module)
            }
        }

        fileprivate var placeholderIcon: Icon {
            switch self {
            case .person:
                .personFill
            case .company:
                .companyFill
            case .academy:
                .graduationFill
            }
        }
        
        internal func cornerRadius(size: Size) -> CGFloat {
            switch self {
            case .person: 1000
            default:
                switch size {
                case .xsmall: 8
                case .small: 10
                case .medium: 12
                case .large: 14
                case .xlarge: 16
                case .custom(let value): ceil(value * 0.25 / 2) * 2 + 2
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
        /// - cornerRadius (company/academy): 크기의 25%에 +2 (짝수로 올림 보정)
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
            .if(pushBadge) {
                $0.pushBadge(
                    variant: .dot,
                    size: pushBadgeSize,
                    outlineBorder: true,
                    inset: pushBadgeInset
                )
            }
            .background {
                if !interactionDisabled {
                    Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .normal,
                        color: .foregroundNeutralPrimary
                    )
                    .frame(width: size.interactionSize.width, height: size.interactionSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: resolvedInteractionCornerRadius))
                }
            }
            .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: onTap))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(variant.accessibilityDescription)
            .if(onTap != nil) { $0.accessibilityAddTraits(.isButton) }
    }

    private var pushBadge = false
    private var pushBadgeSizeOverride: PushBadge.Size?
    private var customCornerRadius: CGFloat?
    private var contentMode: ContentMode = .fit
    private var borderColor: SwiftUI.Color = .semantic(.lineNeutralTertiary)
    private var borderWidth: CGFloat = 1
    private var interactionDisabled = false
    /// 푸시 알림 표시 뱃지를 아바타에 추가합니다.
    ///
    /// 모든 유형(.person, .company, .academy)의 아바타에 적용할 수 있습니다.
    /// 뱃지는 배경과 분리되도록 아웃라인 보더(outlineBorder)가 기본 적용되며, 유형·크기에 따라 부착 위치가 안쪽으로 보정됩니다.
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
    /// `.person` variant는 항상 원형이므로 이 modifier가 적용되지 않습니다.
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
    ///   - color: 테두리 색상, 생략하면 기본값으로 `.semantic(.lineNeutralTertiary)` 적용
    ///   - width: 테두리 두께, 생략하면 기본값으로 `1` 적용
    /// - Returns: 수정된 아바타 인스턴스
    public func border(color: SwiftUI.Color = .semantic(.lineNeutralTertiary), width: CGFloat = 1) -> Self {
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
                    .background(SwiftUI.Color.semantic(.staticWhite))
            } placeholder: {
                placeholderContent
            }
        case .image(let image):
            image.resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }

    /// 이미지를 불러오지 못했을 때 표시하는 아이콘 기반 fallback입니다.
    ///
    /// 반투명한 `surfaceNeutralStrong` 위에 아이콘을 올리므로,
    /// 아래에 불투명한 `surfaceNeutralPrimary` 배경 레이어를 함께 깔아 줍니다.
    var placeholderContent: some View {
        Image.icon(variant.placeholderIcon)
            .resizable()
            .frame(width: placeholderIconSize, height: placeholderIconSize)
            .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(SwiftUI.Color.semantic(.surfaceNeutralStrong))
            .background(SwiftUI.Color.semantic(.surfaceNeutralPrimary))
    }

    var placeholderIconSize: CGFloat {
        size.containerSize.width / 1.5
    }

    var resolvedCornerRadius: CGFloat {
        if variant != .person, let customCornerRadius {
            return customCornerRadius
        }
        return variant.cornerRadius(size: size)
    }

    var resolvedInteractionCornerRadius: CGFloat {
        if variant != .person, let customCornerRadius {
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

    /// 뱃지를 아바타 바운딩 박스 코너에서 안쪽으로 들이는 여백(상단·우측 padding).
    ///
    /// - person(원형): 원형 45° 접점 기준(≈ 0.29 × 반지름). 24/32/40/48/56 → 4/5/6/7/8.
    /// - company·academy(둥근 사각): 24/32/40/48/56 → 2/3/4/4/5.
    /// 커스텀 크기는 각 유형의 비율로 산정한다.
    var pushBadgeInset: CGSize {
        let inset: CGFloat
        switch variant {
        case .person:
            switch size {
            case .xsmall: inset = 4
            case .small: inset = 5
            case .medium: inset = 6
            case .large: inset = 7
            case .xlarge: inset = 8
            case .custom(let value): inset = (value * 0.15).rounded()
            }
        case .company, .academy:
            switch size {
            case .xsmall: inset = 2
            case .small: inset = 3
            case .medium: inset = 4
            case .large: inset = 4
            case .xlarge: inset = 5
            case .custom(let value): inset = (value * 0.09).rounded()
            }
        }
        return .init(width: inset, height: inset)
    }
}
