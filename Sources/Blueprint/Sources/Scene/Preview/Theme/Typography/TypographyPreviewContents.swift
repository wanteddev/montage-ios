//
//  TypographyPreviewContents.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/02/01.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import Foundation
import Montage

struct TypographyPreviewContents {
    struct Combination {
        let weight: Typography.Weight
        let variant: Typography.Variant
    }
    
    private let varients = Typography.Variant.allCases
    
    var currentWeight: Typography.Weight = .regular
    var showMultiline: Bool
    var showBounds: Bool
    
    var combinations: [Combination] {
        varients.map { .init(weight: currentWeight, variant: $0) }
    }
    
    init() {
        self.showMultiline = true
        self.showBounds = false
    }
}
