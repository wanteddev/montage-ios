//
//  Thumbnail.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import SDWebImageSwiftUI
import SwiftUI

/// 다양한 비율로 이미지를 표시하는 썸네일 컴포넌트입니다.
///
/// `Thumbnail`은 원격 URL에서 이미지를 로드하여 지정된 비율과 크기로 표시합니다.
/// 이미지 로딩 상태에 따른 플레이스홀더를 지원하고, 둥근 모서리와 테두리 스타일을 적용할 수 있습니다.
///
/// **사용 예시**:
/// ```swift
/// // 기본 정사각형 썸네일
/// Thumbnail(url: imageURL)
///    .ratio(.r1x1, width: 100)
///
/// // 16:9 비율의 둥근 모서리 썸네일
/// Thumbnail(url: videoURL)
///    .ratio(.r16x9, width: 320)
///    .radius(true)
///
/// // 커스텀 플레이스홀더가 있는 썸네일
/// Thumbnail(
///    url: profileURL,
///    placeholder: {
///        Image.montage(.userPlaceholder)
///            .resizable()
///            .scaledToFit()
///    }
/// )
/// .ratio(.r1x1, height: 50)
/// .border(true)
/// ```
///
/// - Note: 이미지 로딩에는 SDWebImage 라이브러리를 사용하며, 로드 실패 시 기본 또는 커스텀 플레이스홀더가 표시됩니다.
public struct Thumbnail: View {
    
    // MARK: - Ratio Enum
    
    /// 썸네일의 가로세로 비율을 정의하는 열거형입니다.
    ///
    /// 다양한 미디어 콘텐츠 유형에 맞는 여러 표준 비율을 제공합니다.
    /// 가로가 긴 비율(21:9, 16:9 등), 정사각형(1:1), 세로가 긴 비율(9:16, 1:2 등)을 지원합니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// // 와이드스크린 비디오용 썸네일
    /// Thumbnail(url: videoURL)
    ///    .ratio(.r16x9, width: 320)
    ///
    /// // 모바일 세로 화면용 썸네일
    /// Thumbnail(url: storyURL)
    ///    .ratio(.r9x16, height: 400)
    /// ```
    ///
    /// - Note: 각 비율은 실제 픽셀 크기가 아닌 가로와 세로의 상대적 비율을 나타냅니다.
    public enum Ratio {
        /// 21:9 비율 (울트라와이드 영화)
        case r21x9
        /// 2:1 비율
        case r2x1
        /// 16:9 비율 (와이드스크린 비디오)
        case r16x9
        /// 황금비(1.618:1)
        case r1_618x1
        /// 16:10 비율 (와이드스크린 모니터)
        case r16x10
        /// 3:2 비율 (일부 사진)
        case r3x2
        /// 4:3 비율 (전통적인 TV, 모니터)
        case r4x3
        /// 5:4 비율
        case r5x4
        /// 1:1 비율 (정사각형)
        case r1x1
        /// 4:5 비율 (일부 소셜 미디어 이미지)
        case r4x5
        /// 3:4 비율
        case r3x4
        /// 2:3 비율 (일부 사진)
        case r2x3
        /// 10:16 비율
        case r10x16
        /// 역황금비(1:1.618)
        case r1x1_618
        /// 9:16 비율 (스마트폰 세로 화면)
        case r9x16
        /// 1:2 비율
        case r1x2
        /// 9:21 비율 (세로 울트라와이드)
        case r9x21
        
        /// 비율 값을 CGFloat로 반환합니다.
        ///
        /// - Returns: 가로 길이를 세로 길이로 나눈 값
        public var rawValue: CGFloat {
            size.width / size.height
        }
        
        /// 비율에 해당하는 크기를 반환합니다.
        ///
        /// - Note: 이 값은 상대적 비율을 나타내며 실제 픽셀 크기가 아닙니다.
        var size: CGSize {
            switch self {
            // 가로가 긴 비율
            case .r21x9: .init(width: 21, height: 9)
            case .r2x1: .init(width: 2, height: 1)
            case .r16x9: .init(width: 16, height: 9)
            case .r1_618x1: .init(width: 1.618, height: 1)
            case .r16x10: .init(width: 16, height: 10)
            case .r3x2: .init(width: 3, height: 2)
            case .r4x3: .init(width: 4, height: 3)
            case .r5x4: .init(width: 5, height: 4)
            
            // 정사각형
            case .r1x1: .init(width: 1, height: 1)
            
            // 세로가 긴 비율
            case .r4x5: .init(width: 4, height: 5)
            case .r3x4: .init(width: 3, height: 4)
            case .r2x3: .init(width: 2, height: 3)
            case .r10x16: .init(width: 10, height: 16)
            case .r1x1_618: .init(width: 1, height: 1.618)
            case .r9x16: .init(width: 9, height: 16)
            case .r1x2: .init(width: 1, height: 2)
            case .r9x21: .init(width: 9, height: 21)
            }
        }
    }
    
