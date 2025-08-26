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
/// ```swift
/// // 기본 정사각형 썸네일
/// Thumbnail(urlString: imageURL, ratio: .r1x1)
///    .width(100)
///
/// // 16:9 비율의 둥근 모서리 썸네일
/// Thumbnail(urlString: imageURL, ratio: .r16x9)
///    .width(320)
///    .radius(true)
///
/// // 테두리가 있는 썸네일
/// Thumbnail(urlString: imageURL, ratio: .r1x1)
///    .width(50)
///    .border(true)
/// ```
///
/// - Note: 이미지 로딩에는 SDWebImage 라이브러리를 사용하며, 로드 실패 시 기본 플레이스홀더가 표시됩니다.
public struct Thumbnail: View {
    
    // MARK: - Ratio Enum
    
    /// 썸네일의 가로세로 비율을 정의하는 열거형입니다.
    ///
    /// 다양한 미디어 콘텐츠 유형에 맞는 여러 표준 비율을 제공합니다.
    /// 가로가 긴 비율(21:9, 16:9 등), 정사각형(1:1), 세로가 긴 비율(9:16, 1:2 등)을 지원합니다.
    ///
    /// ```swift
    /// // 와이드스크린 비디오용 썸네일
    /// Thumbnail(urlString: videoURL, ratio: .r16x9)
    ///    .width(320)
    ///
    /// // 모바일 세로 화면용 썸네일
    /// Thumbnail(urlString: storyURL, ratio: .r9x16)
    ///    .width(400)
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
        
        var rawValue: CGFloat {
            size.height / size.width
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
    
    private let urlString: String
    private let ratio: Ratio
    
    /// 썸네일을 초기화합니다.
    ///
    /// - Parameters:
    ///   - urlString: 로드할 이미지의 URL 문자열
    ///   - ratio: 적용할 가로세로 비율
    ///
    public init(urlString: String, ratio: Ratio) {
        self.urlString = urlString
        self.ratio = ratio
    }
    
    // MARK: - Modifiers
    
    private var radius = false
    private var border = false
    private var width: CGFloat?
    
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
    
    public func width(_ width: CGFloat) -> Self {
        var zelf = self
        zelf.width = width
        return zelf
    }
    
    // MARK: - Body
    
    @State private var proposedWidth: CGFloat = .zero
    
    public var body: some View {
        ZStack {
            SwiftUI.Color.clear
                .onGeometryChange(for: CGFloat.self, of: { $0.size.width }, action: { proposedWidth = $0 })
                
            WebImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(let error):
                    Image("placeholder", bundle: .module)
                        .resizable()
                        .scaledToFill()
                        .onAppear {
                            print(error)
                        }
                case .empty:
                    SwiftUI.Color.semantic(.fillAlternative)
                }
            }
            .if (thumbnailWidth > 0) {
                $0.frame(width: thumbnailWidth, height: thumbnailWidth * ratio.rawValue)
            }
            .clipped()
            .cornerRadius(radius ? 12 : 0)
            .overlay {
                RoundedRectangle(cornerRadius: radius ? 12 : 0)
                    .strokeBorder(SwiftUI.Color.semantic(.lineNormal), lineWidth: border ? 1 : 0)
            }
        }
    }
    
    private var thumbnailWidth: CGFloat {
        width ?? proposedWidth
    }
}
