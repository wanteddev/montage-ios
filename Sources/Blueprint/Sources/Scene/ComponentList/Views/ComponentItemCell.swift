//
//  ComponentItemCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/02.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import SnapKit

final class ComponentItemCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    override func setup() {
        contentView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(from viewModel: ComponentList.ViewModel.Item) {
        textLabel.text = viewModel.name
        textLabel.textColor = viewModel.color
        textLabel.font = viewModel.font
    }
    
    func configure(attributedString: NSAttributedString) {
        textLabel.attributedText = attributedString
    }
}
