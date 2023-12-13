//
//  Typography.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import SwiftUI
import UIKit
import Pretendard

public enum Typography {
    /// 타이포의 굵기를 정의하는 파라미터입니다.
    /// Varient와 조합하여 어떤 폰트 Weight를 사용할 지 결정합니다.
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
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .bold
        }
    }

    var fontWeight: Font.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .bold
        }
    }
    
    var pretendardWeight: Pretendard.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .semibold
        }
    }
    
    var failbackWeight: UIFont.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .semibold
        }
    }
}

public extension Typography {
    static func getSementicWeight(varient: Variant, weight: Weight) -> Pretendard.Weight {
        switch (varient, weight) {
        case (.title1, .bold), (.title2, .bold), (.title3, .bold):
            return .bold
        default:
            return weight.pretendardWeight
        }
    }
    
    static func getFailbackWeight(varient: Variant, weight: Weight) -> UIFont.Weight {
        switch (varient, weight) {
        case (.title1, .bold), (.title2, .bold), (.title3, .bold):
            return .bold
        default:
            return weight.failbackWeight
        }
    }
    
    static func getSementicSize(varient: Variant) -> CGFloat {
        switch varient {
        case .display1:
            return 56
        case .display2:
            return 40
        case .title1:
            return 36
        case .title2:
            return 28
        case .title3:
            return 24
        case .heading1:
            return 22
        case .heading2:
            return 20
        case .headline1:
            return 18
        case .headline2:
            return 17
        case .body1:
            return 16
        case .body1Reading:
            return 16
        case .body2:
            return 15
        case .body2Reading:
            return 15
        case .label1:
            return 14
        case .label1Reading:
            return 14
        case .label2:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        }
    }
    
    static func getTracking(varient: Variant) -> CGFloat {
        let sementicSize = getSementicSize(varient: varient)
        let letterSpacingEm: CGFloat
        
        switch varient {
        case .display1:
            letterSpacingEm = -0.0319
        case .display2:
            letterSpacingEm = -0.0282
        case .title1:
            letterSpacingEm = -0.027
        case .title2:
            letterSpacingEm = -0.0246
        case .title3:
            letterSpacingEm = -0.023
        case .heading1:
            letterSpacingEm = -0.0194
        case .heading2:
            letterSpacingEm = -0.012
        case .headline1:
            letterSpacingEm = -0.001
        case .headline2:
            letterSpacingEm = -0.001
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
    
    static func getLineHeight(varient: Variant) -> CGFloat {
        switch varient {
        case .display1:
            return 72
        case .display2:
            return 52
        case .title1:
            return 48
        case .title2:
            return 38
        case .title3:
            return 32
        case .heading1:
            return 28
        case .heading2:
            return 26
        case .headline1:
            return 26
        case .headline2:
            return 24
        case .body1:
            return 24
        case .body1Reading:
            return 26
        case .body2:
            return 22
        case .body2Reading:
            return 24
        case .label1:
            return 20
        case .label1Reading:
            return 22
        case .label2:
            return 18
        case .caption1:
            return 16
        case .caption2:
            return 14
        }
    }
}

public extension Typography.Variant {
    var lineSpacing: CGFloat {
        switch self {
        case .display1:
            return 0
        case .display2:
            return 0
        case .title1:
            return 5
        case .title2:
            return 4.6667
        case .title3:
            return 3.3333
        case .heading1:
            return 2
        case .heading2:
            return 2
        case .headline2:
            return 1.6667
        case .headline1:
            return 1.6667
        case .body1:
            return 5
        case .body1Reading:
            return 7
        case .body2:
            return 4
        case .body2Reading:
            return 6
        case .label1:
            return 3.3333
        case .label1Reading:
            return 5.3333
        case .label2:
            return 3.3333
        case .caption1:
            return 1.6667
        case .caption2:
            return 1
        }
    }
    
    var padding: CGFloat {
        lineSpacing / 2
    }
}
