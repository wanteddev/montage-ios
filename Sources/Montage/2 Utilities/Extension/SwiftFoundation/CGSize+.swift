//
//  CGSize+.swift
//  Views
//
//  Created by 김삼열 on 8/18/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var isNegativeOrNonfinite: Bool {
        width < 0 || height < 0 || width == .infinity || height == .infinity
    }
}
