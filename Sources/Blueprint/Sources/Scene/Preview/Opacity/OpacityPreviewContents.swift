//
//  OpacityPreviewContents.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/03/15.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage

final class OpacityPreviewContents {
    private let items: [Opacity] = [
        .p000, .p005, .p008, .p012, .p016, .p022, .p028, .p035,
        .p043, .p052, .p061, .p074, .p088, .p097, .p100
    ].reversed()
    
    var currentSliderValue: Float = 0
    
    var selectedColor: UIColor = .semantic(.primaryNormal)
    
    var opacityCount: Int {
        items.count
    }
    
    var currentOpacityIndex: Int {
        Int(Float(opacityCount) * currentSliderValue)
    }
    
    var currentOpacity: CGFloat {
        return .opacity(items[safe: currentOpacityIndex] ?? .p000)
    }
    
    var currentOpacityName: String {
        String(describing: (items[safe: currentOpacityIndex] ?? .p000))
    }
}
