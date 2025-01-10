//
//  CGImage+.swift
//  Views
//
//  Created by 김삼열 on 1/9/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import UIKit

extension CGImage {
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let provider = dataProvider else { return nil }
        let pixelData = provider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let count: CFIndex = CFDataGetLength(pixelData)
        let pixelInfoIndex: Int = ((Int(width) * Int(point.y)) + Int(point.x)) * 4
        guard pixelInfoIndex < count else { return nil }

        let r = Int(data[pixelInfoIndex])
        let g = Int(data[pixelInfoIndex + 1])
        let b = Int(data[pixelInfoIndex + 2])
        let a = CGFloat(data[pixelInfoIndex + 3]) / CGFloat(255.0)
        return UIColor.rgb(r, g, b, a)
    }
}
