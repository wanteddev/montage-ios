//
//  IconPreviewCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/27.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage
import SnapKit

final class IconPreviewCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private enum Const {
        static let iconWrapperSize: CGSize = .init(width: 40, height: 40)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        return view
    }()
    
    private lazy var iconWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .semantic(.backgroundElevated)
        view.layer.cornerRadius = 12
        view.setElevation(.shadowNormal)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .semantic(.labelStrong)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .montage()
        view.textColor = .semantic(.labelStrong)
        return view
    }()
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconWrapperView)
        stackView.addArrangedSubview(nameLabel)
        iconWrapperView.addSubview(iconImageView)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        iconWrapperView.snp.makeConstraints {
            $0.width.equalTo(iconWrapperView.snp.height)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

extension IconPreviewCell {
    func configure(with viewModel: IconPreview.ViewModel.Item) {
        iconImageView.image = .montage(viewModel.icon)
        nameLabel.text = viewModel.icon.name
        
        updateAppearance(viewModel.appearance)
        
        invalidateIntrinsicContentSize()
    }
    
    func updateAppearance(_ appearance: IconPreview.ViewModel.Appearance) {
        stackView.spacing = appearance.titleSpacing
        
        iconImageView.snp.updateConstraints {
            $0.top.bottom.equalToSuperview().inset(appearance.iconInset)
        }
    }
}
