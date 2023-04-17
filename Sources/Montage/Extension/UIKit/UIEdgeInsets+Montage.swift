//
//  UIEdgeInsets+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/13.
//

import UIKit

extension UIEdgeInsets {
    var horizontal: CGFloat {
        left + right
    }

    var vertical: CGFloat {
        top + bottom
    }
}
