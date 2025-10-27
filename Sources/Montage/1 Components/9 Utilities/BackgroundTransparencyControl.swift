//
//  BackgroundTransparencyControl.swift
//  Views
//
//  Created by 김삼열 on 10/27/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import Foundation
    
/// TopNavigation과 ActionArea의 배경 투명도를 제어하는 열거형입니다.
public enum BackgroundTransparencyControl {
    /// 자동으로 배경 투명도를 결정합니다. 기본적으로 스크롤 위치나 콘텐츠에 따라 투명도가 자동 처리됩니다.
    case automatic
    /// 수동으로 배경 투명도를 설정합니다. true면 배경이 표시되고, false면 배경이 투명해집니다.
    case manual(_ visible: Bool)
    
    var isManual: Bool {
        switch self {
        case .automatic:
            false
        case .manual:
            true
        }
    }
}
