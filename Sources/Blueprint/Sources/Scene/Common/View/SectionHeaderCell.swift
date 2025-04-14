//
//  SectionHeaderCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/19.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import SnapKit
import Montage

final class SectionHeaderCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private lazy var headerTextLabel: UILabel = {
        let view = UILabel()
        view.font = .montage(variant: .body1, weight: .bold)
        view.textColor = .semantic(.labelNormal)
        return view
    }()
    
    var title: String = "" {
        didSet {
            headerTextLabel.text = title
        }
    }
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(headerTextLabel)
        
        headerTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
