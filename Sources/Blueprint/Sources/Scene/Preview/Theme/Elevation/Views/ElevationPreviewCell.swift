//
//  ElevationPreviewCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/02/17.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage
import SnapKit

final class ElevationPreviewCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private enum Const {
        static let itemSize: CGSize = .init(width: 64, height: 64)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        return view
    }()
    
    private lazy var itemView: UIView = {
        let view = UIView()
        view.backgroundColor = .semantic(.backgroundElevated)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var itemWrapperView = UIView()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .font(variant: .title3, weight: .regular)
        view.textColor = .semantic(.labelStrong)
        return view
    }()
    
    override func setup() {
        super.setup()
        
        backgroundColor = .clear
        contentView.addSubview(stackView)
        itemWrapperView.addSubview(itemView)
        stackView.addArrangedSubview(itemWrapperView)
        stackView.addArrangedSubview(nameLabel)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        itemView.snp.makeConstraints {
            $0.size.equalTo(Const.itemSize)
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

extension ElevationPreviewCell {
    func configure(with viewModel: ElevationPreview.ViewModel.Item) {
        itemView.setElevation(viewModel.elevation)
        nameLabel.text = viewModel.name
    }
}
