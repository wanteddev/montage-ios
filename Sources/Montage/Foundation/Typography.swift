//
//  Typography.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/13.
//

import SwiftUI
import UIKit
import Pretendard

extension Montage {
    public enum Typography {
        public enum Weight: CaseIterable {
            case regular
            case medium
            case bold
        }
        
        public enum Variant: CaseIterable {
            case display
            case title1
            case title2
            case heading1
            case heading2
            case body1
            case body1Reading
            case body2
            case body2Reading
            case label1
            case label2
            case caption1
            case caption2
        }
        
        public enum Size: CaseIterable {
            case small, large
        }
    }
}

public extension Montage.Typography.Weight {
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
}

public extension Montage.Typography {
    static func getSementicWeight(varient: Variant, weight: Weight) -> Pretendard.Weight {
        switch (varient, weight) {
        case (.display, .bold), (.title1, .bold), (.title2, .bold):
            return .bold
        default:
            return weight.pretendardWeight
        }
    }
    
    static func getSementicSize(varient: Variant, size: Size) -> CGFloat {
        switch varient {
        case .display:
            return size == .small ? 36 : 56
        case .title1:
            return size == .small ? 28 : 40
        case .title2:
            return size == .small ? 24 : 28
        case .heading1:
            return size == .small ? 20 : 22
        case .heading2:
            return size == .small ? 17 : 18
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
        case .label2:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        }
    }
}
