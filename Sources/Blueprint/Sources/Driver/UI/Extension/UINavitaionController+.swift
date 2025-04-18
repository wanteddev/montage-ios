//
//  UINavitaionController+.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/16/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
