//
//  Logo.swift
//  
//
//  Created by GOOK HEE JUNG on 2023/09/14.
//

import Foundation


/// Montage 번들 내에 포함된 Logo 이름들입니다.

public enum Logo {
    case wantedCircleSymbol
    case wantedLogoHorizontal
    case wantedLogoVertical
    
    public var name: String {
        switch self {
        case .wantedCircleSymbol:
            return "wantedCircleSymbol"
        case .wantedLogoHorizontal:
            return "wantedLogoHorizontal"
        case .wantedLogoVertical:
            return "wantedLogoVertical"
        }
    }
}
