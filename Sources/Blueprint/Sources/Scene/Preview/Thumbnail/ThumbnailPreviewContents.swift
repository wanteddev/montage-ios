//
//  ThumbnailPreviewContents.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/12.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit

import Montage

class ThumbnailPreviewContents {
    let ratios: [Ratio] = [
        .r1x1, .r4x3, .r3x2, .r16x9, .r2x1, .r16x10, .r21x9, .r1_618x1, .r5x4
    ]
    
    var selectedImage: UIImage? = nil
    
    var showSelectedImage: Bool = false
    
    var isPortrait: Bool = false
}
