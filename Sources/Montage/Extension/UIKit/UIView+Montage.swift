//
//  UIView+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import UIKit

public extension UIView {
    func setElevation(_ elevation: Montage.Elevation?)  {
        if let descriptor = elevation?.descriptor {
            layer.shadowColor = descriptor.color.withAlphaComponent(descriptor.alpha).cgColor
            layer.shadowRadius = descriptor.blur
            layer.shadowOffset = descriptor.offset
            layer.shadowOpacity = 1
        } else {
            // Layer의 기본 속성으로 돌려두기
            layer.shadowColor = nil
            layer.shadowRadius = 3
            layer.shadowOffset = .init(width: 0, height: -3)
            layer.shadowOpacity = 0
        }
    }
}
