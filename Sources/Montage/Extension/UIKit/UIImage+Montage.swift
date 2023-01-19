//
//  UIImage+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//

import UIKit

extension UIImage {
    private static func load(name: String) -> UIImage {
        UIImage(named: name, in: Montage.bundle, with: nil) ?? UIImage()
    }

    public static func montage(_ type: Montage.Icon) -> UIImage {
        load(name: type.name)
    }
}
