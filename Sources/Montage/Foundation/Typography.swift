//
//  Typography.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import Pretendard
import SwiftUI
import UIKit

/// Montage 디자인 시스템의 타이포그래피 체계
///
/// Typography는 Montage 디자인 시스템에서 사용되는 모든 텍스트 스타일을
/// 정의합니다. 폰트 크기, 두께, 자간, 행간 등 텍스트의 시각적 특성을
/// 일관되게 적용할 수 있도록 표준화된 타이포그래피 시스템을 제공합니다.
///
/// **사용 예시**:
/// ```swift
/// // UIKit에서 사용
/// let label = UILabel()
/// label.font = UIFont.montage(.body1, .regular)
///
/// // SwiftUI에서 사용
/// Text("Hello, World!")
///     .montage(.heading1, .bold)
/// ```
///
/// - Note: 텍스트 스타일을 적용할 때는 일관성을 위해 직접 폰트를 지정하기보다
///   Typography 시스템을 사용하는 것이 권장됩니다.
public enum Typography {
    /// 폰트 두께를 정의하는 열거형
    ///
    /// Weight는 텍스트의 시각적 강조를 위한 세 가지 기본 두께를 제공합니다.
    /// 텍스트의 중요도나 계층 구조에 따라 적절한 두께를 선택하여 사용합니다.
    ///
    /// - regular: 일반적인 본문 텍스트에 사용 (400)
    /// - medium: 중간 강조가 필요한 텍스트에 사용 (500)
    /// - bold: 강한 강조가 필요한 제목이나 중요 정보에 사용 (600/700)
    public enum Weight: CaseIterable {
        /// 일반 두께 (Regular, 400)
        case regular
        /// 중간 두께 (Medium, 500)
        case medium
        /// 굵은 두께 (SemiBold/Bold, 600/700)
        case bold
    }
    
    /// 텍스트 변형을 정의하는 열거형
    ///
    /// Variant는 텍스트의 용도와 계층 구조에 따라 서로 다른 사이즈, 
    /// 자간, 행간 값을 갖는 텍스트 스타일을 정의합니다.
    /// 
    /// **계층 구조**:
    /// - Display: 가장 크고 강조된 텍스트 (배너, 랜딩 페이지 등)
    /// - Title: 주요 제목 텍스트
    /// - Heading: 중간 크기의 제목 텍스트
    /// - Headline: 소제목 텍스트
    /// - Body: 기본 본문 텍스트
    /// - Label: 작은 텍스트 (버튼, 폼 레이블 등)
    /// - Caption: 가장 작은 보조 텍스트
    public enum Variant: CaseIterable {
        /// 가장 큰 디스플레이 텍스트 (56pt)
        case display1
        /// 큰 디스플레이 텍스트 (40pt)
        case display2
        /// 대제목 (36pt)
        case title1
        /// 중간 제목 (28pt)
        case title2
        /// 소제목 (24pt)
        case title3
        /// 주요 헤딩 (22pt)
        case heading1
        /// 보조 헤딩 (20pt)
        case heading2
        /// 강조 헤드라인 (18pt)
        case headline1
        /// 일반 헤드라인 (17pt)
        case headline2
        /// 기본 본문 텍스트 (16pt)
        case body1
        /// 긴 텍스트용 본문 (16pt, 높은 행간)
        case body1Reading
        /// 작은 본문 텍스트 (15pt)
        case body2
        /// 긴 텍스트용 작은 본문 (15pt, 높은 행간)
        case body2Reading
        /// 라벨 텍스트 (14pt)
        case label1
        /// 긴 텍스트용 라벨 (14pt, 높은 행간)
        case label1Reading
        /// 작은 라벨 텍스트 (13pt)
        case label2
        /// 캡션 텍스트 (12pt)
        case caption1
        /// 작은 캡션 텍스트 (11pt)
        case caption2
    }
}

