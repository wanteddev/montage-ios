//
//  UIView+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import UIKit

public extension UIView {
    func setElevation(_ elevation: Elevation?) {
        let elevation = elevation ?? .none
        let descriptor = elevation.descriptor

        if let color = descriptor.color {
            layer.shadowColor = color.withAlphaComponent(descriptor.alpha).cgColor
        } else {
            layer.shadowColor = nil
        }

        layer.shadowRadius = descriptor.blur
        layer.shadowOffset = descriptor.offset
        layer.shadowOpacity = elevation == .none ? 0 : 1
    }
}
