//
//  BaseCollectionViewCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/02.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle
        else { return }

        updateForUserInterfaceStyleChanged()

        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
        else { return }

        updateForColorAppearanceChanged()
    }

    func setup() {}
    
    func updateLayout() {}
    
    func updateForColorAppearanceChanged() {}

    func updateForUserInterfaceStyleChanged() {}
}
