//
//  ReusableView+.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/02.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
