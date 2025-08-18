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
/// ```swift
/// // UIKit에서 사용
/// let label = UILabel()
/// label.font = UIFont.font(.body1, .regular)
///
/// // SwiftUI에서 사용
/// Text("Hello, World!")
///     .typography.heading1, .bold)
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
    public enum Weight: CaseIterable {
        /// 일반 두께
        case regular
        /// 중간 두께
        case medium
        /// 굵은 두께
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
        /// 가장 큰 디스플레이 텍스트
        case display1
        /// 큰 디스플레이 텍스트
        case display2
        /// 중간 디스플레이 텍스트
        case display3
        /// 대제목
        case title1
        /// 중간 제목
        case title2
        /// 소제목
        case title3
        /// 주요 헤딩
        case heading1
        /// 보조 헤딩
        case heading2
        /// 강조 헤드라인
        case headline1
        /// 일반 헤드라인
        case headline2
        /// 기본 본문 텍스트
        case body1
        /// 긴 텍스트용 본문
        case body1Reading
        /// 작은 본문 텍스트
        case body2
        /// 긴 텍스트용 작은 본문
        case body2Reading
        /// 라벨 텍스트
        case label1
        /// 긴 텍스트용 라벨
        case label1Reading
        /// 작은 라벨 텍스트
        case label2
        /// 캡션 텍스트
        case caption1
        /// 작은 캡션 텍스트
        case caption2
        
        /// 각 변형에 대한 폰트 크기
        public var fontSize: CGFloat {
            switch self {
            case .display1:
                56
            case .display2:
                40
            case .display3:
                36
            case .title1:
                32
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
        
        /// 각 변형에 대한 자간 (letter spacing)
        public var tracking: CGFloat {
            let sementicSize = fontSize
            let letterSpacingEm: CGFloat
            
            switch self {
            case .display1:
                letterSpacingEm = -0.0319
            case .display2:
                letterSpacingEm = -0.0282
            case .display3:
                letterSpacingEm = -0.027
            case .title1:
                letterSpacingEm = -0.0253
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
        
        /// 각 변형에 대한 행 높이
        public var lineHeight: CGFloat {
            switch self {
            case .display1:
                72
            case .display2:
                52
            case .display3:
                48
            case .title1:
                44
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
        
        /// 각 변형에 대한 폰트 높이
        public var fontHeight: CGFloat {
            UIFont.pretendard(ofSize: fontSize, weight: .regular)?.fontHeight ?? 0
        }
        
        /// 각 변형에 대한 행간 높이
        public var lineSpacing: CGFloat {
            lineHeight - fontHeight
        }
    }

    static func getSementicWeight(variant: Variant, weight: Weight) -> Pretendard.Weight {
        switch (variant, weight) {
        case (.display3, .bold), (.title2, .bold), (.title3, .bold):
            .bold
        default:
            weight.pretendardWeight
        }
    }
    
    static func getFallbackWeight(variant: Variant, weight: Weight) -> UIFont.Weight {
        switch (variant, weight) {
        case (.display3, .bold), (.title2, .bold), (.title3, .bold):
            .bold
        default:
            weight.fallbackWeight
        }
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
    
    var fallbackWeight: UIFont.Weight {
        switch self {
        case .regular: .regular
        case .medium: .medium
        case .bold: .semibold
        }
    }
}

// MARK: - UIKit Font Extensions
public extension UIFont {
    /// Montage 디자인 시스템의 폰트를 생성합니다.
    ///
    /// - Parameters:
    ///   - size: 폰트 크기
    ///   - weight: 폰트 두께
    /// - Returns: 생성된 UIFont 인스턴스. 폰트를 찾을 수 없는 경우 nil 반환
    static func font(size: CGFloat, weight: Typography.Weight) -> UIFont? {
        UIFont(name: weight.pretendardWeight.fontName, size: size)
    }

    /// Montage 디자인 시스템의 폰트를 생성합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    /// - Returns: 생성된 UIFont 인스턴스. 폰트를 찾을 수 없는 경우 시스템 폰트로 대체
    static func font(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> UIFont {
        let sementicWeight = Typography.getSementicWeight(variant: variant, weight: weight)
        let failbackWeight = Typography.getFallbackWeight(variant: variant, weight: weight)
        let sementicSize = variant.fontSize
        return UIFont(name: sementicWeight.fontName, size: sementicSize) ??
            .systemFont(ofSize: sementicSize, weight: failbackWeight)
    }
}

// MARK: - SwiftUI Font Extensions
public extension Font {
    /// Montage 디자인 시스템의 폰트를 생성합니다.
    ///
    /// - Parameters:
    ///   - size: 폰트 크기
    ///   - weight: 폰트 두께
    /// - Returns: 생성된 Font 인스턴스
    static func font(size: CGFloat, weight: Typography.Weight) -> Font {
        .custom(weight.pretendardWeight.fontName, size: size)
    }

    /// Montage 디자인 시스템의 폰트를 생성합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    /// - Returns: 생성된 Font 인스턴스
    static func font(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular
    ) -> Font? {
        let sementicWeight = Typography.getSementicWeight(variant: variant, weight: weight)
        let sementicSize = variant.fontSize
        return .custom(sementicWeight.fontName, size: sementicSize)
    }
}

// MARK: - UIKit Label Extensions
public extension UILabel {
    /// Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.
    ///
    /// - Parameters:
    ///   - string: 표시할 문자열
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    ///   - color: 색상
    /// - Returns: 생성된 UILabel 인스턴스
    static func label(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: UIColor = .semantic(.labelNormal)
    ) -> UILabel {
        let label = UIKit.UILabel()
        label.attributedText = .attributedString(
            string,
            variant: variant,
            weight: weight,
            color: SwiftUI.Color(uiColor: color)
        )
        return label
    }
    
    /// Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.
    ///
    /// - Parameters:
    ///   - string: 표시할 문자열
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    ///   - semantic: 시맨틱 색상
    /// - Returns: 생성된 UILabel 인스턴스
    static func label(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        semantic: Color.Semantic = .labelNormal
    ) -> UILabel {
        label(string, variant: variant, weight: weight, color: .semantic(semantic))
    }
    
    /// Montage 디자인 시스템의 스타일을 적용한 UILabel을 생성합니다.
    ///
    /// - Parameters:
    ///   - string: 표시할 문자열
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    ///   - atomic: 아토믹 색상
    /// - Returns: 생성된 UILabel 인스턴스
    static func label(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        atomic: Color.Atomic = .red0
    ) -> UILabel {
        label(string, variant: variant, weight: weight, color: .atomic(atomic))
    }
}

// MARK: - SwiftUI Text Extensions
public extension Text {
    /// Montage 디자인 시스템의 스타일을 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    ///   - color: 색상
    /// - Returns: 스타일이 적용된 Text 인스턴스
    func typography(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: SwiftUI.Color
    ) -> some View {
        font(.font(variant: variant, weight: weight))
            .tracking(variant.tracking)
            .foregroundColor(color)
            .lineSpacing(variant.lineSpacing).padding(.vertical, variant.lineSpacing / 2)
    }
    
    /// Montage 디자인 시스템의 스타일을 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    ///   - semantic: 시맨틱 색상
    /// - Returns: 스타일이 적용된 Text 인스턴스
    func typography(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        semantic: Color.Semantic = .labelNormal
    ) -> some View {
        typography(variant: variant, weight: weight, color: .semantic(semantic))
    }
    
    /// Montage 디자인 시스템의 스타일을 적용합니다.
    ///
    /// - Parameters:
    ///   - variant: 텍스트 변형
    ///   - weight: 폰트 두께
    ///   - atomic: 아토믹 색상
    /// - Returns: 스타일이 적용된 Text 인스턴스
    func typography(
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        atomic: Color.Atomic
    ) -> some View {
        typography(variant: variant, weight: weight, color: .atomic(atomic))
    }
}

// MARK: - SwiftUI View Extensions
public extension View {
    /// Montage 디자인 시스템의 단락 스타일을 적용합니다.
    ///
    /// - Parameter variant: 텍스트 변형
    /// - Returns: 단락 스타일이 적용된 View
    func paragraph(variant: Typography.Variant) -> some View {
        self
    }
}

/// Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성하는 확장입니다.
public extension NSAttributedString {
    /// Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.
    ///
    /// - Parameters:
    ///   - string: 변환할 문자열
    ///   - variant: 타이포그래피 변형 (기본값: .body1)
    ///   - weight: 폰트 두께 (기본값: .regular)
    ///   - color: 색상
    ///   - lineBreakMode: 줄바꿈 모드 (기본값: .byWordWrapping)
    /// - Returns: Montage 스타일이 적용된 NSAttributedString
    static func attributedString(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        color: SwiftUI.Color = .semantic(.labelNormal),
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        _montage(
            string,
            variant: variant,
            weight: weight,
            color: color.uiColor,
            lineBreakMode: lineBreakMode
        )
    }

    /// Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.
    ///
    /// - Parameters:
    ///   - string: 변환할 문자열
    ///   - variant: 타이포그래피 변형 (기본값: .body1)
    ///   - weight: 폰트 두께 (기본값: .regular)
    ///   - semantic: 의미론적 색상
    ///   - lineBreakMode: 줄바꿈 모드 (기본값: .byWordWrapping)
    /// - Returns: Montage 스타일이 적용된 NSAttributedString
    static func attributedString(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        semantic: Color.Semantic,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        attributedString(
            string,
            variant: variant,
            weight: weight,
            color: .semantic(semantic),
            lineBreakMode: lineBreakMode
        )
    }

    /// Montage 디자인 시스템의 타이포그래피를 적용한 NSAttributedString을 생성합니다.
    ///
    /// - Parameters:
    ///   - string: 변환할 문자열
    ///   - variant: 타이포그래피 변형 (기본값: .body1)
    ///   - weight: 폰트 두께 (기본값: .regular)
    ///   - atomic: 원자적 색상
    ///   - lineBreakMode: 줄바꿈 모드 (기본값: .byWordWrapping)
    /// - Returns: Montage 스타일이 적용된 NSAttributedString
    static func attributedString(
        _ string: String,
        variant: Typography.Variant = .body1,
        weight: Typography.Weight = .regular,
        atomic: Color.Atomic,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        attributedString(
            string,
            variant: variant,
            weight: weight,
            color: .atomic(atomic),
            lineBreakMode: lineBreakMode
        )
    }
}

private extension UIFont {
    /// 폰트의 실제 높이를 반환합니다 (가장 빠른 방법)
    var lineHeight: CGFloat {
        let baseLineHeight = ascender - descender
        
        // SwiftUI는 기본적으로 약간의 추가 여백을 포함
        // 일반적으로 1-2pt 정도의 추가 여백
        let additionalPadding: CGFloat = 0.2
        
        return baseLineHeight + additionalPadding
    }
    
    /// 폰트의 전체 높이를 반환합니다 (lineHeight + leading)
    var fontHeight: CGFloat {
        return lineHeight + leading
    }
}
