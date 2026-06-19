//
//  UIImage+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//

import UIKit

extension UIImage {
    internal static func load(name: String, compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage {
        UIImage(named: name, in: Bundle.module, compatibleWith: traitCollection) ?? UIImage()
    }
}
