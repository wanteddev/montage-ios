//
//  UIWindow+.swift
//  Views
//
//  Created by 김삼열 on 2/17/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import UIKit

extension UIWindow {
    var safeAreaSize: CGSize {
        CGSize(width: frame.width - safeAreaInsets.horizontal, height: frame.height - safeAreaInsets.vertical)
    }
}