    // MARK: - Initializer
    
    private let url: URL?
    private let content: ((Image) -> any View)?
    private let placeholder: (() -> any View)?
    
    /// 썸네일을 초기화합니다.
    ///
    /// - Parameters:
    ///   - url: 로드할 이미지의 URL
    ///   - content: 이미지 로드 성공 시 이미지를 커스터마이징할 수 있는 클로저 (기본값: nil)
    ///   - placeholder: 이미지 로드 중이나 실패 시 표시할 플레이스홀더 뷰를 생성하는 클로저 (기본값: nil)
    ///
    /// - Note: placeholder가 nil이면 기본 배경색(.fillAlternative)이 사용됩니다.
    public init(
        url: URL?,
        content: ((Image) -> any View)? = nil,
        placeholder: (() -> any View)? = nil
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    // MARK: - Modifiers
    
    private var ratio: Ratio = .r1x1
    private var width: CGFloat? = nil
    private var height: CGFloat? = nil
    private var radius = false
    private var border = false
    
    /// 너비를 기준으로 썸네일의 비율을 설정합니다.
    ///
    /// 지정된 비율과 너비에 맞게 높이가 자동으로 계산됩니다.
    ///
    /// - Parameters:
    ///   - ratio: 적용할 가로세로 비율
    ///   - width: 썸네일의 너비 (포인트 단위)
    /// - Returns: 수정된 Thumbnail 인스턴스
    public func ratio(_ ratio: Ratio, width: CGFloat) -> Self {
        var zelf = self
        zelf.ratio = ratio
        zelf.width = width
        zelf.height = nil
        return zelf
    }
    
    /// 높이를 기준으로 썸네일의 비율을 설정합니다.
    ///
    /// 지정된 비율과 높이에 맞게 너비가 자동으로 계산됩니다.
    ///
    /// - Parameters:
    ///   - ratio: 적용할 가로세로 비율
    ///   - height: 썸네일의 높이 (포인트 단위)
    /// - Returns: 수정된 Thumbnail 인스턴스
    public func ratio(_ ratio: Ratio, height: CGFloat) -> Self {
        var zelf = self
        zelf.ratio = ratio
        zelf.width = nil
        zelf.height = height
        return zelf
    }
    
    /// 썸네일에 둥근 모서리를 적용합니다.
    ///
    /// - Parameters:
    ///   - radius: 둥근 모서리 적용 여부 (기본값: true)
    /// - Returns: 수정된 Thumbnail 인스턴스
    ///
    /// - Note: 적용 시 12포인트 반경의 둥근 모서리가 적용됩니다.
    public func radius(_ radius: Bool = true) -> Self {
        var zelf = self
        zelf.radius = radius
        return zelf
    }
    
    /// 썸네일에 테두리를 적용합니다.
    ///
    /// - Parameters:
    ///   - border: 테두리 적용 여부 (기본값: true)
    /// - Returns: 수정된 Thumbnail 인스턴스
    ///
    /// - Note: 적용 시 1포인트 두께의 .lineNormal 색상 테두리가 적용됩니다.
    public func border(_ border: Bool = true) -> Self {
        var zelf = self
        zelf.border = border
        return zelf
    }
    
    // MARK: - Body
    
    public var body: some View {
        WebImage(url: url) { phase in
            switch phase {
            case .success(let image):
                if let content {
                    AnyView(content(image))
                } else {
                    image
                        .resizable()
                        .scaledToFill()
                }
            default:
                SwiftUI.Color.clear
            }
        }
        .background {
            Group {
                if let placeholder {
                    AnyView(placeholder())
                } else {
                    SwiftUI.Color.semantic(.fillAlternative)
                }
            }
        }
        .modifying {
            if let width {
                $0.frame(width: width, height: width * (ratio.size.height / ratio.size.width))
            } else if let height {
                $0.frame(width: height * (ratio.size.width / ratio.size.height), height: height)
            } else {
                $0
            }
        }
        .clipped()
        .cornerRadius(radius ? 12 : 0)
        .overlay {
            RoundedRectangle(cornerRadius: radius ? 12 : 0)
                .strokeBorder(SwiftUI.Color.semantic(.lineNormal), lineWidth: border ? 1 : 0)
        }
    }
}

