//
//  UIImage+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//

import UIKit

extension UIImage {
    private static func load(name: String) -> UIImage {
        UIImage(named: name, in: DesignSystem.bundle, with: nil) ?? UIImage()
    }

    public static func designSystem(_ type: DesignSystem.Icon) -> UIImage {
        load(name: type.name)
    }
}
