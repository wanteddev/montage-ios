//
//  ColorChipCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/18.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage
import SnapKit

final class ColorChipCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private lazy var chipView: UIView = {
        let view = UIView()
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var transparentCheckView: UIView = {
        let view = UIView()
        view.backgroundColor = .atomic(.red50)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 13, weight: .bold)
        view.textColor = .secondaryLabel
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return view
    }()
    
    override func setup() {
        contentView.addSubview(stackView)
        
        let containerView = UIView()
        containerView.addSubview(transparentCheckView)
        containerView.addSubview(chipView)
        
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(nameLabel)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(chipView.snp.height)
        }
        
        chipView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        transparentCheckView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

extension ColorChipCell {
    func configure(with viewModel: ColorPreview.ViewModel.Item, usingTransparentChecker: Bool) {
        chipView.backgroundColor = viewModel.color
        nameLabel.text = viewModel.name
        nameLabel.textAlignment = viewModel.axis == .horizontal ? .left : .center
        stackView.axis = viewModel.axis
        stackView.spacing = viewModel.axis == .horizontal ? 10 : 0
        transparentCheckView.isHidden = false == usingTransparentChecker
        
        invalidateIntrinsicContentSize()
    }
}
