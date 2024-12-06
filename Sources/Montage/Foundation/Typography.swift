//
//  Typography.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import Pretendard
import SwiftUI
import UIKit

public enum Typography {
    /// 타이포의 굵기를 정의하는 파라미터입니다.
    /// variant와 조합하여 어떤 폰트 Weight를 사용할 지 결정합니다.
    public enum Weight: CaseIterable {
        case regular
        case medium
        case bold
    }
    
    /// 타이포의 용도를 정의하는 파라미터입니다.
    /// 기본값은 .body1을 사용하고 있습니다.
    public enum Variant: CaseIterable {
        case display1
        case display2
        case title1
        case title2
        case title3
        case heading1
        case heading2
        case headline1
        case headline2
        case body1
        case body1Reading
        case body2
        case body2Reading
        case label1
        case label1Reading
        case label2
        case caption1
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