public extension Typography.Weight {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .regular: .regular
        case .medium: .medium
        case .bold: .bold
        }
    }

    var fontWeight: Font.Weight {
        switch self {
        case .regular: .regular
        case .medium: .medium
        case .bold: .bold
        }
    }
    
    var pretendardWeight: Pretendard.Weight {
        switch self {
        case .regular: .regular
        case .medium: .medium
        case .bold: .semibold
        }
    }
    
    var failbackWeight: UIFont.Weight {
        switch self {
        case .regular: .regular
        case .medium: .medium
        case .bold: .semibold
        }
    }
}

public extension Typography {
    static func getSementicWeight(variant: Variant, weight: Weight) -> Pretendard.Weight {
        switch (variant, weight) {
        case (.title1, .bold), (.title2, .bold), (.title3, .bold):
            .bold
        default:
            weight.pretendardWeight
        }
    }
    
    static func getFailbackWeight(variant: Variant, weight: Weight) -> UIFont.Weight {
        switch (variant, weight) {
        case (.title1, .bold), (.title2, .bold), (.title3, .bold):
            .bold
        default:
            weight.failbackWeight
        }
    }
    
    static func getSementicSize(variant: Variant) -> CGFloat {
        switch variant {
        case .display1:
            56
        case .display2:
            40
        case .title1:
            36
        case .title2:
            28
        case .title3:
            24
        case .heading1:
            22
        case .heading2:
            20
        case .headline1:
            18
        case .headline2:
            17
        case .body1:
            16
        case .body1Reading:
            16
        case .body2:
            15
        case .body2Reading:
            15
        case .label1:
            14
        case .label1Reading:
            14
        case .label2:
            13
        case .caption1:
            12
        case .caption2:
            11
        }
    }
    
    static func getTracking(variant: Variant) -> CGFloat {
        let sementicSize = getSementicSize(variant: variant)
        let letterSpacingEm: CGFloat
        
        switch variant {
        case .display1:
            letterSpacingEm = -0.0319
        case .display2:
            letterSpacingEm = -0.0282
        case .title1:
            letterSpacingEm = -0.027
        case .title2:
            letterSpacingEm = -0.0236
        case .title3:
            letterSpacingEm = -0.023
        case .heading1:
            letterSpacingEm = -0.0194
        case .heading2:
            letterSpacingEm = -0.012
        case .headline1:
            letterSpacingEm = -0.002
        case .headline2:
            letterSpacingEm = 0
        case .body1:
            letterSpacingEm = 0.0057
        case .body1Reading:
            letterSpacingEm = 0.0057
        case .body2:
            letterSpacingEm = 0.0096
        case .body2Reading:
            letterSpacingEm = 0.0096
        case .label1:
            letterSpacingEm = 0.0145
        case .label1Reading:
            letterSpacingEm = 0.0145
        case .label2:
            letterSpacingEm = 0.0194
        case .caption1:
            letterSpacingEm = 0.0252
        case .caption2:
            letterSpacingEm = 0.0311
        }
        
        return sementicSize * letterSpacingEm
    }
    
    static func getLineHeight(variant: Variant) -> CGFloat {
        switch variant {
        case .display1:
            72
        case .display2:
            52
        case .title1:
            48
        case .title2:
            38
        case .title3:
            32
        case .heading1:
            30
        case .heading2:
            28
        case .headline1:
            26
        case .headline2:
            24
        case .body1:
            24
        case .body1Reading:
            26
        case .body2:
            22
        case .body2Reading:
            24
        case .label1:
            20
        case .label1Reading:
            22
        case .label2:
            18
        case .caption1:
            16
        case .caption2:
            14
        }
    }
}

public extension Typography.Variant {
    var lineSpacing: CGFloat {
        switch self {
        case .display1:
            5
        case .display2:
            4.6667
        case .title1:
            5
        case .title2:
            4.6667
        case .title3:
            3.3333
        case .heading1:
            3.6667
        case .heading2:
            4
        case .headline2:
            1.6667
        case .headline1:
            1.6667
        case .body1:
            5
        case .body1Reading:
            7
        case .body2:
            4
        case .body2Reading:
            6
        case .label1:
            3.3333
        case .label1Reading:
            5.3333
        case .label2:
            3.3333
        case .caption1:
            1.6667
        case .caption2:
            1
        }
    }
    
    var padding: CGFloat {
        lineSpacing / 2
    }
}
